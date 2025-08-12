#!/bin/bash

# Force bash mode for better compatibility
# Note: Ne pas utiliser set -e car nous testons des cas d'erreur intentionnels
set -o pipefail  # Exit on pipe failure

# ============================================================================
# FONCTION DE COMPARAISON BASH/PIPEX COMPLÈTE
# ============================================================================

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Compteurs globaux
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Fonction utilitaire pour nettoyer les fichiers temporaires
cleanup_test_files() {
    rm -f bash_out_$$ pipex_out_$$ bash_err_$$ pipex_err_$$
    rm -f test_input_$$ valgrind_out_$$ timing_$$
    rm -f here_doc* 2>/dev/null
    # Nettoyer aussi les fichiers de sortie courants
    rm -f out*.txt bout*.txt heredoc*.txt multi*.txt advanced*.txt 2>/dev/null
}

# Fonction pour mesurer le temps d'exécution
measure_time() {
    local cmd="$1"
    local time_file="$2"
    
    { time $cmd; } 2> "$time_file"
}

# Fonction principale de comparaison
compare_bash_pipex() {
    local test_name="$1"
    local bash_cmd="$2"
    local pipex_cmd="$3"
    local input_data="$4"    # optionnel pour heredoc
    local expect_error="$5"  # "true" si on s'attend à une erreur
    local check_timing="$6"  # "true" pour vérifier le timing (tests avec sleep)
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    echo -e "\n${BLUE}=== $test_name ===${NC}"
    
    # Fichiers temporaires uniques
    local bash_out="bash_out_$$"
    local pipex_out="pipex_out_$$"
    local bash_err="bash_err_$$"
    local pipex_err="pipex_err_$$"
    local test_input="test_input_$$"
    local valgrind_out="valgrind_out_$$"
    local bash_time="bash_time_$$"
    local pipex_time="pipex_time_$$"
    
    # Préparer fichier d'entrée si nécessaire
    if [[ -n "$input_data" ]]; then
        echo -e "$input_data" > "$test_input"
    fi
    
    # Variables pour les résultats
    local bash_exit=0
    local pipex_exit=0
    local test_failed=0
    
    echo "Bash command: $bash_cmd"
    echo "Pipex command: $pipex_cmd"
    
    # ========================================================================
    # 1. EXÉCUTION BASH
    # ========================================================================
    
    if [[ -n "$input_data" ]]; then
        measure_time "echo -e '$input_data' | /bin/bash -c \"$bash_cmd\" > '$bash_out' 2>'$bash_err'" "$bash_time"
        echo -e "$input_data" | /bin/bash -c "$bash_cmd" > "$bash_out" 2>"$bash_err"
        bash_exit=$?
    else
        measure_time "/bin/bash -c \"$bash_cmd\" > '$bash_out' 2>'$bash_err'" "$bash_time"
        /bin/bash -c "$bash_cmd" > "$bash_out" 2>"$bash_err"
        bash_exit=$?
    fi
    
    # ========================================================================
    # 2. EXÉCUTION PIPEX AVEC VALGRIND
    # ========================================================================
    
    if [[ -n "$input_data" ]]; then
        measure_time "echo -e '$input_data' | valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-children=yes --track-fds=yes --error-exitcode=42 --log-file='$valgrind_out' $pipex_cmd > '$pipex_out' 2>'$pipex_err'" "$pipex_time"
        echo -e "$input_data" | valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-children=yes --track-fds=yes --error-exitcode=42 --log-file="$valgrind_out" $pipex_cmd > "$pipex_out" 2>"$pipex_err"
        pipex_exit=$?
    else
        measure_time "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-children=yes --track-fds=yes --error-exitcode=42 --log-file='$valgrind_out' $pipex_cmd > '$pipex_out' 2>'$pipex_err'" "$pipex_time"
        valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-children=yes --track-fds=yes --error-exitcode=42 --log-file="$valgrind_out" $pipex_cmd > "$pipex_out" 2>"$pipex_err"
        pipex_exit=$?
    fi
    
    # ========================================================================
    # 3. VÉRIFICATION VALGRIND
    # ========================================================================
    
    if [[ $pipex_exit -eq 42 ]]; then
        echo -e "${RED}✗ VALGRIND ERROR: Memory leak or invalid memory access detected${NC}"
        echo "Valgrind output:"
        cat "$valgrind_out"
        test_failed=1
    elif grep -q "ERROR SUMMARY: [1-9]" "$valgrind_out"; then
        echo -e "${RED}✗ VALGRIND WARNING: Some memory errors detected${NC}"
        grep "ERROR SUMMARY\|LEAK SUMMARY\|definitely lost\|indirectly lost\|possibly lost" "$valgrind_out"
        test_failed=1
    else
        # Vérifier les fuites de FD en filtrant les FDs système/VSCode
        local fd_leaks=$(grep "Open file descriptor" "$valgrind_out" | \
                        grep -v "/snap/code/" | \
                        grep -v "/dev/ptmx" | \
                        grep -v "/proc/" | \
                        grep -v "/sys/" | \
                        grep -v "v8_context_snapshot" | \
                        grep -v "/usr/share/code/" | \
                        grep -v "/tmp/.X11-unix/" | \
                        grep -v "/dev/tty" | \
                        grep -v "inherited from parent" | \
                        grep -v "\.cache/" | \
                        grep -v "\.config/" | \
                        grep -v "/home/.*/.vscode" | \
                        grep -v "socket:" | \
                        grep -v "pipe:" | \
                        grep -v "/dev/null" | \
                        grep -v "valgrind_out" | \
                        grep -v "bash_out" | \
                        grep -v "pipex_out" | \
                        grep -v "bash_err" | \
                        grep -v "pipex_err")
        
        if [[ -n "$fd_leaks" ]]; then
            echo -e "${RED}✗ VALGRIND WARNING: Application file descriptor leak detected${NC}"
            echo "$fd_leaks"
            test_failed=1
        else
            # Afficher les FDs système détectés (info uniquement)
            local system_fds=$(grep "Open file descriptor" "$valgrind_out")
            if [[ -n "$system_fds" ]]; then
                echo -e "${GREEN}✓ Valgrind: No application FD leaks (system FDs filtered)${NC}"
                echo -e "${YELLOW}  System FDs detected (ignored): $(echo "$system_fds" | wc -l)${NC}"
            else
                echo -e "${GREEN}✓ Valgrind: No memory leaks or FD leaks detected${NC}"
            fi
        fi
    fi
    
    # Ajuster le code de sortie pipex (enlever l'effet valgrind si pas d'erreur mémoire)
    if [[ $pipex_exit -ne 42 ]]; then
        # Si valgrind n'a pas détecté d'erreur, obtenir le vrai code de sortie
        if [[ -n "$input_data" ]]; then
            echo -e "$input_data" | $pipex_cmd > /dev/null 2>/dev/null
            pipex_exit=$?
        else
            $pipex_cmd > /dev/null 2>/dev/null
            pipex_exit=$?
        fi
    fi
    
    # ========================================================================
    # 4. COMPARAISON DES CODES DE SORTIE
    # ========================================================================
    echo "Bash exit code: $bash_exit"
    echo "Pipex exit code: $pipex_exit"
    
    if [[ $bash_exit -eq $pipex_exit ]]; then
        echo -e "${GREEN}✓ Exit codes match${NC}"
    else
        echo -e "${RED}✗ Exit codes differ (bash: $bash_exit, pipex: $pipex_exit)${NC}"
        test_failed=1
    fi
    
    # ========================================================================
    # 5. COMPARAISON DU CONTENU STDOUT
    # ========================================================================
    
    if diff -q "$bash_out" "$pipex_out" > /dev/null; then
        echo -e "${GREEN}✓ Stdout content matches${NC}"
    else
        echo -e "${RED}✗ Stdout content differs${NC}"
        echo "Bash output:"
        cat "$bash_out" | head -10
        echo "Pipex output:"
        cat "$pipex_out" | head -10
        echo "Diff:"
        diff "$bash_out" "$pipex_out" | head -10
        test_failed=1
    fi
    
    # ========================================================================
    # 6. COMPARAISON DES MESSAGES D'ERREUR
    # ========================================================================
    
    # Filtrer les messages valgrind du stderr pipex
    grep -v "==" "$pipex_err" > "${pipex_err}.clean" 2>/dev/null || touch "${pipex_err}.clean"
    
    if diff -q "$bash_err" "${pipex_err}.clean" > /dev/null; then
        echo -e "${GREEN}✓ Stderr content matches${NC}"
    else
        echo -e "${YELLOW}! Stderr content differs (might be normal for different error formats)${NC}"
        echo "Bash stderr:"
        cat "$bash_err" | head -5
        echo "Pipex stderr:"
        cat "${pipex_err}.clean" | head -5
        # Ne pas marquer comme échec car les formats d'erreur peuvent différer
    fi
    
    # ========================================================================
    # 7. COMPARAISON DES TEMPS D'EXÉCUTION (seulement pour les tests timing)
    # ========================================================================
    if [[ "$check_timing" == "true" ]]; then
        
        # Extraire les temps (format: real 0m0.123s)
        bash_real=$(grep "^real" "$bash_time" 2>/dev/null | awk '{print $2}' | sed 's/[ms]//g' | sed 's/0m//')
        pipex_real=$(grep "^real" "$pipex_time" 2>/dev/null | awk '{print $2}' | sed 's/[ms]//g' | sed 's/0m//')
        
        if [[ -n "$bash_real" && -n "$pipex_real" ]]; then
            echo "Bash time: ${bash_real}s"
            echo "Pipex time: ${pipex_real}s"
            
            # Convertir en millisecondes pour une comparaison plus précise
            bash_ms=$(echo "$bash_real * 1000" | bc -l 2>/dev/null || echo "0")
            pipex_ms=$(echo "$pipex_real * 1000" | bc -l 2>/dev/null || echo "0")
            
            # Vérifier que pipex n'est pas plus de 500ms plus lent que bash
            time_diff=$(echo "$pipex_ms - $bash_ms" | bc -l 2>/dev/null || echo "0")
            
            if (( $(echo "$time_diff <= 500" | bc -l 2>/dev/null || echo "1") )); then
                echo -e "${GREEN}✓ Execution time within acceptable range (±0.5s)${NC}"
            else
                echo -e "${YELLOW}! Pipex is significantly slower than expected${NC}"
                echo "Time difference: $(echo "scale=3; $time_diff / 1000" | bc -l)s"
                # Ne pas marquer comme échec car cela peut dépendre du système
            fi
        else
            echo -e "${YELLOW}! Could not measure execution times accurately${NC}"
        fi
    fi
    
    # ========================================================================
    # 8. RÉSULTAT FINAL DU TEST
    # ========================================================================
    
    cleanup_test_files
    rm -f "${pipex_err}.clean"
    
    # Nettoyer les fichiers de sortie pipex spécifiques au test
    if [[ "$pipex_cmd" =~ [[:space:]]([^[:space:]]+\.txt)[[:space:]]*$ ]]; then
        rm -f "${BASH_REMATCH[1]}" 2>/dev/null
    fi
    
    if [[ $test_failed -eq 0 ]]; then
        echo -e "${GREEN}✓ TEST PASSED: $test_name${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ TEST FAILED: $test_name${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Fonction pour afficher le résumé final
print_test_summary() {
    echo -e "\n${BLUE}=== TEST SUMMARY ===${NC}"
    echo -e "Total tests: $TESTS_TOTAL"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 ALL BONUS TESTS PASSED! 🎉${NC}"
        return 0
    else
        echo -e "\n${RED}❌ $TESTS_FAILED BONUS TEST(S) FAILED ❌${NC}"
        return 1
    fi
}

# ============================================================================
# SCRIPT DE TEST PIPEX - VERSION BONUS UNIQUEMENT
# ============================================================================

# Vérifier que nous sommes dans le bon répertoire
if [[ ! -f "../Makefile" ]]; then
    echo -e "${RED}Error: Not in pipex test directory. Please run from pipex/test/${NC}"
    exit 1
fi

echo -e "\n${BLUE}Starting pipex bonus tests...${NC}"

# Nettoyage initial pour partir sur une base propre
rm -f *.txt here_doc* bash_out_* pipex_out_* bash_err_* pipex_err_* test_input_* valgrind_out_* timing_* 2>/dev/null

# ============================================================================
# COMPILATION ET TEST VERSION BONUS
# ============================================================================

echo -e "\n${BLUE}=== TESTING BONUS VERSION ===${NC}"

# Compilation version bonus
echo -e "\n${YELLOW}Compiling bonus version...${NC}"
cd ..
if make re_bonus > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Bonus version compiled successfully${NC}"
else
    echo -e "${RED}✗ Bonus compilation failed${NC}"
    exit 1
fi
cd test

# Créer des fichiers de test
echo "hello world" > test_input.txt
echo -e "line1\nline2\nline3" > test_multiline.txt
echo "" > test_empty.txt

# ============================================================================
# TESTS STANDARD SUR VERSION BONUS (vérifier compatibilité)
# ============================================================================

echo -e "\n${BLUE}=== TESTING STANDARD FUNCTIONALITY ON BONUS VERSION ===${NC}"

# Test basique
compare_bash_pipex \
    "Bonus: Basic pipe test (standard format)" \
    "< test_input.txt cat | wc -w" \
    "../pipex test_input.txt cat \"wc -w\" bout1.txt"

# Test avec fichier inexistant
compare_bash_pipex \
    "Bonus: Nonexistent input file (standard format)" \
    "< nonexistent.txt cat | wc -l" \
    "../pipex nonexistent.txt cat \"wc -l\" bout2.txt"

# Test avec commande invalide
compare_bash_pipex \
    "Bonus: Invalid command (standard format)" \
    "< test_input.txt invalidcmd | cat" \
    "../pipex test_input.txt invalidcmd cat bout3.txt"

# Test timing avec sleep
compare_bash_pipex \
    "Bonus: Parallel execution timing (standard format)" \
    "< /dev/null sleep 1 | sleep 2" \
    "../pipex /dev/null \"sleep 1\" \"sleep 2\" bout4.txt" \
    "" \
    "" \
    "true"

# ============================================================================
# TESTS BONUS SPÉCIFIQUES - HEREDOC
# ============================================================================

echo -e "\n${BLUE}=== TESTING BONUS HEREDOC FUNCTIONALITY ===${NC}"

# Test heredoc basique
compare_bash_pipex \
    "Bonus: Basic heredoc" \
    "cat | wc -l" \
    "../pipex here_doc EOF cat \"wc -l\" heredoc1.txt" \
    "line1\nline2\nEOF"

# Test heredoc avec append
echo "existing content" > heredoc_append.txt
echo -e "new line\nEOF" | ../pipex here_doc EOF cat cat heredoc_append.txt 2>/dev/null
if grep -q "existing content" heredoc_append.txt && grep -q "new line" heredoc_append.txt; then
    echo -e "${GREEN}✓ Heredoc append mode works correctly${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Heredoc append mode failed${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Nettoyage après test heredoc append
rm -f heredoc_append.txt 2>/dev/null

# Test heredoc avec delimiter complexe
compare_bash_pipex \
    "Bonus: Heredoc with complex delimiter" \
    "cat | grep test" \
    "../pipex here_doc END_OF_INPUT cat \"grep test\" heredoc2.txt" \
    "test line\nother line\nEND_OF_INPUT"

# Test heredoc vide
compare_bash_pipex \
    "Bonus: Empty heredoc" \
    "cat | wc -l" \
    "../pipex here_doc EMPTY cat \"wc -l\" heredoc3.txt" \
    "EMPTY"

# Test heredoc avec délimiteurs variés
compare_bash_pipex \
    "Bonus: Heredoc with numeric delimiter" \
    "cat | wc -l" \
    "../pipex here_doc 123 cat \"wc -l\" heredoc_numeric.txt" \
    "test data\n123"

compare_bash_pipex \
    "Bonus: Heredoc with special delimiter" \
    "cat | grep test" \
    "../pipex here_doc STOP_HERE cat \"grep test\" heredoc_special.txt" \
    "test line\nother content\nSTOP_HERE"

compare_bash_pipex \
    "Bonus: Heredoc with single char delimiter" \
    "cat | wc -c" \
    "../pipex here_doc X cat \"wc -c\" heredoc_single.txt" \
    "hello\nX"

# ============================================================================
# TESTS BONUS SPÉCIFIQUES - MULTIPLE PIPES
# ============================================================================

echo -e "\n${BLUE}=== TESTING BONUS MULTIPLE PIPES FUNCTIONALITY ===${NC}"

# Test avec 3 commandes
compare_bash_pipex \
    "Bonus: Three commands pipeline" \
    "< test_multiline.txt cat | grep line | wc -l" \
    "../pipex test_multiline.txt cat \"grep line\" \"wc -l\" multi1.txt"

# Test avec 4 commandes
compare_bash_pipex \
    "Bonus: Four commands pipeline" \
    "< test_multiline.txt cat | grep line | cat | wc -l" \
    "../pipex test_multiline.txt cat \"grep line\" cat \"wc -l\" multi2.txt"

# Test multiple pipes avec commandes complexes
compare_bash_pipex \
    "Bonus: Multiple pipes with complex commands" \
    "< test_multiline.txt sort | uniq | grep line | wc -l" \
    "../pipex test_multiline.txt sort uniq \"grep line\" \"wc -l\" multi3.txt"

# Test de timing pour multiple pipes
compare_bash_pipex \
    "Bonus: Multiple pipes timing test" \
    "< /dev/null sleep 1 | sleep 1 | sleep 1" \
    "../pipex /dev/null \"sleep 1\" \"sleep 1\" \"sleep 1\" multi_timing.txt" \
    "" \
    "" \
    "true"

# ============================================================================
# TESTS BONUS AVANCÉS
# ============================================================================

echo -e "\n${BLUE}=== TESTING BONUS ADVANCED SCENARIOS ===${NC}"

# Test heredoc avec multiple pipes
echo -e "data1\ndata2\ndata3\nEOF" | ../pipex here_doc EOF cat "grep data" "wc -l" advanced1.txt 2>/dev/null
if [[ -f advanced1.txt ]] && [[ "$(cat advanced1.txt)" == "3" ]]; then
    echo -e "${GREEN}✓ Heredoc with multiple pipes works${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Heredoc with multiple pipes failed${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Nettoyage après test heredoc advanced
rm -f advanced1.txt 2>/dev/null

# Test timing pour multiple pipes avec fonction de comparaison
compare_bash_pipex \
    "Bonus: Advanced multiple pipes timing" \
    "< /dev/null sleep 2 | sleep 1 | sleep 1" \
    "../pipex /dev/null \"sleep 2\" \"sleep 1\" \"sleep 1\" advanced_timing.txt" \
    "" \
    "" \
    "true"

# Nettoyage final
rm -f test_*.txt bout*.txt heredoc*.txt multi*.txt advanced*.txt timing_test.txt multi_timing.txt advanced_timing.txt heredoc_append.txt
rm -f *.txt here_doc* bash_out_* pipex_out_* bash_err_* pipex_err_* test_input_* valgrind_out_* timing_* 2>/dev/null

# Afficher le résumé final
print_test_summary

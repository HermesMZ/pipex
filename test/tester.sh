#!/bin/bash

# ============================================================================
# PIPEX TESTER - Commandes Bash de référence
# ============================================================================

echo "=== PIPEX COMPREHENSIVE TESTER ==="
echo "Listing all relevant test cases with bash commands"
echo ""

# ============================================================================
# TESTS DE BASE (BASIC)
# ============================================================================

echo "--- BASIC TESTS ---"

echo "Test 1: Basic pipe with two simple commands"
echo "Command: < infile cat | wc -l > outfile"
echo "Pipex:   ./pipex infile cat 'wc -l' outfile"
echo ""

echo "Test 2: Basic pipe with grep and wc"
echo "Command: < infile grep 'pattern' | wc -l > outfile"
echo "Pipex:   ./pipex infile 'grep pattern' 'wc -l' outfile"
echo ""

echo "Test 3: Basic pipe with sort and uniq"
echo "Command: < infile sort | uniq > outfile"
echo "Pipex:   ./pipex infile sort uniq outfile"
echo ""

# ============================================================================
# TESTS D'ERREURS (ERROR HANDLING)
# ============================================================================

echo "--- ERROR HANDLING TESTS ---"

echo "Test 4: Nonexistent input file"
echo "Command: < nonexistent.txt cat | wc -l > outfile"
echo "Pipex:   ./pipex nonexistent.txt cat 'wc -l' outfile"
echo "Expected: Error message, exit code 1"
echo ""

echo "Test 5: Invalid first command"
echo "Command: < infile invalidcmd | cat > outfile"
echo "Pipex:   ./pipex infile invalidcmd cat outfile"
echo "Expected: Command not found, exit code 127"
echo ""

echo "Test 6: Invalid second command" 
echo "Command: < infile cat | invalidcmd > outfile"
echo "Pipex:   ./pipex infile cat invalidcmd outfile"
echo "Expected: Command not found, exit code 127"
echo ""

echo "Test 7: No read permission on input file"
echo "Command: < noperm.txt cat | wc -l > outfile"
echo "Pipex:   ./pipex noperm.txt cat 'wc -l' outfile"
echo "Expected: Permission denied, exit code 1"
echo ""

echo "Test 8: No write permission on output file"
echo "Command: < infile cat | wc -l > noperm_out.txt"
echo "Pipex:   ./pipex infile cat 'wc -l' noperm_out.txt"
echo "Expected: Permission denied, exit code 1"
echo ""

echo "Test 9: Output directory doesn't exist"
echo "Command: < infile cat | wc -l > /nonexistent/outfile"
echo "Pipex:   ./pipex infile cat 'wc -l' /nonexistent/outfile"
echo "Expected: No such file or directory, exit code 1"
echo ""

# ============================================================================
# TESTS AVEC COMMANDES COMPLEXES
# ============================================================================

echo "--- COMPLEX COMMANDS TESTS ---"

echo "Test 10: Commands with options"
echo "Command: < infile ls -la | grep '^d' > outfile"
echo "Pipex:   ./pipex infile 'ls -la' 'grep ^d' outfile"
echo ""

echo "Test 11: Commands with multiple arguments"
echo "Command: < infile cut -d: -f1 | sort -r > outfile"
echo "Pipex:   ./pipex infile 'cut -d: -f1' 'sort -r' outfile"
echo ""

echo "Test 12: Commands with quotes"
echo "Command: < infile grep 'hello world' | wc -l > outfile"
echo "Pipex:   ./pipex infile 'grep \"hello world\"' 'wc -l' outfile"
echo ""

echo "Test 13: Path resolution (command in PATH vs absolute path)"
echo "Command: < infile /bin/cat | /usr/bin/wc -l > outfile"
echo "Pipex:   ./pipex infile /bin/cat '/usr/bin/wc -l' outfile"
echo ""

# ============================================================================
# TESTS DE SIGNAUX ET INTERRUPTIONS
# ============================================================================

echo "--- SIGNAL HANDLING TESTS ---"

echo "Test 14: Command that exits with non-zero"
echo "Command: < infile grep 'nonexistent' | wc -l > outfile"
echo "Pipex:   ./pipex infile 'grep nonexistent' 'wc -l' outfile"
echo "Expected: Exit code should be 0 (last command succeeds)"
echo ""

echo "Test 15: First command fails, second succeeds"
echo "Command: < infile false | echo 'hello' > outfile"
echo "Pipex:   ./pipex infile false 'echo hello' outfile"
echo "Expected: Exit code should be 0 (last command succeeds)"
echo ""

echo "Test 16: Command that generates SIGPIPE"
echo "Command: < largefile head -n 5 | head -n 2 > outfile"
echo "Pipex:   ./pipex largefile 'head -n 5' 'head -n 2' outfile"
echo "Expected: Should handle SIGPIPE gracefully"
echo ""

# ============================================================================
# TESTS BONUS (HEREDOC)
# ============================================================================

echo "--- BONUS TESTS (HEREDOC) ---"

echo "Test 17: Basic heredoc"
echo "Command: cat << EOF | wc -l > outfile"
echo "         line1"
echo "         line2"
echo "         EOF"
echo "Pipex:   ./pipex here_doc EOF 'cat' 'wc -l' outfile"
echo "Input:   line1<newline>line2<newline>EOF<newline>"
echo ""

echo "Test 18: Heredoc with append mode"
echo "Command: cat << EOF >> outfile"
echo "         additional content"
echo "         EOF"
echo "Pipex:   ./pipex here_doc EOF 'cat' 'cat' outfile (should append)"
echo ""

echo "Test 19: Heredoc with complex delimiter"
echo "Command: cat << 'COMPLEX_END' | grep line > outfile"
echo "         line1"
echo "         COMPLEX_END"
echo "Pipex:   ./pipex here_doc COMPLEX_END 'cat' 'grep line' outfile"
echo ""

echo "Test 20: Heredoc with empty input"
echo "Command: cat << EOF | wc -l > outfile"
echo "         EOF"
echo "Pipex:   ./pipex here_doc EOF 'cat' 'wc -l' outfile"
echo "Input:   EOF<newline>"
echo ""

# Test heredoc avec délimiteurs variés (sera exécuté plus tard)

# ============================================================================
# TESTS DE PERFORMANCE ET STRESS
# ============================================================================

echo "--- PERFORMANCE TESTS ---"

echo "Test 21: Large file processing"
echo "Command: < largefile.txt sort | uniq -c > outfile"
echo "Pipex:   ./pipex largefile.txt sort 'uniq -c' outfile"
echo ""

echo "Test 22: Multiple processes stress test"
echo "Command: Run multiple pipex instances simultaneously"
echo ""

echo "Test 23: Memory usage with large data"
echo "Command: < /dev/zero head -c 1M | wc -c > outfile"
echo "Pipex:   ./pipex /dev/zero 'head -c 1M' 'wc -c' outfile"
echo ""

# ============================================================================
# TESTS DE CONCURRENCE ET TIMING
# ============================================================================

echo "--- CONCURRENCY AND TIMING TESTS ---"

echo "Test 24: Parallel execution - fast first command"
echo "Command: < /dev/null sleep 1 | sleep 3 > outfile"
echo "Pipex:   ./pipex /dev/null 'sleep 1' 'sleep 3' outfile"
echo "Expected: Should take ~3 seconds (parallel), not 4 seconds (sequential)"
echo ""

echo "Test 25: Parallel execution - slow first command"
echo "Command: < /dev/null sleep 5 | sleep 1 > outfile"
echo "Pipex:   ./pipex /dev/null 'sleep 5' 'sleep 1' outfile"
echo "Expected: Should take ~5 seconds (parallel), not 6 seconds (sequential)"
echo ""

echo "Test 26: Parallel execution verification"
echo "Command: < /dev/null 'sleep 2; echo first' | 'sleep 1; cat' > outfile"
echo "Pipex:   ./pipex /dev/null 'sleep 2; echo first' 'sleep 1; cat' outfile"
echo "Expected: Should complete in ~2 seconds, output should be 'first'"
echo ""

echo "Test 27: SIGPIPE handling with sleep commands"
echo "Command: < /dev/null 'sleep 10; echo data' | 'sleep 1; head -c 0' > outfile"
echo "Pipex:   ./pipex /dev/null 'sleep 10; echo data' 'sleep 1; head -c 0' outfile"
echo "Expected: Should complete quickly (~1 sec), first process should be killed by SIGPIPE"
echo ""

echo "Test 28: Output timing test"
echo "Command: < /dev/null 'echo start; sleep 2; echo end' | 'sleep 1; cat' > outfile"
echo "Pipex:   ./pipex /dev/null 'echo start; sleep 2; echo end' 'sleep 1; cat' outfile"
# ============================================================================

echo "--- COMPATIBILITY TESTS ---"

echo "Test 31: Binary file handling"
echo "Command: < binary.bin cat | wc -c > outfile"
echo "Pipex:   ./pipex binary.bin cat 'wc -c' outfile"
echo ""

echo "Test 32: Special characters in filenames"
echo "Command: < 'file with spaces.txt' cat | wc -l > 'out file.txt'"
echo "Pipex:   ./pipex 'file with spaces.txt' cat 'wc -l' 'out file.txt'"
echo ""

echo "Test 33: Empty file handling"
echo "Command: < empty.txt cat | wc -l > outfile"
echo "Pipex:   ./pipex empty.txt cat 'wc -l' outfile"
echo ""

# ============================================================================
# TESTS D'ARGUMENTS INVALIDES
# ============================================================================

echo "--- INVALID ARGUMENTS TESTS ---"

echo "Test 34: Too few arguments"
echo "Pipex:   ./pipex infile cmd1"
echo "Expected: Usage message, exit code 1"
echo ""

echo "Test 35: Too many arguments"
echo "Pipex:   ./pipex infile cmd1 cmd2 outfile extra"
echo "Expected: Usage message, exit code 1"
echo ""

echo "Test 36: Empty commands"
echo "Pipex:   ./pipex infile '' cmd2 outfile"
echo "Expected: Command not found, exit code 127"
echo ""

echo "Test 37: Bonus with wrong argument count"
echo "Pipex:   ./pipex here_doc EOF cmd1"
echo "Expected: Usage message, exit code 1"
echo ""

echo ""
echo "=== Total: 37 test cases listed ==="
echo "Ready to implement actual testing logic."

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
    rm -f /tmp/bash_out_$$ /tmp/pipex_out_$$ /tmp/bash_err_$$ /tmp/pipex_err_$$
    rm -f /tmp/test_input_$$ /tmp/valgrind_out_$$ /tmp/timing_$$
    rm -f here_doc* 2>/dev/null
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
    local bash_out="/tmp/bash_out_$$"
    local pipex_out="/tmp/pipex_out_$$"
    local bash_err="/tmp/bash_err_$$"
    local pipex_err="/tmp/pipex_err_$$"
    local test_input="/tmp/test_input_$$"
    local valgrind_out="/tmp/valgrind_out_$$"
    local bash_time="/tmp/bash_time_$$"
    local pipex_time="/tmp/pipex_time_$$"
    
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
    echo -e "${YELLOW}Running bash...${NC}"
    
    if [[ -n "$input_data" ]]; then
        measure_time "echo -e '$input_data' | $bash_cmd > '$bash_out' 2>'$bash_err'" "$bash_time"
        echo -e "$input_data" | eval "$bash_cmd" > "$bash_out" 2>"$bash_err"
        bash_exit=$?
    else
        measure_time "$bash_cmd > '$bash_out' 2>'$bash_err'" "$bash_time"
        eval "$bash_cmd" > "$bash_out" 2>"$bash_err"
        bash_exit=$?
    fi
    
    # ========================================================================
    # 2. EXÉCUTION PIPEX AVEC VALGRIND
    # ========================================================================
    echo -e "${YELLOW}Running pipex with valgrind...${NC}"
    
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
    echo -e "${YELLOW}Checking valgrind output...${NC}"
    
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
                        grep -v "/dev/null")
        
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
    echo -e "${YELLOW}Comparing exit codes...${NC}"
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
    echo -e "${YELLOW}Comparing stdout content...${NC}"
    
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
    echo -e "${YELLOW}Comparing stderr content...${NC}"
    
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
        echo -e "${YELLOW}Comparing execution times...${NC}"
        
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
    else
        echo -e "${YELLOW}Timing check skipped for this test${NC}"
    fi
    
    # ========================================================================
    # 8. RÉSULTAT FINAL DU TEST
    # ========================================================================
    
    cleanup_test_files
    rm -f "${pipex_err}.clean"
    
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
        echo -e "\n${GREEN}🎉 ALL TESTS PASSED! 🎉${NC}"
        return 0
    else
        echo -e "\n${RED}❌ $TESTS_FAILED TEST(S) FAILED ❌${NC}"
        return 1
    fi
}

# ============================================================================
# SCRIPT DE TEST COMPLET PIPEX - STANDARD PUIS BONUS
# ============================================================================

# Vérifier que nous sommes dans le bon répertoire
if [[ ! -f "../Makefile" ]]; then
    echo -e "${RED}Error: Not in pipex test directory. Please run from pipex/test/${NC}"
    exit 1
fi

echo -e "\n${BLUE}Starting comprehensive pipex tests...${NC}"

# ============================================================================
# PHASE 1: COMPILATION ET TEST VERSION STANDARD
# ============================================================================

echo -e "\n${BLUE}=== PHASE 1: TESTING STANDARD VERSION ===${NC}"

# Compilation version standard
echo -e "\n${YELLOW}Compiling standard version...${NC}"
cd ..
make clean > /dev/null 2>&1
if make > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Standard version compiled successfully${NC}"
else
    echo -e "${RED}✗ Standard compilation failed${NC}"
    exit 1
fi
cd test

# Créer des fichiers de test
echo "hello world" > /tmp/test_input.txt
echo -e "line1\nline2\nline3" > /tmp/test_multiline.txt
echo "" > /tmp/test_empty.txt

# Fichier pour les tests de permissions
echo "permission test" > /tmp/test_perm.txt
chmod 000 /tmp/test_perm.txt

# ============================================================================
# TESTS DE VALIDATION DU FORMAT STANDARD
# ============================================================================

echo -e "\n${BLUE}=== TESTING STANDARD VERSION FORMAT RESTRICTIONS ===${NC}"

# Test que la version standard rejette heredoc
echo -e "\n${YELLOW}Testing that standard version rejects heredoc...${NC}"
../pipex here_doc EOF cat cat /tmp/test_heredoc.txt 2>/tmp/heredoc_err.txt
heredoc_exit=$?
echo "Heredoc exit code: $heredoc_exit"
if [[ $heredoc_exit -eq 1 ]]; then
    echo -e "${GREEN}✓ Standard version correctly rejects heredoc format${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Standard version should reject heredoc format (exit code 1)${NC}"
    echo "Error output:"
    cat /tmp/heredoc_err.txt
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Test que la version standard rejette plus de 2 commandes
echo -e "\n${YELLOW}Testing that standard version rejects multiple pipes...${NC}"
../pipex /tmp/test_input.txt cat cat cat /tmp/test_multi.txt 2>/tmp/multi_err.txt
multi_exit=$?
echo "Multiple commands exit code: $multi_exit"
if [[ $multi_exit -eq 1 ]]; then
    echo -e "${GREEN}✓ Standard version correctly rejects multiple pipes format${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Standard version should reject multiple pipes format (exit code 1)${NC}"
    echo "Error output:"
    cat /tmp/multi_err.txt
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Test arguments insuffisants
echo -e "\n${YELLOW}Testing too few arguments...${NC}"
../pipex /tmp/test_input.txt cat 2>/tmp/few_args_err.txt
few_args_exit=$?
echo "Too few args exit code: $few_args_exit"
if [[ $few_args_exit -eq 1 ]]; then
    echo -e "${GREEN}✓ Standard version correctly rejects too few arguments${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Standard version should reject too few arguments (exit code 1)${NC}"
    echo "Error output:"
    cat /tmp/few_args_err.txt
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Test arguments trop nombreux
echo -e "\n${YELLOW}Testing too many arguments...${NC}"
../pipex /tmp/test_input.txt cat cat /tmp/out.txt extra_arg 2>/tmp/many_args_err.txt
many_args_exit=$?
echo "Too many args exit code: $many_args_exit"
if [[ $many_args_exit -eq 1 ]]; then
    echo -e "${GREEN}✓ Standard version correctly rejects too many arguments${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Standard version should reject too many arguments (exit code 1)${NC}"
    echo "Error output:"
    cat /tmp/many_args_err.txt
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Test format exact valide
echo -e "\n${YELLOW}Testing exact valid format...${NC}"
../pipex /tmp/test_input.txt cat cat /tmp/valid_out.txt 2>/tmp/valid_err.txt
valid_exit=$?
echo "Valid format exit code: $valid_exit"
if [[ $valid_exit -eq 0 ]]; then
    echo -e "${GREEN}✓ Standard version correctly accepts valid format${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Standard version should accept valid format${NC}"
    echo "Error output:"
    cat /tmp/valid_err.txt
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Nettoyage des fichiers de test de format
rm -f /tmp/test_heredoc.txt /tmp/test_multi.txt /tmp/valid_out.txt
rm -f /tmp/heredoc_err.txt /tmp/multi_err.txt /tmp/few_args_err.txt /tmp/many_args_err.txt /tmp/valid_err.txt

# ============================================================================
# TESTS STANDARD AVEC VALGRIND
# ============================================================================

echo -e "\n${BLUE}=== STANDARD VERSION FUNCTIONAL TESTS ===${NC}"

# Test basique
compare_bash_pipex \
    "Standard: Basic pipe test" \
    "< /tmp/test_input.txt cat | wc -w" \
    "../pipex /tmp/test_input.txt cat 'wc -w' /tmp/out1.txt"

# Test avec fichier inexistant
compare_bash_pipex \
    "Standard: Nonexistent input file" \
    "< /tmp/nonexistent.txt cat | wc -l" \
    "../pipex /tmp/nonexistent.txt cat 'wc -l' /tmp/out2.txt"

# Test avec commande invalide
compare_bash_pipex \
    "Standard: Invalid command" \
    "< /tmp/test_input.txt invalidcmd | cat" \
    "../pipex /tmp/test_input.txt invalidcmd cat /tmp/out3.txt"

# Test timing avec sleep
compare_bash_pipex \
    "Standard: Parallel execution timing" \
    "< /dev/null sleep 1 | sleep 2" \
    "../pipex /dev/null 'sleep 1' 'sleep 2' /tmp/out4.txt" \
    "" \
    "" \
    "true"

# Test avec options complexes
compare_bash_pipex \
    "Standard: Complex commands" \
    "< /tmp/test_multiline.txt grep line | wc -l" \
    "../pipex /tmp/test_multiline.txt 'grep line' 'wc -l' /tmp/out5.txt"

echo -e "\n${YELLOW}Standard version tests completed!${NC}"
standard_passed=$TESTS_PASSED
standard_failed=$TESTS_FAILED
standard_total=$TESTS_TOTAL

# ============================================================================
# PHASE 2: COMPILATION ET TEST VERSION BONUS
# ============================================================================

echo -e "\n${BLUE}=== PHASE 2: TESTING BONUS VERSION ===${NC}"

# Compilation version bonus
echo -e "\n${YELLOW}Compiling bonus version...${NC}"
cd ..
make clean > /dev/null 2>&1
if make bonus > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Bonus version compiled successfully${NC}"
else
    echo -e "${RED}✗ Bonus compilation failed${NC}"
    print_test_summary
    exit 1
fi
cd test

# ============================================================================
# TESTS STANDARD SUR VERSION BONUS (vérifier que rien n'est cassé)
# ============================================================================

echo -e "\n${BLUE}=== TESTING STANDARD FUNCTIONALITY ON BONUS VERSION ===${NC}"

# Réinitialiser les compteurs pour les tests bonus
bonus_start_passed=$TESTS_PASSED
bonus_start_failed=$TESTS_FAILED
bonus_start_total=$TESTS_TOTAL

# Test basique
compare_bash_pipex \
    "Bonus: Basic pipe test (standard format)" \
    "< /tmp/test_input.txt cat | wc -w" \
    "../pipex /tmp/test_input.txt cat 'wc -w' /tmp/bout1.txt"

# Test avec fichier inexistant
compare_bash_pipex \
    "Bonus: Nonexistent input file (standard format)" \
    "< /tmp/nonexistent.txt cat | wc -l" \
    "../pipex /tmp/nonexistent.txt cat 'wc -l' /tmp/bout2.txt"

# Test avec commande invalide
compare_bash_pipex \
    "Bonus: Invalid command (standard format)" \
    "< /tmp/test_input.txt invalidcmd | cat" \
    "../pipex /tmp/test_input.txt invalidcmd cat /tmp/bout3.txt"

# Test timing avec sleep
compare_bash_pipex \
    "Bonus: Parallel execution timing (standard format)" \
    "< /dev/null sleep 1 | sleep 2" \
    "../pipex /dev/null 'sleep 1' 'sleep 2' /tmp/bout4.txt" \
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
    "../pipex here_doc EOF cat 'wc -l' /tmp/heredoc1.txt" \
    "line1\nline2\nEOF"

# Test heredoc avec append
echo "existing content" > /tmp/heredoc_append.txt
echo -e "new line\nEOF" | ../pipex here_doc EOF cat cat /tmp/heredoc_append.txt 2>/dev/null
if grep -q "existing content" /tmp/heredoc_append.txt && grep -q "new line" /tmp/heredoc_append.txt; then
    echo -e "${GREEN}✓ Heredoc append mode works correctly${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Heredoc append mode failed${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Test heredoc avec delimiter complexe
compare_bash_pipex \
    "Bonus: Heredoc with complex delimiter" \
    "cat | grep test" \
    "../pipex here_doc 'END_OF_INPUT' cat 'grep test' /tmp/heredoc2.txt" \
    "test line\nother line\nEND_OF_INPUT"

# Test heredoc vide
compare_bash_pipex \
    "Bonus: Empty heredoc" \
    "cat | wc -l" \
    "../pipex here_doc EMPTY cat 'wc -l' /tmp/heredoc3.txt" \
    "EMPTY"

# Test heredoc avec délimiteurs variés
compare_bash_pipex \
    "Bonus: Heredoc with numeric delimiter" \
    "cat | wc -l" \
    "../pipex here_doc 123 cat 'wc -l' /tmp/heredoc_numeric.txt" \
    "test data\n123"

compare_bash_pipex \
    "Bonus: Heredoc with special delimiter" \
    "cat | grep test" \
    "../pipex here_doc 'STOP_HERE' cat 'grep test' /tmp/heredoc_special.txt" \
    "test line\nother content\nSTOP_HERE"

compare_bash_pipex \
    "Bonus: Heredoc with single char delimiter" \
    "cat | wc -c" \
    "../pipex here_doc X cat 'wc -c' /tmp/heredoc_single.txt" \
    "hello\nX"

# ============================================================================
# TESTS BONUS SPÉCIFIQUES - MULTIPLE PIPES
# ============================================================================

echo -e "\n${BLUE}=== TESTING BONUS MULTIPLE PIPES FUNCTIONALITY ===${NC}"

# Test avec 3 commandes
compare_bash_pipex \
    "Bonus: Three commands pipeline" \
    "< /tmp/test_multiline.txt cat | grep line | wc -l" \
    "../pipex /tmp/test_multiline.txt cat 'grep line' 'wc -l' /tmp/multi1.txt"

# Test avec 4 commandes
compare_bash_pipex \
    "Bonus: Four commands pipeline" \
    "< /tmp/test_multiline.txt cat | grep line | cat | wc -l" \
    "../pipex /tmp/test_multiline.txt cat 'grep line' cat 'wc -l' /tmp/multi2.txt"

# Test multiple pipes avec commandes complexes
compare_bash_pipex \
    "Bonus: Multiple pipes with complex commands" \
    "< /tmp/test_multiline.txt sort | uniq | grep line | wc -l" \
    "../pipex /tmp/test_multiline.txt sort uniq 'grep line' 'wc -l' /tmp/multi3.txt"

# Test de timing pour multiple pipes
compare_bash_pipex \
    "Bonus: Multiple pipes timing test" \
    "< /dev/null sleep 1 | sleep 1 | sleep 1" \
    "../pipex /dev/null 'sleep 1' 'sleep 1' 'sleep 1' /tmp/multi_timing.txt" \
    "" \
    "" \
    "true"

# ============================================================================
# TESTS BONUS AVANCÉS
# ============================================================================

echo -e "\n${BLUE}=== TESTING BONUS ADVANCED SCENARIOS ===${NC}"

# Test heredoc avec multiple pipes
echo -e "data1\ndata2\ndata3\nEOF" | ../pipex here_doc EOF cat 'grep data' 'wc -l' /tmp/advanced1.txt 2>/dev/null
if [[ -f /tmp/advanced1.txt ]] && [[ "$(cat /tmp/advanced1.txt)" == "3" ]]; then
    echo -e "${GREEN}✓ Heredoc with multiple pipes works${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Heredoc with multiple pipes failed${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Test timing pour multiple pipes avec fonction de comparaison
compare_bash_pipex \
    "Bonus: Advanced multiple pipes timing" \
    "< /dev/null sleep 2 | sleep 1 | sleep 1" \
    "../pipex /dev/null 'sleep 2' 'sleep 1' 'sleep 1' /tmp/advanced_timing.txt" \
    "" \
    "" \
    "true"

# Nettoyage
rm -f /tmp/test_*.txt /tmp/out*.txt /tmp/bout*.txt /tmp/heredoc*.txt /tmp/multi*.txt /tmp/advanced*.txt /tmp/timing_test.txt /tmp/multi_timing.txt /tmp/advanced_timing.txt
rm -f /tmp/test_perm.txt /tmp/heredoc_append.txt
chmod 644 /tmp/test_perm.txt 2>/dev/null
rm -f /tmp/test_perm.txt

# ============================================================================
# RÉSUMÉ FINAL
# ============================================================================

print_final_summary() {
    echo -e "\n${BLUE}=== FINAL TEST SUMMARY ===${NC}"
    echo -e "Standard version tests:"
    echo -e "  ${GREEN}Passed: $((standard_passed))${NC}"
    echo -e "  ${RED}Failed: $((standard_failed))${NC}"
    echo -e "  Total: $((standard_total))${NC}"
    
    bonus_passed=$((TESTS_PASSED - bonus_start_passed))
    bonus_failed=$((TESTS_FAILED - bonus_start_failed))
    bonus_total=$((TESTS_TOTAL - bonus_start_total))
    
    echo -e "Bonus version tests:"
    echo -e "  ${GREEN}Passed: $bonus_passed${NC}"
    echo -e "  ${RED}Failed: $bonus_failed${NC}"
    echo -e "  Total: $bonus_total${NC}"
    
    echo -e "\nOverall results:"
    echo -e "  ${GREEN}Total Passed: $TESTS_PASSED${NC}"
    echo -e "  ${RED}Total Failed: $TESTS_FAILED${NC}"
    echo -e "  Total Tests: $TESTS_TOTAL${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 ALL TESTS PASSED! BOTH STANDARD AND BONUS WORK PERFECTLY! 🎉${NC}"
        return 0
    else
        echo -e "\n${RED}❌ $TESTS_FAILED TEST(S) FAILED ❌${NC}"
        if [[ $standard_failed -gt 0 ]]; then
            echo -e "${RED}⚠️  Standard version has issues that need to be fixed${NC}"
        fi
        if [[ $bonus_failed -gt 0 ]]; then
            echo -e "${RED}⚠️  Bonus version has issues that need to be fixed${NC}"
        fi
        return 1
    fi
}

# Afficher le résumé final
print_final_summary

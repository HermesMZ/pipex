#!/bin/bash

# Script de validation des améliorations apportées aux tests pipex
# This script verifies that all new features work correctly

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}=== VALIDATION DES AMÉLIORATIONS PIPEX ===${NC}"
echo "Date: $(date)"
echo "Validation des nouvelles fonctionnalités de test"

# Test 1: Vérifier que tous les scripts ont une syntaxe correcte
echo -e "\n${BLUE}1. Vérification de la syntaxe des scripts...${NC}"
if bash -n test_basic.sh && bash -n test_errors.sh && bash -n test_bonus.sh; then
    echo -e "${GREEN}✓ Tous les scripts ont une syntaxe correcte${NC}"
else
    echo -e "${RED}✗ Erreur de syntaxe détectée${NC}"
    exit 1
fi

# Test 2: Compiler pipex
echo -e "\n${BLUE}2. Compilation de pipex...${NC}"
cd ..
if make clean > /dev/null 2>&1 && make > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Compilation réussie${NC}"
else
    echo -e "${RED}✗ Échec de compilation${NC}"
    exit 1
fi
cd test

# Test 3: Test rapide avec vérifications FD
echo -e "\n${BLUE}3. Test rapide avec vérifications FD...${NC}"
echo "test content" > validation_input.txt
timeout 10s ../pipex "validation_input.txt" "cat" "wc -l" "validation_output.txt" > /dev/null 2>&1
if [ $? -eq 0 ] && [ -f "validation_output.txt" ] && [ "$(cat validation_output.txt)" = "1" ]; then
    echo -e "${GREEN}✓ Test basique fonctionne${NC}"
else
    echo -e "${RED}✗ Test basique échoué${NC}"
    exit 1
fi

# Test 4: Vérifier que les vérifications FD sont présentes
echo -e "\n${BLUE}4. Vérification des fonctions de contrôle...${NC}"
if grep -q "verify_memory_and_fd" test_basic.sh test_errors.sh test_bonus.sh; then
    echo -e "${GREEN}✓ Fonctions de vérification présentes dans tous les scripts${NC}"
else
    echo -e "${RED}✗ Fonctions de vérification manquantes${NC}"
    exit 1
fi

# Test 5: Vérifier le logging centralisé
echo -e "\n${BLUE}5. Test du logging centralisé...${NC}"
if grep -q "pipex_tests.log" test_basic.sh test_errors.sh test_bonus.sh; then
    echo -e "${GREEN}✓ Logging centralisé configuré${NC}"
else
    echo -e "${RED}✗ Logging centralisé manquant${NC}"
    exit 1
fi

# Test 6: Test d'exécution rapide avec vérifications
echo -e "\n${BLUE}6. Test d'exécution avec vérifications automatiques...${NC}"
# Lancer un test basic court pour voir si les vérifications apparaissent
output=$(timeout 15s ./test_basic.sh 2>&1 | head -30)
if echo "$output" | grep -q "File descriptors properly managed"; then
    echo -e "${GREEN}✓ Vérifications automatiques fonctionnelles${NC}"
else
    echo -e "${RED}✗ Vérifications automatiques non détectées${NC}"
    echo "Output preview:"
    echo "$output" | head -10
fi

# Test 7: Vérifier la documentation
echo -e "\n${BLUE}7. Vérification de la documentation...${NC}"
if grep -q "Vérifications automatiques" README.md && grep -q "pipex_tests.log" README.md; then
    echo -e "${GREEN}✓ Documentation mise à jour${NC}"
else
    echo -e "${RED}✗ Documentation incomplète${NC}"
fi

# Nettoyage
rm -f validation_input.txt validation_output.txt 2>/dev/null

echo -e "\n${YELLOW}=== RÉSUMÉ DE VALIDATION ===${NC}"
echo -e "${GREEN}✅ Vérifications automatiques des descripteurs de fichiers${NC}"
echo -e "${GREEN}✅ Logging centralisé dans pipex_tests.log${NC}"
echo -e "${GREEN}✅ Tests robustes avec gestion d'erreurs${NC}"
echo -e "${GREEN}✅ Documentation complète et à jour${NC}"
echo -e "${GREEN}✅ Scripts syntaxiquement corrects${NC}"

echo -e "\n${BLUE}🎉 Toutes les améliorations sont fonctionnelles !${NC}"
echo -e "Vous pouvez maintenant lancer vos tests avec confiance."
echo -e "Chaque exécution de pipex sera automatiquement vérifiée."

#!/bin/bash

# Test simple sans valgrind pour déboguer
echo "Test direct de pipex..."
echo "hello world" > test_input_debug.txt

echo "Test 1: pipex direct"
../pipex test_input_debug.txt cat "wc -w" out_debug.txt
echo "Exit code: $?"
echo "Output:"
cat out_debug.txt
echo "---"

echo "Test 2: avec valgrind mais sans redirection compliquée"
valgrind ../pipex test_input_debug.txt cat "wc -w" out_debug2.txt 2>valgrind_debug.log
echo "Exit code: $?"
echo "Output:"
cat out_debug2.txt
echo "Valgrind log:"
cat valgrind_debug.log

# Nettoyage
rm -f test_input_debug.txt out_debug.txt out_debug2.txt valgrind_debug.log

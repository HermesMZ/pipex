#!/bin/bash

echo "Compilation de pipex..."
make clean && make

echo "Lancement de valgrind avec suppression des erreurs VS Code FDs..."

# Vérifier les arguments
if [ $# -lt 4 ]; then
    echo "Usage: $0 infile cmd1 cmd2 outfile"
    echo "Exemple: $0 Makefile \"cat\" \"wc -l\" output.txt"
    exit 1
fi

valgrind --suppressions=.valgrind_suppress \
         --leak-check=full \
         --show-leak-kinds=all \
         --track-origins=yes \
         --trace-children=yes \
         --track-fds=yes \
         ./pipex "$@" 2>&1 | grep -v "File descriptor [4-9][0-9] (.*) leaked" | grep -v "Open file descriptor [4-9][0-9]:"

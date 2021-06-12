##! /bin/bash
# CUSTOM

. /mingw64/share/bash-completion/completions/*

complete -F _make mingw32-make # Supply `mingw32-make` with the same completion behavior as regular `make`

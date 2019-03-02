#!/usr/bin/env bash
set -e

printf "$(cat $1)\nPrintf.printf \"%%ld\" (main ())\n" > "$1.2.ml"
ocamlc "$1.2.ml" -o "$1.out"
rm "$1.2.ml"
chmod +x "$1.out"

#!/usr/bin/env bash
set -e

printf "$(cat $1)\nPrintf.printf \"%%ld\" (reuse_45main ())\n" > "$1.2.ml"
ocamlc "$1.2.ml" -o "$2"
rm "$1.2.ml"
chmod +x "$2"
#!/usr/bin/env bash
set -e

printf "$(cat $1)\nPrintf.printf \"%%d\" (Int32.to_int (main ()))\n" > "$1.2.ml"
ocamlc -g "$1.2.ml" -o "$1.out"
rm "$1.2.ml"
chmod +x "$1.out"

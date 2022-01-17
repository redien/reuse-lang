#!/usr/bin/env bash
set -e

echo -e "$(cat $1/$2)\nPrintf.printf \"%ld\" (reuse_main ())\n" > "$1/$2.2.ml"
ocamlc "$1/$2.2.ml" -o "$1/$3"
rm "$1/$2.2.ml"
chmod +x "$1/$3"

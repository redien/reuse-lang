#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

if [ -z "$REUSE_COMPILER" ]; then
    REUSE_COMPILER="$project_root/generated/extended/compiler-ocaml"
fi

cat "$1" | "$REUSE_COMPILER" > "$2/executable.ml"
printf "\nPrintf.printf \"%%d\" (Int32.to_int (main ()))\n" >> "$2/executable.ml"
ocamlc -g "$2/executable.ml" -o "$2/executable"

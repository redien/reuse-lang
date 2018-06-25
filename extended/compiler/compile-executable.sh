#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

cat "$1" | "$project_root/generated/extended/compiler-ocaml" > "$2/executable.ml"

if [ "$3" == "--stdin" ]
then
    printf "\n$(cat $script_path/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main _stdin_list))\n" >> "$2/executable.ml"
else
    printf "\nPrintf.printf \"%%d\" (Int32.to_int (main ()))\n" >> "$2/executable.ml"
fi

ocamlc -g "$2/executable.ml" -o "$2/executable"

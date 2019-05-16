#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
root_path=$script_path/../..

printf "$(cat $1)\n$(cat $root_path/extended/ocaml-compiler/pervasives.ml)$(cat $root_path/extended/ocaml-compiler/stdin_wrapper.ml)\nlet stdin_list = read_stdin ();;\nPrintf.printf \"%%s\" (list_to_string (reuse_45main stdin_list))\n" > "$1.2.ml"
ocamlc "$1.2.ml" -o "$2"
rm "$1.2.ml"
chmod +x "$2"

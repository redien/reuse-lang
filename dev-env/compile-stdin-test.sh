#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
root_path=$script_path/..

printf "$(cat $1)\n$(cat $root_path/extended/ocaml-compiler/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main _stdin_list))\n" > "$1.2.ml"
ocamlc "$1.2.ml" -o "$1.out"
rm "$1.2.ml"
chmod +x "$1.out"

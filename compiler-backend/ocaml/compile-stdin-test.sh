#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

printf "\
$(cat $1/$2)\n\
open StdinWrapper;;\n\
Printf.printf \"%%s\" (reuse_string_to_ml (reuse_main (read_stdin ())))\n" > "$1/$2.2.ml"

cp $script_path/StdinWrapper.ml $1

ocamlc.opt -I "$1" \
           "$1/StdinWrapper.ml" \
           "$1/$2.2.ml" \
           -o "$1/$3"

rm "$1/$2.2.ml"
chmod +x "$1/$3"

#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

printf "\
open Reuse;;\n\
$(cat $1)\n\
open Pervasives;;\n\
open StdinWrapper;;\n\
let stdin_list = read_stdin ();;\n\
Printf.printf \"%%s\" (reuse_string_to_ml (reuse_45main (ml_string_to_indexed_iterator stdin_list)))\n" > "$1.2.ml"

ocamlc.opt -I "$project_root/standard-library" \
           -I "$project_root/extended/ocaml-compiler" \
           "$project_root/standard-library/Reuse.ml" \
           "$project_root/extended/ocaml-compiler/Pervasives.ml" \
           "$project_root/extended/ocaml-compiler/StdinWrapper.ml" \
           "$1.2.ml" \
           -o "$2"

rm "$1.2.ml"
chmod +x "$2"

#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

printf "\
open Reuse;;\n\
$(cat $1/$2)\n\
open Pervasives;;\n\
open StdinWrapper;;\n\
let stdin_list = read_stdin ();;\n\
Printf.printf \"%%s\" (reuse_string_to_ml (reuse_45main (ml_string_to_indexed_iterator stdin_list)))\n" > "$1/$2.2.ml"

cp $project_root/bootstrap/Reuse.ml $1
cp $project_root/bootstrap/Pervasives.ml $1
cp $project_root/bootstrap/StdinWrapper.ml $1

ocamlc.opt -I "$1" \
           "$1/Reuse.ml" \
           "$1/Pervasives.ml" \
           "$1/StdinWrapper.ml" \
           "$1/$2.2.ml" \
           -o "$1/$3"

rm "$1/$2.2.ml"
chmod +x "$1/$3"

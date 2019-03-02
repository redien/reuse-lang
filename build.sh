#!/usr/bin/env bash
set -e

project_root=$(dirname $0)

[ -d $project_root/bin ] || mkdir $project_root/bin

ocamlopt -O3 unix.cmxa $project_root/extended/ocaml-compiler/ocaml.ml -o $project_root/bin/reuse-ocaml
ocamlopt -O3 unix.cmxa $project_root/string-gen/StringGen.ml -o $project_root/bin/string-gen

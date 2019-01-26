#!/usr/bin/env bash
set -e

project_root=$(dirname $0)

[ -d $project_root/bin ] || mkdir $project_root/bin

ocamlc -g $project_root/extended/ocaml-compiler/ocaml.ml -o $project_root/bin/reuse-ocaml
ocamlc -g $project_root/string-gen/StringGen.ml -o $project_root/bin/string-gen

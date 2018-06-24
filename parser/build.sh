#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/sexp-parser/build.sh

>$project_root/generated/parser.reuse echo "
$(cat $project_root/generated/sexp-parser.reuse)
$(cat $project_root/parser/strings.reuse)
$(cat $project_root/parser/parser.reuse)
"

[ -d $project_root/generated/parser ] || mkdir $project_root/generated/parser

$project_root/extended/compiler/compile-executable.sh $project_root/generated/parser.reuse "(stringify (definitions-to-sexps (sexps-to-definitions (parse stdin))))" $project_root/generated/parser --stdin
ocamlc -g $project_root/generated/parser/ocaml/source.ml -o $project_root/generated/parser/ocaml/executable

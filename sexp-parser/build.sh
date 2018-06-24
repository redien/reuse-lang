#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

>$project_root/generated/sexp-parser.reuse echo "
$(cat $project_root/generated/standard-library.reuse)
$(cat $project_root/sexp-parser/parser.reuse)
"

[ -d $project_root/generated/sexp-parser ] || mkdir $project_root/generated/sexp-parser

$project_root/extended/compiler/compile-executable.sh $project_root/generated/sexp-parser.reuse "(match (parse stdin) (Result expressions) (stringify expressions) (Error _) (list 45))" $project_root/generated/sexp-parser --stdin
ocamlc -g $project_root/generated/sexp-parser/ocaml/source.ml -o $project_root/generated/sexp-parser/ocaml/executable

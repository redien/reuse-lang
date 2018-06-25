#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

>$project_root/generated/sexp-parser.reuse echo "
$(cat $project_root/generated/standard-library.reuse)
$(cat $project_root/sexp-parser/parser.reuse)
(export main (stdin)
        (match (parse stdin) (Result expressions) (stringify expressions) (Error _) (list 45)))
"

[ -d $project_root/generated/sexp-parser ] || mkdir $project_root/generated/sexp-parser

$project_root/extended/ocaml-compiler/compile-executable.sh $project_root/generated/sexp-parser.reuse $project_root/generated/sexp-parser --stdin

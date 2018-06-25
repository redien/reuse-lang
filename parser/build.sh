#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

>$project_root/generated/parser.reuse echo "
$(cat $project_root/generated/standard-library.reuse)
$(cat $project_root/sexp-parser/parser.reuse)
$(cat $project_root/parser/strings.reuse)
$(cat $project_root/parser/parser.reuse)
(export main (stdin)
        (stringify (definitions-to-sexps (sexps-to-definitions (parse stdin)))))
"

[ -d $project_root/generated/parser ] || mkdir $project_root/generated/parser

$project_root/extended/compiler/compile-executable.sh $project_root/generated/parser.reuse $project_root/generated/parser --stdin
ocamlc -g $project_root/generated/parser/executable.ml -o $project_root/generated/parser/executable

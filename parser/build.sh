#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

[ -d $project_root/generated/parser ] || mkdir $project_root/generated/parser

$project_root/reusec --language ocaml\
                     --output $project_root/generated/parser/Test.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $project_root/parser/main.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $project_root/generated/parser/Test.ml $project_root/generated/parser/source.out

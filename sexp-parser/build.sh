#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

[ -d $project_root/generated/sexp-parser ] || mkdir $project_root/generated/sexp-parser

$project_root/reusec --language ocaml\
                     --output $project_root/generated/sexp-parser/Test.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/sexp-parser/main.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $project_root/generated/sexp-parser/Test.ml $project_root/generated/sexp-parser/source.out

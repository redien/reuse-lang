#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

[ -d $project_root/generated/type-unification ] || mkdir $project_root/generated/type-unification

$project_root/reusec --language ocaml\
                     --output $project_root/generated/type-unification/source.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $project_root/type-system/type.reuse\
                     $project_root/type-system/rename-type.reuse\
                     $project_root/type-system/stringify-type.strings\
                     $project_root/type-system/stringify-type.reuse\
                     $project_root/type-system/type-from-ast.reuse\
                     $project_root/type-unification/main.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $project_root/generated/type-unification/source.ml $project_root/generated/type-unification/source.out

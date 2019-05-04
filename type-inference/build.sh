#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

[ -d $project_root/generated/type-inference ] || mkdir $project_root/generated/type-inference

$project_root/reusec --language haskell\
                     --output $project_root/generated/type-inference/Test.hs\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $project_root/type-system/type.reuse\
                     $project_root/type-system/rename-type.reuse\
                     $project_root/type-system/stringify-type.strings\
                     $project_root/type-system/stringify-type.reuse\
                     $project_root/type-system/type-from-ast.reuse\
                     $project_root/type-inference/context.reuse\
                     $project_root/type-inference/type-inference.strings\
                     $project_root/type-inference/type-inference.reuse\
                     $project_root/type-inference/main.reuse

$project_root/extended/haskell-compiler/compile-stdin-test.sh $project_root/generated/type-inference/Test.hs $project_root/generated/type-inference/source.out

#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh type-inference)

$project_root/reusec --language haskell\
                     --output $build_dir/Test.hs\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/ast.reuse\
                     $project_root/extended/strings.reuse\
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

$project_root/extended/haskell-compiler/compile-stdin-test.sh $build_dir Test.hs source.out

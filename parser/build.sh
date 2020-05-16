#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh parser)

$project_root/reusec --language ocaml\
                     --output $build_dir/Test.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/parser-context.reuse\
                     $project_root/parser/parser-context-monad.reuse\
                     $project_root/parser/parser.reuse\
                     $project_root/parser/main.strings\
                     $project_root/parser/main.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $build_dir Test.ml source.out

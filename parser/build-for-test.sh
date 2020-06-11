#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh parser)

$script_path/build.sh

$project_root/reusec --language ocaml\
                     --output $build_dir/Test.ml\
                     --module $project_root/sexp-parser/sexp-parser.reuse\
                     --module $build_dir/parser.reuse\
                     $project_root/parser/main.strings\
                     $project_root/parser/main.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $build_dir Test.ml source.out

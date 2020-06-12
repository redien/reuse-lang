#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh sexp-parser)

$project_root/reusec --language ocaml\
                     --output $build_dir/Test.ml\
                     $project_root/sexp-parser/sexp-parser.reuse\
                     $project_root/sexp-parser/main.reuse

$project_root/compiler-backend/ocaml/compile-stdin-test.sh $build_dir Test.ml source.out

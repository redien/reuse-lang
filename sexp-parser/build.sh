#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

build_dir=$($project_root/dev-env/builddir.sh sexp-parser)

$project_root/reusec --language ocaml\
                     --output $build_dir/Test.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/sexp-parser/main.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $build_dir Test.ml source.out

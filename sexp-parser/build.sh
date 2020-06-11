#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh sexp-parser)

$project_root/reusec --language ocaml\
                     --output $build_dir/Test.ml\
                     $project_root/sexp-parser/sexp-parser.reuse\
                     $project_root/sexp-parser/main.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $build_dir Test.ml source.out

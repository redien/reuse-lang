#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/tempdir.sh standard-library)

echo "$1 (def reuse-main (_) $2)" > $build_dir/test.reuse

$project_root/reusec --language ocaml\
                     --output $build_dir/test.ml\
                     $build_dir/test.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $build_dir test.ml test.out

echo "" | $build_dir/test.out
result=$?
exit $result

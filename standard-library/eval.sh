#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
stdlib_path=$($project_root/dev-env/builddir.sh standard-library)/standard-library.reuse
build_dir=$($project_root/dev-env/tempdir.sh standard-library-eval)

echo "$1 (def reuse-main (_) $2)" > $build_dir/test.reuse

$project_root/reusec --language ocaml\
                     --stdlib false\
                     --output $build_dir/test.ml\
                     $stdlib_path\
                     $project_root/bootstrap/data/pervasives.ml\
                     $build_dir/test.reuse

$project_root/compiler-backend/ocaml/compile-stdin-test.sh $build_dir test.ml test.out

echo "" | $build_dir/test.out
result=$?
exit $result

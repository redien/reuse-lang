#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/tempdir.sh standard-library)

echo "$1 (def reuse-main (_) $2)" > $build_dir/test.reuse

$project_root/reusec --language ocaml\
                     --stdlib false\
                     --output $build_dir/test.ml\
                     $script_path/combinators.reuse\
                     $script_path/boolean.reuse\
                     $script_path/pair.reuse\
                     $script_path/maybe.reuse\
                     $script_path/iterable.reuse\
                     $script_path/indexed-iterator.reuse\
                     $script_path/list.reuse\
                     $script_path/string.reuse\
                     $script_path/result.reuse\
                     $script_path/state.reuse\
                     $script_path/dictionary.reuse\
                     $build_dir/test.reuse

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $build_dir test.ml test.out

echo "" | $build_dir/test.out
result=$?
exit $result

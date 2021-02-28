#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh standard-library)

$project_root/bin/reuse-ocaml --language module\
                              --output $build_dir/standard-library.reuse\
                              --stdlib false\
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
                              $script_path/array.reuse\
                              $script_path/dictionary.reuse

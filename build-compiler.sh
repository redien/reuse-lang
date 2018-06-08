#!/usr/bin/env bash

script_path=$(dirname $0)
output_dir=$script_path/extended/compiler
temporary_dir=$(mktemp -d -p $script_path/generated)

set -e

$script_path/build.sh
$script_path/extended/bootstrap/compile-library.sh "$script_path/generated/extended/compiler/compiler.reuse" "$temporary_dir"
printf "\n$(cat $script_path/extended/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (to_ocaml (fn_sexps_45to_45definitions (parse _stdin_list))))\n" >> $temporary_dir/ocaml/source.ml
ocamlc -g $temporary_dir/ocaml/source.ml -o $temporary_dir/compiler.out
cp $temporary_dir/ocaml/source.ml $output_dir/compiler.ml
cp $temporary_dir/compiler.out $output_dir/compiler.out


#!/usr/bin/env bash

script_path=$(dirname $0)
output_dir=$script_path/generated/extended/compiler
temporary_dir=$(mktemp -d -p $script_path/generated)

mkdir -p $script_path/bin

set -e

ocamlc -g $script_path/extended/compiler/compiler.ml -o $script_path/bin/reuse-ocaml

$script_path/build.sh
$script_path/extended/compiler/compile-library.sh "$script_path/generated/extended/compiler/compiler.reuse" "$temporary_dir"
printf "\n$(cat $script_path/extended/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (to_ocaml (sexps_45to_45definitions (parse _stdin_list))))\n" >> $temporary_dir/ocaml/source.ml
ocamlc -g $temporary_dir/ocaml/source.ml -o $temporary_dir/compiler.out
cp $temporary_dir/ocaml/source.ml $output_dir/compiler.ml

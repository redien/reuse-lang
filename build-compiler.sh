#!/usr/bin/env bash

script_path=$(dirname $0)
output_dir=$script_path/generated/extended/compiler
mkdir -p $script_path/generated
temporary_dir=$(mktemp -d -p $script_path/generated)

mkdir -p $script_path/bin

set -e

ocamlc -g $script_path/extended/compiler/compiler.ml -o $script_path/bin/reuse-ocaml

$script_path/build.sh
mkdir -p $temporary_dir/ocaml
cat $script_path/generated/extended/compiler/compiler.reuse | $script_path/bin/reuse-ocaml > $temporary_dir/ocaml/source.ml

cat << END_OF_SOURCE >> $temporary_dir/ocaml/source.ml

$(cat $script_path/extended/stdin_wrapper.ml)

let output = to_ocaml (sexps_45to_45definitions (parse _stdin_list)) _stdin_list in
    match output with
        CResult (source) -> Printf.printf "%s" (_list_to_string source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (_list_to_string error) ; exit 1;;

END_OF_SOURCE

ocamlc -g $temporary_dir/ocaml/source.ml -o $temporary_dir/compiler.out

cp $temporary_dir/ocaml/source.ml $output_dir/compiler.ml
cp $temporary_dir/compiler.out $output_dir/reuse-ocaml

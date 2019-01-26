#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..

[ -d $project_root/generated/string-gen ] || mkdir $project_root/generated/string-gen

$project_root/reusec --language ocaml\
                     --output $project_root/generated/string-gen/StringGen.ml\
                     $script_path/string-gen.reuse

cat << END_OF_SOURCE >> $project_root/generated/string-gen/StringGen.ml

$(cat $project_root/extended/ocaml-compiler/stdin_wrapper.ml)

let output = string_gen _stdin_list in
    match output with
        CResult (result) -> Printf.printf "%s" (_list_to_string result) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (_list_to_string error) ; exit 1;;

END_OF_SOURCE

ocamlc -g $project_root/generated/string-gen/StringGen.ml -o $project_root/generated/string-gen/string-gen

cp $project_root/generated/string-gen/StringGen.ml $script_path/StringGen.ml

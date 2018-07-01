#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

$project_root/standard-library/build.sh

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

>$project_root/generated/extended/compiler-ocaml.reuse echo "
$(cat $project_root/generated/standard-library.reuse)
$(cat $project_root/sexp-parser/parser.reuse)
$(cat $project_root/parser/strings.reuse)
$(cat $project_root/parser/parser.reuse)
$(cat $script_path/../common-strings.reuse)
$(cat $script_path/../common.reuse)
$(cat $script_path/ocaml-strings.reuse)
$(cat $script_path/ocaml.reuse)
"

cat $project_root/generated/extended/compiler-ocaml.reuse | $project_root/bin/reuse-ocaml > $project_root/generated/extended/CompilerOCaml.ml

cat << END_OF_SOURCE >> $project_root/generated/extended/CompilerOCaml.ml

$(cat $script_path/stdin_wrapper.ml)

let output = to_ocaml (sexps_45to_45definitions (parse _stdin_list)) _stdin_list in
    match output with
        CResult (source) -> Printf.printf "%s" (_list_to_string source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (_list_to_string error) ; exit 1;;

END_OF_SOURCE

ocamlc -g $project_root/generated/extended/CompilerOCaml.ml -o $project_root/generated/extended/compiler-ocaml
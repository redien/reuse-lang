#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
    DIAGNOSTICS="true"
fi

$project_root/standard-library/build.sh $extra_flags

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $project_root/generated/extended/Interpreter.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/scope.reuse\
                     $script_path/interpreter.strings\
                     $script_path/interpreter.reuse

cat << END_OF_SOURCE >> $project_root/generated/extended/Interpreter.ml

$(cat $script_path/../ocaml-compiler/pervasives.ml)
$(cat $script_path/../ocaml-compiler/stdin_wrapper.ml)
let parse_sexp_output = (parse stdin_list);;
let parse_output = stringify_45parse_45errors (sexps_45to_45definitions parse_sexp_output);;
let eval_output = (eval parse_output stdin_list);;
match eval_output with
      CResult (source) -> Printf.printf "%s" (list_to_string source) ; exit 0
    | CError (error) -> Printf.eprintf "%s" (list_to_string error) ; exit 1;;

END_OF_SOURCE

ocamlopt -O3 unix.cmxa $project_root/generated/extended/Interpreter.ml -o $project_root/generated/extended/interpreter

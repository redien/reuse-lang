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
                     $script_path/../../cli/argument-parser.strings\
                     $script_path/../../cli/argument-parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/interpreter.strings\
                     $script_path/value.reuse\
                     $script_path/scope.reuse\
                     $script_path/interpreter.reuse

ocamlopt.opt -O3 \
             unix.cmxa \
             -I "$project_root/extended/ocaml-compiler" \
             -I "$project_root/generated/extended" \
             -I "$project_root/generated" \
             "$project_root/generated/Reuse.ml" \
             "$project_root/extended/ocaml-compiler/Pervasives.ml" \
             "$project_root/extended/ocaml-compiler/StdinWrapper.ml" \
             "$project_root/generated/extended/Interpreter.ml" \
             "$project_root/extended/interpreter/Main.ml" \
             -o "$project_root/generated/extended/interpreter"

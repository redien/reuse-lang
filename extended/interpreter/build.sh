#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_path=$project_root/generated/extended/interpreter

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
    DIAGNOSTICS="true"
fi

[ -d $project_root/generated ] || mkdir $project_root/generated
[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended
[ -d $project_root/generated/extended/interpreter ] || mkdir $project_root/generated/extended/interpreter

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $build_path/Interpreter.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser-context.reuse\
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

cp $project_root/standard-library/Reuse.ml $build_path/Reuse.ml
cp $project_root/extended/ocaml-compiler/Pervasives.ml $build_path/Pervasives.ml
cp $project_root/extended/ocaml-compiler/StdinWrapper.ml $build_path/StdinWrapper.ml
cp $project_root/extended/interpreter/Main.ml $build_path/Main.ml

ocamlopt.opt -O3 \
             unix.cmxa \
             -I "$build_path" \
             "$build_path/Reuse.ml" \
             "$build_path/Pervasives.ml" \
             "$build_path/StdinWrapper.ml" \
             "$build_path/Interpreter.ml" \
             "$build_path/Main.ml" \
             -o "$build_path/interpreter"

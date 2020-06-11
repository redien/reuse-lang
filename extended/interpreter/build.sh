#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh interpreter)

$project_root/parser/build.sh

$project_root/reusec --language ocaml\
                     --output $build_dir/Interpreter.ml\
                     --module $project_root/string-gen/string-gen.reuse\
                     --module $project_root/sexp-parser/sexp-parser.reuse\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     $script_path/../../cli/argument-parser.strings\
                     $script_path/../../cli/argument-parser.reuse\
                     $script_path/../local-transforms.strings\
                     $script_path/../local-transforms.reuse\
                     $script_path/../source-file.strings\
                     $script_path/../source-file.reuse\
                     $script_path/../common.strings\
                     $script_path/../strings.reuse\
                     $script_path/../common.reuse\
                     $script_path/interpreter.strings\
                     $script_path/value.reuse\
                     $script_path/scope.reuse\
                     $script_path/interpreter.reuse\
                     $script_path/main.reuse

cp $project_root/extended/ocaml-compiler/StdinWrapper.ml $build_dir/StdinWrapper.ml
cp $project_root/extended/interpreter/Main.ml $build_dir/Main.ml

ocamlopt.opt -O3 \
             unix.cmxa \
             -I "$build_dir" \
             "$build_dir/Interpreter.ml" \
             "$build_dir/StdinWrapper.ml" \
             "$build_dir/Main.ml" \
             -o "$build_dir/interpreter"

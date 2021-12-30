#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh interpreter)

$project_root/parser/build.sh
$project_root/argument-parser/build.sh
$project_root/compiler-frontend/build.sh

$project_root/reusec --language ocaml\
                     --output $build_dir/Interpreter.ml\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     --module $($project_root/dev-env/builddir.sh argument-parser)/argument-parser.reuse\
                     --module $($project_root/dev-env/builddir.sh compiler-frontend)/compiler-frontend.reuse\
                     $project_root/compiler-backend/common.strings\
                     $script_path/interpreter.strings\
                     $script_path/value.reuse\
                     $script_path/scope.reuse\
                     $script_path/interpreter.reuse\
                     $script_path/main.reuse

cp $project_root/compiler-backend/ocaml/StdinWrapper.ml $build_dir/StdinWrapper.ml
cp $script_path/Main.ml $build_dir/Main.ml

ocamlopt.opt -O3 \
             unix.cmxa \
             -I "$build_dir" \
             "$build_dir/Interpreter.ml" \
             "$build_dir/StdinWrapper.ml" \
             "$build_dir/Main.ml" \
             -o "$build_dir/interpreter"

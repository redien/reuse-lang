#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh minimal-compiler)

$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseMinimal.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/parser-context.reuse\
                     $project_root/parser/parser-context-monad.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../strings.reuse\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/../source-file.reuse\
                     $script_path/minimal.reuse

cp $project_root/extended/ocaml-compiler/StdinWrapper.ml $build_dir/StdinWrapper.ml
cp $project_root/extended/minimal-compiler/Compiler.ml $build_dir/Compiler.ml

ocamlopt -O3 \
         -I "$build_dir" \
         "$build_dir/ReuseMinimal.ml" \
         "$build_dir/StdinWrapper.ml" \
         "$build_dir/Compiler.ml" \
         -o "$build_dir/compiler-minimal"

#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_path=$project_root/generated/extended/minimal-compiler

[ -d $project_root/generated ] || mkdir $project_root/generated
[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended
[ -d $project_root/generated/extended/minimal-compiler ] || mkdir $project_root/generated/extended/minimal-compiler

$project_root/reusec --language ocaml\
                     --output $build_path/ReuseMinimal.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser-context.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/../source-file.reuse\
                     $script_path/minimal.reuse

cp $project_root/standard-library/Reuse.ml $build_path/Reuse.ml
cp $project_root/extended/ocaml-compiler/Pervasives.ml $build_path/Pervasives.ml
cp $project_root/extended/ocaml-compiler/StdinWrapper.ml $build_path/StdinWrapper.ml
cp $project_root/extended/minimal-compiler/Compiler.ml $build_path/Compiler.ml

ocamlopt -O3 \
         -I "$build_path" \
         "$build_path/Reuse.ml" \
         "$build_path/Pervasives.ml" \
         "$build_path/StdinWrapper.ml" \
         "$build_path/ReuseMinimal.ml" \
         "$build_path/Compiler.ml" \
         -o "$build_path/compiler-minimal"

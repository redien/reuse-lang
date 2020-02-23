#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_path=$project_root/generated/extended/haskell-compiler

[ -d $project_root/generated ] || mkdir $project_root/generated
[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended
[ -d $project_root/generated/extended/haskell-compiler ] || mkdir $project_root/generated/extended/haskell-compiler

$project_root/reusec --language ocaml\
                     --output $build_path/ReuseCompiler.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser-context.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../../cli/argument-parser.strings\
                     $script_path/../../cli/argument-parser.reuse\
                     $script_path/../../string-gen/string-gen.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/haskell.strings\
                     $script_path/haskell.reuse\
                     $script_path/../compiler.reuse

cp $project_root/standard-library/Reuse.ml $build_path/Reuse.ml
cp $project_root/extended/ocaml-compiler/Pervasives.ml $build_path/Pervasives.ml
cp $project_root/extended/CompilerMain.ml $build_path/CompilerMain.ml

ocamlopt -O3 unix.cmxa \
        -I "$build_path" \
        "$build_path/Reuse.ml" \
        "$build_path/Pervasives.ml" \
        "$build_path/ReuseCompiler.ml" \
        "$build_path/CompilerMain.ml" \
        -o "$build_path/compiler-haskell"

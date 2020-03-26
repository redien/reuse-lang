#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$project_root/generated/extended/ocaml-compiler

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
    DIAGNOSTICS="true"
fi

$project_root/standard-library/build.sh $extra_flags

[ -d $project_root/generated ] || mkdir $project_root/generated
[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended
[ -d $project_root/generated/extended/ocaml-compiler ] || mkdir $project_root/generated/extended/ocaml-compiler

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
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
                     $script_path/../source-file.reuse\
                     $script_path/ocaml.strings\
                     $script_path/ocaml.reuse\
                     $script_path/../compiler.reuse

cp $project_root/bootstrap/Reuse.ml $build_dir/Reuse.ml
cp $project_root/extended/ocaml-compiler/Pervasives.ml $build_dir/Pervasives.ml
cp $project_root/extended/CompilerMain.ml $build_dir/CompilerMain.ml

if [ "$1" != "--no-binary" ]; then
    ocamlopt -O3 unix.cmxa \
            -I "$build_dir" \
            "$build_dir/Reuse.ml" \
            "$build_dir/ReuseCompiler.ml" \
            "$build_dir/Pervasives.ml" \
            "$build_dir/CompilerMain.ml" \
            -o "$build_dir/compiler-ocaml"
fi

#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_path=$project_root/generated/extended/haskell-compiler

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
    DIAGNOSTICS="true"
fi

[ -d $project_root/generated ] || mkdir $project_root/generated
[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended
[ -d $project_root/generated/extended/haskell-compiler ] || mkdir $project_root/generated/extended/haskell-compiler

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $build_path/ReuseHaskell.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/haskell.strings\
                     $script_path/haskell.reuse

if [ "$1" != "--no-binary" ]; then
    if [ "$1" == "--diagnostics" ]; then
        2>&1 echo "[build.sh] ocamlopt"
        echo "Haskell:          " $(echo "time -p ocamlopt -O3 unix.cmxa $project_root/generated/extended/ReuseHaskell.ml -o $project_root/generated/extended/compiler-haskell" | bash 2>&1 | grep "real" | awk '{ print $2; }')s
    else
        cp $project_root/standard-library/Reuse.ml $build_path/Reuse.ml
        cp $project_root/extended/ocaml-compiler/Pervasives.ml $build_path/Pervasives.ml
        cp $project_root/extended/ocaml-compiler/StdinWrapper.ml $build_path/StdinWrapper.ml
        cp $project_root/extended/haskell-compiler/Compiler.ml $build_path/Compiler.ml
        ocamlopt -O3 unix.cmxa \
                -I "$build_path" \
                "$build_path/Reuse.ml" \
                "$build_path/Pervasives.ml" \
                "$build_path/StdinWrapper.ml" \
                "$build_path/ReuseHaskell.ml" \
                "$build_path/Compiler.ml" \
                -o "$build_path/compiler-haskell"
    fi
fi

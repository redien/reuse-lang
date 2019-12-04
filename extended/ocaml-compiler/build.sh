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
                     --output $build_dir/ReuseOcaml.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/ocaml.strings\
                     $script_path/ocaml.reuse

cp $project_root/standard-library/Reuse.ml $build_dir/Reuse.ml
cp $project_root/extended/ocaml-compiler/Pervasives.ml $build_dir/Pervasives.ml
cp $project_root/extended/ocaml-compiler/StdinWrapper.ml $build_dir/StdinWrapper.ml
cp $project_root/extended/ocaml-compiler/Compiler.ml $build_dir/Compiler.ml

compile_binary() {
    ocamlopt -O3 unix.cmxa \
             -I "$build_dir" \
             "$build_dir/Reuse.ml" \
             "$build_dir/ReuseOcaml.ml" \
             "$build_dir/Pervasives.ml" \
             "$build_dir/StdinWrapper.ml" \
             "$build_dir/Compiler.ml" \
             -o "$build_dir/compiler-ocaml"
}

if [ "$1" != "--no-binary" ]; then
    if [ "$1" == "--diagnostics" ]; then
        2>&1 echo "[build.sh] ocamlopt"
        echo "OCaml:          " $(echo "time -p ocamlopt -O3 unix.cmxa $build_dir/CompilerOCaml.ml -o $project_root/generated/extended/compiler-ocaml" | bash 2>&1 | grep "real" | awk '{ print $2; }')s
    else
        compile_binary
    fi
fi

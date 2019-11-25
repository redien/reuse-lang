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

[ -d $project_root/generated ] || mkdir $project_root/generated
[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $project_root/generated/extended/ReuseOcaml.ml\
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

compile_binary() {
    ocamlopt -O3 unix.cmxa \
             -I "$project_root/extended/ocaml-compiler" \
             -I "$project_root/generated/extended" \
             -I "$project_root/generated" \
             "$project_root/generated/Reuse.ml" \
             "$project_root/generated/extended/ReuseOcaml.ml" \
             "$project_root/extended/ocaml-compiler/Pervasives.ml" \
             "$project_root/extended/ocaml-compiler/StdinWrapper.ml" \
             "$project_root/extended/ocaml-compiler/Compiler.ml" \
             -o "$project_root/generated/extended/compiler-ocaml"
}

if [ "$1" != "--no-binary" ]; then
    if [ "$1" == "--diagnostics" ]; then
        2>&1 echo "[build.sh] ocamlopt"
        echo "OCaml:          " $(echo "time -p ocamlopt -O3 unix.cmxa $project_root/generated/extended/CompilerOCaml.ml -o $project_root/generated/extended/compiler-ocaml" | bash 2>&1 | grep "real" | awk '{ print $2; }')s
    else
        compile_binary
    fi
fi

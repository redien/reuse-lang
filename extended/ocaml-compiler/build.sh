#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

$project_root/standard-library/build.sh

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $project_root/generated/extended/CompilerOCaml.ml\
                     $project_root/cli/argument-parser.strings\
                     $project_root/cli/argument-parser.reuse\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/ocaml.strings\
                     $script_path/ocaml.reuse

cat $script_path/pervasives.ml >> $project_root/generated/extended/CompilerOCaml.ml
cat $script_path/cli.ml >> $project_root/generated/extended/CompilerOCaml.ml

compile_binary() {
    ocamlopt -O3 unix.cmxa $project_root/generated/extended/CompilerOCaml.ml -o $project_root/generated/extended/compiler-ocaml
}

if [ "$1" != "--no-binary" ]; then
    if [ "$1" == "--diagnostics" ]; then
        echo "OCaml:          " $(echo "time -p ocamlopt -O3 unix.cmxa $project_root/generated/extended/CompilerOCaml.ml -o $project_root/generated/extended/compiler-ocaml" | bash 2>&1 | grep "real" | awk '{ print $2; }')s
    else
        compile_binary
    fi
fi

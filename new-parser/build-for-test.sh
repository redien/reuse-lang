#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh new-parser)

$script_path/build.sh

$project_root/reusec --language ocaml\
                     --output $build_dir/Test.ml\
                     --module $build_dir/parser.reuse\
                     $project_root/parser/main.strings\
                     $project_root/parser/main.reuse

printf "\
$(cat $build_dir/Test.ml)\n\
open StdinWrapper;;\n\
result_bimap\n\
    (fun output -> Printf.printf \"%%s\" (reuse_string_to_ml output); exit 0)\n\
    (fun error -> Printf.eprintf \"%%s\" (reuse_string_to_ml error); exit 1)\n\
    (reuse_main (read_stdin ()))\n\
\n" > "$build_dir/Test.ml.2.ml"

cp $project_root/compiler-backend/ocaml/StdinWrapper.ml $build_dir

ocamlc.opt -I "$build_dir" \
           "$build_dir/StdinWrapper.ml" \
           "$build_dir/Test.ml.2.ml" \
           -o "$build_dir/source.out"

rm "$build_dir/Test.ml.2.ml"
chmod +x "$build_dir/source.out"

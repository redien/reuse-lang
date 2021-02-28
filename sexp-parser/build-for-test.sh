#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh sexp-parser)

$project_root/reusec --language ocaml\
                     --output $build_dir/Test.ml\
                     $project_root/sexp-parser/sexp-parser.reuse\
                     $project_root/sexp-parser/main.reuse

printf "\
$(cat $build_dir/Test.ml)\n\
open StdinWrapper;;\n\
Printf.printf \"%%s\" (reuse_string_to_ml (reuse_main (read_stdin ())))\n" > "$build_dir/Test.ml.2.ml"

cp $project_root/compiler-backend/ocaml/StdinWrapper.ml $build_dir

ocamlc.opt -I "$build_dir" \
           "$build_dir/StdinWrapper.ml" \
           "$build_dir/Test.ml.2.ml" \
           -o "$build_dir/source.out"

rm "$build_dir/Test.ml.2.ml"
chmod +x "$build_dir/source.out"

#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..

$project_root/reusec --language ocaml --output $BUILD_DIR/Test.ml $@

printf "\
$(cat $BUILD_DIR/Test.ml)\n\
open StdinWrapper;;\n\
Printf.printf \"%%s\" (reuse_string_to_ml (reuse_main (read_stdin ())))\n" > "$BUILD_DIR/Test.ml.2.ml"

cp $project_root/compiler-backend/ocaml/StdinWrapper.ml $BUILD_DIR

ocamlc.opt -I "$BUILD_DIR" \
           "$BUILD_DIR/StdinWrapper.ml" \
           "$BUILD_DIR/Test.ml.2.ml" \
           -o "$BUILD_DIR/test"

rm "$BUILD_DIR/Test.ml.2.ml"
chmod +x "$BUILD_DIR/test"

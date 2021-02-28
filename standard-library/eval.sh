#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
stdlib_path=$($project_root/dev-env/builddir.sh standard-library)/standard-library.reuse
build_dir=$($project_root/dev-env/tempdir.sh standard-library-eval)

echo "$1 (def reuse-main (_) $2)" > $build_dir/test.reuse

$project_root/reusec --language ocaml\
                     --stdlib false\
                     --output $build_dir/test.ml\
                     $stdlib_path\
                     $project_root/bootstrap/data/pervasives.ml\
                     $build_dir/test.reuse

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

echo "" | $build_dir/source.out
result=$?
exit $result

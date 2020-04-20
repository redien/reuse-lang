#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

cat "$1" | "$($project_root/dev-env/builddir.sh minimal-compiler)/compiler-minimal" > "$2/executable.reuse"
$project_root/reusec --language ocaml\
                     --minimal true\
                     --stdlib false\
                     --output "$2/executable.ml"\
                     "$2/executable.reuse"
$script_path/../ocaml-compiler/compile-nostdlib-test.sh "$2/executable.ml" "$2/executable.out"

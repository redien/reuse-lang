#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

cat "$1" | "$project_root/generated/extended/compiler-ocaml" > "$2/executable.ml"
$project_root/dev-env/compile-nostdlib-test.sh "$2/executable.ml"

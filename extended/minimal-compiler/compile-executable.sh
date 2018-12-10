#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

cat "$1" | "$project_root/generated/extended/compiler-minimal" > "$2/executable.reuse"
REUSE_OCAML_MINIMAL=true $project_root/extended/ocaml-compiler/compile-executable.sh "$2/executable.reuse" "$2"

#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
compiler_source=$project_root/generated/extended/compiler/compiler.clj

echo >&2

echo Source: >&2
cat "$1" >&2
echo >&2

mkdir -p $2/ocaml
cat "$1" | "$project_root/extended/interpreter/bootstrap/eval.sh" "$(cat $project_root/generated/extended/compiler/compiler.clj)" "(to-ocaml (sexps-to-definitions (parse stdin)))" --stdin > $2/ocaml/source.ml

echo OCaml: >&2
cat $2/ocaml/source.ml >&2
echo >&2

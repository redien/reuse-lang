#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
compiler_source=$project_root/generated/extended/compiler/compiler.reuse

mkdir -p $2/ocaml
cat "$1" | "$project_root/extended/interpreter/bootstrap/eval.sh" "$(cat $project_root/generated/extended/compiler/compiler.reuse)" "(to_ocaml (sexps-to-definitions (parse stdin)))" --stdin > $2/ocaml/source.ml

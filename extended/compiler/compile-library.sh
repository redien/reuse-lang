#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

mkdir -p $2/ocaml
cat "$1" | "$project_root/generated/extended/compiler-ocaml" > $2/ocaml/source.ml

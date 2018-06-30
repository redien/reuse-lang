#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")

REUSE_COMPILER=$script_path/bin/reuse-ocaml $script_path/extended/ocaml-compiler/compile-executable.sh "$1" "$2" "$3"

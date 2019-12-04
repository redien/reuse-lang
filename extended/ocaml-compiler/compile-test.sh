#!/usr/bin/env bash

script_path=$(dirname "$0")
project_root=$script_path/../..

cat "$1" | "$project_root/generated/extended/ocaml-compiler/compiler-ocaml" > "$2/executable.ml"
result=$?
if [ "$result" != "0" ]; then
    >&2 printf "\n in file $1\n"
    exit $result
fi

set -e
$script_path/compile-nostdlib-test.sh "$2/executable.ml" "$2/executable.out"

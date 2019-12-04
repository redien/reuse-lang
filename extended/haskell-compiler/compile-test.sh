#!/usr/bin/env bash

script_path=$(dirname "$0")
project_root=$script_path/../..

export REUSE_OUTPUT_FILENAME="Test.hs"
cat "$1" | "$project_root/generated/extended/haskell-compiler/compiler-haskell" > "$2/executable.hs"
result=$?
if [ "$result" != "0" ]; then
    >&2 printf "\n in file $1\n"
    exit $result
fi

set -e
$script_path/compile-nostdlib-test.sh "$2/executable.hs" "$2/executable.out"

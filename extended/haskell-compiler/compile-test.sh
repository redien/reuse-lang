#!/usr/bin/env bash

script_path=$(dirname "$0")
project_root=$script_path/../..

"$project_root/generated/extended/haskell-compiler/compiler-haskell" --stdlib false --output "$2/Test.hs" "$1"
result=$?
if [ "$result" != "0" ]; then
    >&2 printf "\n in file $1\n"
    exit $result
fi

set -e
$script_path/compile-nostdlib-test.sh "$2/Test.hs" "$2/executable.out"

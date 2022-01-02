#!/usr/bin/env bash

script_path=$(dirname "$0")
project_root=$script_path/../..

"$($project_root/dev-env/builddir.sh cli)/compiler" --stdlib false --language haskell --output "$2/Test.hs" "$1"
result=$?
if [ "$result" != "0" ]; then
    >&2 printf "\n in file $1\n"
    exit $result
fi

set -e
$script_path/compile-nostdlib-test.sh "$2/Test.hs" "$2/executable.out"

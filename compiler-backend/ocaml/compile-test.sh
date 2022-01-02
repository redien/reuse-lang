#!/usr/bin/env bash

script_path=$(dirname "$0")
project_root=$script_path/../..

"$($project_root/dev-env/builddir.sh cli)/compiler" --stdlib false --language ocaml --output "$2/executable.ml" "$1"
result=$?
if [ "$result" != "0" ]; then
    >&2 printf "\n in file $1\n"
    exit $result
fi

set -e
$script_path/compile-nostdlib-test.sh "$2/executable.ml" "$2/executable.out"

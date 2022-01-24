#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/tempdir.sh extended-tests)
test_source=$build_dir/test_source.reuse

echo "$1 (def reuse-main (stdin) $2)" > $test_source
"$($project_root/dev-env/builddir.sh cli)/compiler" --language $IMPL --output "$build_dir/$SOURCE" "$test_source"
result=$?
if [ "$result" != "0" ]; then
    >&2 printf "\n in file $1\n"
    exit $result
fi

$project_root/compiler-backend/$IMPL/compile-stdin-test.sh "$build_dir" "$SOURCE" "executable.out"
$build_dir/executable.out

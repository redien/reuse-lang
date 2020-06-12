#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/tempdir.sh extended-tests)
test_source=$build_dir/test_source.reuse

echo "$1 (def reuse-main () $2)" > $test_source
$project_root/compiler-backend/$IMPL/compile-test.sh $test_source $build_dir
./$build_dir/executable.out

exit $?

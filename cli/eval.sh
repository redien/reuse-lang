#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/tempdir.sh extended-tests)
test_source=$build_dir/test_source.reuse
test_source2=$build_dir/test_source2.reuse
test_source3=$build_dir/test_source3.reuse

echo "$1 (def reuse-main () $4)" > $test_source
echo "$2" > $test_source2
echo "$3" > $test_source3

"$($project_root/dev-env/builddir.sh cli)/compiler" --stdlib false --language $IMPL --output "$build_dir/$SOURCE" --module "$test_source2" --module "$test_source3" "$test_source"
result=$?
if [ "$result" != "0" ]; then
    >&2 printf "\n in file $1\n"
    exit $result
fi

$project_root/compiler-backend/$IMPL/compile-nostdlib-test.sh "$build_dir" "$SOURCE" "executable.out"
$build_dir/executable.out

exit $?

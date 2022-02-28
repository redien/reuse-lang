#!/usr/bin/env bash

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/tempdir.sh formatter-tests)

printf '%s' "$2" > $build_dir/source.reuse
$($project_root/dev-env/builddir.sh cli)/compiler -f $build_dir/source.reuse
result=$?
cat $build_dir/source.reuse
exit $?

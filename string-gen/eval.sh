#!/usr/bin/env bash

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/builddir.sh string-gen)

echo "$4" | $build_dir/string-gen

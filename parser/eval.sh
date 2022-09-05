#!/usr/bin/env bash

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/builddir.sh parser)

echo "$4" | $build_dir/source.out

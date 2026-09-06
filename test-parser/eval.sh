#!/usr/bin/env bash

build_dir=$($(dirname "$0")/../dev-env/builddir.sh test-parser)
echo "$4" | $build_dir/test

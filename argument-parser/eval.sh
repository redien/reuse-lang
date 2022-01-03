#!/usr/bin/env bash

build_dir=$($(dirname "$0")/../dev-env/builddir.sh argument-parser)
echo "$2" | $build_dir/test

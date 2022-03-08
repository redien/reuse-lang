#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh spec-parser)

$script_path/build.sh

BUILD_DIR="$build_dir" $project_root/dev-env/build-for-stdin-test.sh \
                                    --module $build_dir/spec-parser.reuse \
                                    $project_root/spec-parser/main.strings \
                                    $project_root/spec-parser/main.reuse

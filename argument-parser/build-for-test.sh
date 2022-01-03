#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh argument-parser)

$script_path/build.sh

BUILD_DIR="$build_dir" $project_root/dev-env/build-for-stdin-test.sh \
                                    --module $build_dir/argument-parser.reuse \
                                    $project_root/argument-parser/main.strings \
                                    $project_root/argument-parser/main.reuse

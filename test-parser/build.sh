#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/builddir.sh test-parser)

$project_root/bin/reusec --language module\
                         --output $build_dir/test-parser.reuse\
                         $project_root/test-parser/test-parser.strings\
                         $project_root/test-parser/test-parser.reuse

$project_root/bin/reusec --language javascript\
                         --output $build_dir/test-parser.js\
                         $project_root/test-parser/test-parser.strings\
                         $project_root/test-parser/test-parser.reuse

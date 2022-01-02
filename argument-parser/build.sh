#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh argument-parser)

$project_root/bin/reusec --language module\
                         --output $build_dir/argument-parser.reuse\
                         $project_root/argument-parser/argument-parser.strings\
                         $project_root/argument-parser/argument-parser.reuse

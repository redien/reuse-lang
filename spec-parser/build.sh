#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/builddir.sh spec-parser)

$project_root/bin/reusec --language module\
                         --output $build_dir/spec-parser.reuse\
                         $project_root/spec-parser/spec-parser.strings\
                         $project_root/spec-parser/spec-parser.reuse

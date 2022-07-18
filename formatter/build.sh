#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh formatter)

$project_root/parser/build.sh

$project_root/bin/reusec --language module\
                         --output $build_dir/formatter.reuse\
                         --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                         $project_root/formatter/formatter.strings\
                         $project_root/formatter/formatter.reuse

$project_root/bin/reusec --language javascript\
                         --output $build_dir/formatter.js\
                         --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                         $project_root/formatter/formatter.strings\
                         $project_root/formatter/formatter.reuse

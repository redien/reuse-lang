#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh compiler-backend)

$project_root/parser/build.sh

# Build compiler
$project_root/reusec --language module\
                     --output $build_dir/compiler-backend.reuse\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     $project_root/compiler-backend/source-string.reuse\
                     $project_root/compiler-backend/common.strings\
                     $project_root/compiler-backend/shared.reuse\
                     $project_root/compiler-backend/identifier-validation.strings\
                     $project_root/compiler-backend/identifier-validation.reuse\
                     $project_root/compiler-backend/compiler-backend.reuse

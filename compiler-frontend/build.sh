#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh compiler-frontend)

$project_root/bin/reusec --language module\
                         --output $build_dir/compiler-frontend.reuse\
                         --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                         $project_root/compiler-frontend/local-transforms.strings\
                         $project_root/compiler-frontend/local-transforms.reuse\
                         $project_root/compiler-frontend/error-reporting.strings\
                         $project_root/compiler-frontend/error-strings.reuse\
                         $project_root/compiler-frontend/error-reporting.reuse\
                         $project_root/compiler-frontend/identifier-validation.strings\
                         $project_root/compiler-frontend/identifier-validation.reuse\
                         $project_root/compiler-frontend/path.strings\
                         $project_root/compiler-frontend/path.reuse

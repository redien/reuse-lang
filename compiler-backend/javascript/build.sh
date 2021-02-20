#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh javascript-compiler)

$project_root/parser/build.sh

# Build compiler
$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     $project_root/argument-parser/argument-parser.strings\
                     $project_root/argument-parser/argument-parser.reuse\
                     $project_root/compiler-frontend/local-transforms.strings\
                     $project_root/compiler-frontend/local-transforms.reuse\
                     $project_root/compiler-frontend/error-reporting.strings\
                     $project_root/compiler-frontend/error-strings.reuse\
                     $project_root/compiler-frontend/error-reporting.reuse\
                     $project_root/compiler-frontend/identifier-validation.strings\
                     $project_root/compiler-frontend/identifier-validation.reuse\
                     $project_root/compiler-frontend/common.strings\
                     $project_root/compiler-backend/shared.reuse\
                     $script_path/javascript.strings\
                     $script_path/javascript.reuse\
                     $project_root/compiler-frontend/path.reuse\
                     $project_root/compiler-frontend/compiler.reuse\
                     $project_root/compiler-frontend/cli.strings\
                     $project_root/compiler-frontend/cli.reuse

cp $project_root/compiler-frontend/Cli.ml $build_dir/Cli.ml

if [ "$1" != "--no-binary" ]; then
    ocamlopt -O3 unix.cmxa \
            -I "$build_dir" \
            "$build_dir/ReuseCompiler.ml" \
            "$build_dir/Cli.ml" \
            -o "$build_dir/compiler"
fi

# Copy run-time dependencies
[ -d $build_dir/data ] || mkdir $build_dir/data
cp $script_path/preamble.js $build_dir/data/preamble.js
cp $script_path/pervasives.js $build_dir/data/pervasives.js

$project_root/standard-library/build.sh
cp $($project_root/dev-env/builddir.sh standard-library)/standard-library.reuse $build_dir/data

cp $($project_root/dev-env/builddir.sh parser)/parser.reuse $build_dir/data

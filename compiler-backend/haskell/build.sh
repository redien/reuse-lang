#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh haskell-compiler)

$project_root/parser/build.sh
$project_root/argument-parser/build.sh
$project_root/compiler-frontend/build.sh

# Build compiler
$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     --module $($project_root/dev-env/builddir.sh argument-parser)/argument-parser.reuse\
                     --module $($project_root/dev-env/builddir.sh compiler-frontend)/compiler-frontend.reuse\
                     $project_root/compiler-backend/common.strings\
                     $project_root/compiler-backend/source-string.reuse\
                     $project_root/compiler-backend/shared.reuse\
                     $project_root/compiler-backend/compiler-backend.reuse\
                     $script_path/haskell.strings\
                     $script_path/haskell.reuse\
                     $project_root/compiler-frontend/cli.strings\
                     $project_root/compiler-frontend/cli.reuse

cp $project_root/compiler-frontend/Cli.ml $build_dir/Cli.ml

ocamlopt -O3 unix.cmxa \
        -I "$build_dir" \
        "$build_dir/ReuseCompiler.ml" \
        "$build_dir/Cli.ml" \
        -o "$build_dir/compiler"

# Copy run-time dependencies
[ -d $build_dir/data ] || mkdir $build_dir/data
cp $script_path/preamble.hs $build_dir/data/preamble.hs
cp $script_path/Pervasives.hs $build_dir/data/Pervasives.hs

$project_root/standard-library/build.sh
cp $($project_root/dev-env/builddir.sh standard-library)/standard-library.reuse $build_dir/data

cp $($project_root/dev-env/builddir.sh parser)/parser.reuse $build_dir/data

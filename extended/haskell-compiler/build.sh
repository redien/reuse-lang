#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh haskell-compiler)

$project_root/parser/build.sh

# Build compiler
$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
                     --module $project_root/string-gen/string-gen.reuse\
                     --module $project_root/sexp-parser/sexp-parser.reuse\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     $script_path/../../cli/argument-parser.strings\
                     $script_path/../../cli/argument-parser.reuse\
                     $script_path/../local-transforms.strings\
                     $script_path/../local-transforms.reuse\
                     $script_path/../source-file.strings\
                     $script_path/../source-file.reuse\
                     $script_path/../common.strings\
                     $script_path/../strings.reuse\
                     $script_path/../common.reuse\
                     $script_path/haskell.strings\
                     $script_path/haskell.reuse\
                     $script_path/../compiler.reuse\
                     $script_path/../../cli/cli.reuse

cp $project_root/cli/Cli.ml $build_dir/Cli.ml

ocamlopt -O3 unix.cmxa \
        -I "$build_dir" \
        "$build_dir/ReuseCompiler.ml" \
        "$build_dir/Cli.ml" \
        -o "$build_dir/compiler-haskell"

# Copy run-time dependencies
[ -d $build_dir/data ] || mkdir $build_dir/data
cp $script_path/preamble.hs $build_dir/data/preamble.hs
cp $script_path/Pervasives.hs $build_dir/data/Pervasives.hs

$project_root/standard-library/build.sh
cp $($project_root/dev-env/builddir.sh standard-library)/standard-library.reuse $build_dir/data

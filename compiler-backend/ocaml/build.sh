#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh ocaml-compiler)

$project_root/parser/build.sh

# Build compiler
$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
                     --module $project_root/string-gen/string-gen.reuse\
                     --module $project_root/sexp-parser/sexp-parser.reuse\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     $project_root/argument-parser/argument-parser.strings\
                     $project_root/argument-parser/argument-parser.reuse\
                     $project_root/compiler-frontend/local-transforms.strings\
                     $project_root/compiler-frontend/local-transforms.reuse\
                     $project_root/compiler-frontend/common.strings\
                     $project_root/compiler-frontend/strings.reuse\
                     $project_root/compiler-frontend/common.reuse\
                     $project_root/compiler-backend/shared.reuse\
                     $script_path/ocaml.strings\
                     $script_path/ocaml.reuse\
                     $project_root/compiler-frontend/compiler.reuse\
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
cp $script_path/preamble.ml $build_dir/data/preamble.ml
cp $script_path/pervasives.ml $build_dir/data/pervasives.ml

$project_root/standard-library/build.sh
cp $($project_root/dev-env/builddir.sh standard-library)/standard-library.reuse $build_dir/data

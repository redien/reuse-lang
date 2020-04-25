#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh ocaml-compiler)

# Build compiler
$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/parser-context.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../../cli/argument-parser.strings\
                     $script_path/../../cli/argument-parser.reuse\
                     $script_path/../../string-gen/string-gen.reuse\
                     $script_path/../common.strings\
                     $script_path/../strings.reuse\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/../source-file.reuse\
                     $script_path/ocaml.strings\
                     $script_path/ocaml.reuse\
                     $script_path/../compiler.reuse\
                     $script_path/../../cli/cli.reuse

cp $project_root/cli/Cli.ml $build_dir/Cli.ml

if [ "$1" != "--no-binary" ]; then
    ocamlopt -O3 unix.cmxa \
            -I "$build_dir" \
            "$build_dir/ReuseCompiler.ml" \
            "$build_dir/Cli.ml" \
            -o "$build_dir/compiler-ocaml"
fi

# Copy run-time dependencies
[ -d $build_dir/data ] || mkdir $build_dir/data
cp $script_path/pervasives.ml $build_dir/data/pervasives.ml
cp $project_root/standard-library/*.reuse $build_dir/data

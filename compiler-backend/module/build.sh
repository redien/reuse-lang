#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_dir=$($project_root/dev-env/builddir.sh module-compiler)

# Build compiler
$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
                     $project_root/string-gen/string-gen.reuse\
                     $project_root/sexp-parser/sexp-parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/scope.reuse\
                     $project_root/parser/symbol-table.reuse\
                     $project_root/parser/symbols.strings\
                     $project_root/parser/symbols.reuse\
                     $project_root/parser/parser-context.strings\
                     $project_root/parser/parser-context.reuse\
                     $project_root/parser/source-file.strings\
                     $project_root/parser/source-file.reuse\
                     $project_root/parser/parser.reuse\
                     $project_root/argument-parser/argument-parser.strings\
                     $project_root/argument-parser/argument-parser.reuse\
                     $project_root/compiler-frontend/local-transforms.strings\
                     $project_root/compiler-frontend/local-transforms.reuse\
                     $project_root/compiler-frontend/common.strings\
                     $project_root/compiler-frontend/strings.reuse\
                     $project_root/compiler-frontend/common.reuse\
                     $project_root/compiler-backend/shared.reuse\
                     $script_path/module.strings\
                     $script_path/module.reuse\
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
cp $script_path/preamble.reuse $build_dir/data/preamble.reuse
cp $script_path/pervasives.reuse $build_dir/data/pervasives.reuse

cp $project_root/bootstrap/data/standard-library.reuse $build_dir/data

#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh parser)

$project_root/reusec --language module\
                     --output $build_dir/parser.reuse\
                     --module $project_root/sexp-parser/sexp-parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/scope.reuse\
                     $project_root/parser/symbol-table.reuse\
                     $project_root/parser/parser-context.reuse\
                     $project_root/parser/parser.reuse

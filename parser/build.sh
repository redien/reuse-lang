#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_dir=$($project_root/dev-env/builddir.sh parser)

$project_root/bin/reusec --language module\
                         --output $build_dir/parser.reuse\
                         $project_root/sexp-parser/sexp-parser.reuse\
                         $project_root/string-gen/string-gen.reuse\
                         $project_root/parser/source-file.strings\
                         $project_root/parser/source-file.reuse\
                         $project_root/parser/ast.reuse\
                         $project_root/parser/scope.reuse\
                         $project_root/parser/symbol-table.reuse\
                         $project_root/parser/parser-context.strings\
                         $project_root/parser/parser-context.reuse\
                         $project_root/parser/errors.reuse\
                         $project_root/parser/symbols.strings\
                         $project_root/parser/symbols.reuse\
                         $project_root/parser/unparser.reuse\
                         $project_root/parser/parser.reuse

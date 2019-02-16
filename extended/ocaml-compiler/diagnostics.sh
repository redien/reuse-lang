#!/usr/bin/env bash

script_path=$(dirname "$0")
project_root=$script_path/../..

$project_root/reusec --diagnostics\
                     --language ocaml\
                     --output $project_root/generated/extended/CompilerOCaml.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/ocaml.strings\
                     $script_path/ocaml.reuse

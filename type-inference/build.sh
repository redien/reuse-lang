#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

[ -d $project_root/generated/type-inference ] || mkdir $project_root/generated/type-inference

$project_root/reusec --language ocaml\
                     --output $project_root/generated/type-inference/source.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $project_root/type-inference/type.reuse\
                     $project_root/type-inference/context.reuse\
                     $project_root/type-inference/type-inference.reuse\
                     $project_root/type-inference/rename-type.reuse\
                     $project_root/type-inference/main.reuse

$project_root/dev-env/compile-stdin-test.sh $project_root/generated/type-inference/source.ml

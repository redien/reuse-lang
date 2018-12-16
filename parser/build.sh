#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

[ -d $project_root/generated/parser ] || mkdir $project_root/generated/parser

$project_root/frontend.sh --executable\
                          --output $project_root/generated/parser/executable\
                          $project_root/sexp-parser/parser.reuse\
                          $project_root/parser/strings.reuse\
                          $project_root/parser/parser.reuse\
                          $project_root/parser/main.reuse

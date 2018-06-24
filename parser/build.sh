#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/sexp-parser/build.sh

>$project_root/generated/parser.reuse echo "
$(cat $project_root/generated/sexp-parser.reuse)
$(cat $project_root/parser/strings.reuse)
$(cat $project_root/parser/parser.reuse)
"

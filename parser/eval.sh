#!/usr/bin/env bash

project_root=$(dirname "$0")/..

echo "$2" | $project_root/extended/compiler/eval.sh "$(cat $project_root/generated/parser.reuse)$1" "(stringify (definitions-to-sexps (sexps-to-definitions (parse stdin))))" --stdin

#!/usr/bin/env bash

project_root=$(dirname "$0")/..

echo "$2" | $project_root/extended/compiler/eval.sh "$(cat $project_root/generated/sexp-parser.reuse)" "(match (parse stdin) (Result expressions) (stringify expressions) (Error _) (list 45))" --stdin

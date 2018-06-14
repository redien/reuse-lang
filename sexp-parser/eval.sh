#!/bin/bash

script_path=$(dirname "$0")

echo "$2" | $script_path/../extended/interpreter/bootstrap/eval.sh "$(cat $script_path/../generated/sexp-parser/parser.reuse)" "(match (parse stdin) (Result expressions) (stringify expressions) (Error _) (list 45))" --stdin

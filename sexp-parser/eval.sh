#!/bin/bash

script_path=$(dirname "$0")

echo "$2" | $script_path/../extended/interpreter/bootstrap/eval.sh "$(cat $script_path/../generated/sexp-parser/parser.clj)" "(stringify (parse stdin))" --stdin

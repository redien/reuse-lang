#!/bin/bash

script_path=$(dirname "$0")

echo "$2" | $script_path/../extended/interpreter/eval.sh "$(cat $script_path/../generated/parser/parser.clj)$1" "(stringify (parse stdin))" --stdin

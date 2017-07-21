#!/bin/bash

script_path=$(dirname "$0")

echo "$2" | $script_path/../extended/bootstrap/eval.sh "$(cat $script_path/parser.clj)$1" "(stringify (parse stdin))" --stdin

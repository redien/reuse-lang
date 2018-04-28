#!/bin/bash

script_path=$(dirname "$0")

echo "$2" | $script_path/../extended/interpreter/bootstrap/eval.sh "$(cat $script_path/../generated/parser/parser.clj)$1" "(stringify (definitions-to-sexps (sexps-to-definitions (parse stdin))))" --stdin

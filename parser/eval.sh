#!/bin/bash

script_path=$(dirname "$0")
standard_library=$script_path/../standard-library

echo "$2" | $script_path/../extended/interpreter/eval.sh "$(cat $standard_library/list.clj)$(cat $standard_library/string.clj)$(cat $standard_library/boolean.clj)$(cat $script_path/parser.clj)$1" "(stringify (parse stdin))" --stdin

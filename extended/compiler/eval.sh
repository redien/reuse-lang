#!/bin/bash

script_path=$(dirname "$0")
project_root="$script_path/../.."

echo "$1 (export main () $2)" | "$project_root/extended/interpreter/bootstrap/eval.sh" "$(cat $project_root/generated/extended/compiler/compiler.clj)" "(to-ocaml (sexps-to-definitions (parse stdin)))" --stdin

result=$?

exit $result


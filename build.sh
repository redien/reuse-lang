#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path
standard_library="$project_root/standard-library"
node_bin=$project_root/node_modules/.bin


$node_bin/babel $project_root/extended -d $project_root/generated/extended >&2
$node_bin/babel $project_root/sexp-parser -d $project_root/generated/sexp-parser >&2
$node_bin/babel $project_root/parser -d $project_root/generated/parser >&2

echo "$(cat $standard_library/list.clj)$(cat $standard_library/string.clj)$(cat $standard_library/boolean.clj)$(cat $project_root/sexp-parser/parser.clj)" > $project_root/generated/sexp-parser/parser.clj
echo "$(cat $standard_library/list.clj)$(cat $standard_library/string.clj)$(cat $standard_library/boolean.clj)$(cat $project_root/sexp-parser/parser.clj)$(cat $project_root/parser/parser.clj)" > $project_root/generated/parser/parser.clj
echo "$(cat $project_root/generated/sexp-parser/parser.clj)$(cat $project_root/extended/interpreter/interpreter.clj)" > $project_root/generated/extended/interpreter/interpreter.clj


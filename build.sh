#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path
standard_library="$project_root/standard-library"
node_bin=$project_root/node_modules/.bin


$node_bin/babel $project_root/extended -d $project_root/generated/extended >&2
$node_bin/babel $project_root/minimal -d $project_root/generated/minimal >&2
$node_bin/babel $project_root/sexp-parser -d $project_root/generated/sexp-parser >&2

mkdir -p $project_root/generated/parser
mkdir -p $project_root/generated/extended/interpreter
mkdir -p $project_root/generated/extended/compiler

standard_library_compiled="
$(cat $standard_library/boolean.reuse)
$(cat $standard_library/pair.reuse)
$(cat $standard_library/maybe.reuse)
$(cat $standard_library/iterator.reuse)
$(cat $standard_library/list.reuse)
$(cat $standard_library/string.reuse)
$(cat $standard_library/result.reuse)"

echo "$standard_library_compiled" > $project_root/generated/standard-library.reuse

echo "$standard_library_compiled $(cat $project_root/sexp-parser/parser.reuse)" > $project_root/generated/sexp-parser/parser.reuse
echo "$standard_library_compiled $(cat $project_root/sexp-parser/parser.reuse)$(cat $project_root/parser/strings.reuse)$(cat $project_root/parser/parser.reuse)" > $project_root/generated/parser/parser.reuse
echo "$(cat $project_root/generated/parser/parser.reuse)$(cat $project_root/extended/interpreter/interpreter.reuse)" > $project_root/generated/extended/interpreter/interpreter.reuse
echo "$(cat $project_root/generated/parser/parser.reuse)$(cat $project_root/extended/compiler/strings.reuse)$(cat $project_root/extended/compiler/compiler.reuse)" > $project_root/generated/extended/compiler/compiler.reuse

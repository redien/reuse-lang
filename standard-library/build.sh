#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

[ -d $project_root/generated ] || mkdir $project_root/generated

>$project_root/generated/standard-library.reuse echo "
$(cat $project_root/standard-library/boolean.reuse)
$(cat $project_root/standard-library/pair.reuse)
$(cat $project_root/standard-library/maybe.reuse)
$(cat $project_root/standard-library/indexed-iterator.reuse)
$(cat $project_root/standard-library/list.reuse)
$(cat $project_root/standard-library/string.reuse)
$(cat $project_root/standard-library/result.reuse)
$(cat $project_root/standard-library/parser.reuse)
$(cat $project_root/standard-library/state.reuse)
$(cat $project_root/standard-library/dictionary.reuse)
"

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
$(cat $project_root/standard-library/state.reuse)
$(cat $project_root/standard-library/dictionary.reuse)
"

if [ "$1" == "--diagnostics" ]; then
    2>&1 echo "[standard-library/build.sh] reusec --language haskell"
fi

$project_root/reusec --language haskell\
                     --output $project_root/generated/Reuse.hs\
                     --nostdlib\
                     $project_root/generated/standard-library.reuse

if [ "$1" == "--diagnostics" ]; then
    2>&1 echo "[standard-library/build.sh] reusec --language ocaml"
fi

$project_root/reusec --language ocaml\
                     --output $project_root/generated/Reuse.ml\
                     --nostdlib\
                     $project_root/generated/standard-library.reuse

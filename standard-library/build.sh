#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/builddir.sh standard-library)

>$build_dir/standard-library.reuse echo "
$(cat $project_root/standard-library/combinators.reuse)
$(cat $project_root/standard-library/boolean.reuse)
$(cat $project_root/standard-library/pair.reuse)
$(cat $project_root/standard-library/maybe.reuse)
$(cat $project_root/standard-library/iterable.reuse)
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
                     --output $build_dir/Reuse.hs\
                     --nostdlib\
                     $build_dir/standard-library.reuse

if [ "$1" == "--diagnostics" ]; then
    2>&1 echo "[standard-library/build.sh] reusec --language ocaml"
fi

$project_root/reusec --language ocaml\
                     --output $build_dir/Reuse.ml\
                     --nostdlib\
                     $build_dir/standard-library.reuse

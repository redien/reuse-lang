#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_source() {
    $project_root/standard-library/build.sh
}

copy_result() {
    cp $project_root/generated/standard-library/Reuse.ml $project_root/standard-library/Reuse.ml
    cp $project_root/generated/standard-library/Reuse.hs $project_root/standard-library/Reuse.hs
}

time build_source
copy_result

>&2 echo Updated successfully!

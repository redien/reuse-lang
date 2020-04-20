#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
stdlib_build_dir=$($project_root/dev-env/builddir.sh standard-library)

build_source() {
    $project_root/standard-library/build.sh
}

copy_result() {
    cp $stdlib_build_dir/Reuse.ml $project_root/bootstrap/Reuse.ml
    cp $stdlib_build_dir/Reuse.hs $project_root/standard-library/Reuse.hs
}

time build_source
copy_result

>&2 echo Updated successfully!

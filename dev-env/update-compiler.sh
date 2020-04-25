#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
build_dir=$($project_root/dev-env/builddir.sh ocaml-compiler)

build_compiler_source() {
    $project_root/extended/ocaml-compiler/build.sh --no-binary
}

build_compiler_binary() {
    $project_root/build.sh
}

copy_compiler() {
    cp $build_dir/*.ml $project_root/bootstrap
    [ -d $project_root/bootstrap/data ] || mkdir $project_root/bootstrap/data
    cp $build_dir/data/* $project_root/bootstrap/data
}

>&2 echo First stage: Build new compiler source
time build_compiler_source
copy_compiler
build_compiler_binary

>&2 echo Second stage: Build source again with binary derived from itself
time build_compiler_source
copy_compiler
build_compiler_binary

>&2 echo Third stage: Build source one last time to make sure it bootstraps
time build_compiler_source

>&2 echo Fourth stage: Run test suite
dev-env/run.sh test

>&2 echo Updated successfully!

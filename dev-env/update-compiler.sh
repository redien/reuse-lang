#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_compiler_source() {
    $project_root/extended/ocaml-compiler/build.sh --no-binary
    $project_root/standard-library/build.sh
}

build_compiler_binary() {
    $project_root/build.sh
}

copy_compiler() {
    cp $project_root/generated/extended/ocaml-compiler/ReuseOcaml.ml $project_root/extended/ocaml-compiler/ReuseOcaml.ml
    cp $project_root/generated/Reuse.ml $project_root/standard-library/Reuse.ml
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

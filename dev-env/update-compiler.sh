#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

build_compiler_source() {
    $project_root/extended/ocaml-compiler/build.sh
}

build_compiler_binary() {
    $project_root/build.sh
}

copy_compiler() {
    cp $project_root/generated/extended/CompilerOCaml.ml $project_root/extended/ocaml-compiler/ocaml.ml
}

>&2 echo First stage: Build new compiler source
build_compiler_source
copy_compiler
build_compiler_binary

>&2 echo Second stage: Build source again with binary derived from itself
build_compiler_source
copy_compiler
build_compiler_binary

>&2 echo Third stage: Build source one last time to make sure it bootstraps
build_compiler_source

>&2 echo Fourth stage: Run test suite
npm test

>&2 echo Updated successfully!

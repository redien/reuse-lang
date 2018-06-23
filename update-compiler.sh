#!/bin/bash

set -e

script_path=$(dirname "$0")

build() {
    $script_path/build.sh
}

copy_compiler() {
    cp $script_path/generated/extended/compiler/compiler.ml $script_path/extended/compiler/compiler.ml
}

build
copy_compiler
build
copy_compiler

>&2 echo Updated successfully!

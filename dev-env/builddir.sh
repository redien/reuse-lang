#!/usr/bin/env bash

# Creates a directory if it does not yet exist and returns the path to it.
# It can also be used to get the build directory of a module which is why this
# script needs to be idempotent.

project_root="$(dirname $0)/.."
generated_dir=$project_root/generated

[ -d $generated_dir ] || mkdir $generated_dir
[ -d $generated_dir/$1 ] || mkdir $generated_dir/$1

echo "$generated_dir/$1"

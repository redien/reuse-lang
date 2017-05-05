#!/bin/bash

current_path=$(pwd)
cd $(dirname "$0")

build_output=$(./compile.sh "$1" "$2" "test")
node -e "console.log(require('../generated/test/lib/js/src/source.js').execute())"

if [ "$?" != "0" ]; then
    echo Build output: >&2
    echo $build_output >&2
fi

cd $current_path

#!/bin/bash

script_path=$(dirname "$0")

$script_path/$1/eval.sh "$2" "$3" 2> build.log

if [ "$?" != "0" ]; then
    echo Build error
    echo $build_output >&2
fi

#!/bin/bash

script_path=$(dirname "$0")

mkdir -p $script_path/../generated/
echo "$1 (export execute () $2)" > $script_path/../generated/eval.lisp

$script_path/partial-eval.sh $script_path/../generated/eval.lisp $script_path/../generated/partial-eval.lisp

cat $script_path/../generated/partial-eval.lisp | sed -E 's/^.*\(export execute \(\) (.+)\).*$/\1/'

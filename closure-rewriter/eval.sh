#!/bin/bash

script_path=$(dirname "$0")

mkdir -p $script_path/../generated/
echo "$1" > $script_path/../generated/program-with-closures.lisp

$script_path/rewrite-closures.sh $script_path/../generated/program-with-closures.lisp $script_path/../generated/program-without-closures.lisp

$script_path/../bootstrap/eval.sh "$(cat $script_path/../generated/program-without-closures.lisp)" "$2"

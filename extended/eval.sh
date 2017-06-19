#!/bin/bash

script_path=$(dirname "$0")

project_root=$script_path/..
generated_folder=$project_root/generated

mkdir -p $generated_folder
echo "$1 (def execute' () $2)" > $generated_folder/program-with-closures.lisp

$script_path/closure-rewriter/rewrite-closures.sh $generated_folder/program-with-closures.lisp $generated_folder/program-without-closures.lisp

$project_root/minimal/bootstrap/eval.sh "$(cat $generated_folder/program-without-closures.lisp)" "(execute')"

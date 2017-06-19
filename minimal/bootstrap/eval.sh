#!/bin/bash

script_path=$(dirname "$0")

project_root=$script_path/../..
generated_folder=$project_root/generated

mkdir -p $generated_folder/
lisp_source=$generated_folder/bootstrap-eval.lisp
echo "$1 (export execute () $2)" > $lisp_source
$script_path/compile-library.sh $lisp_source $generated_folder/bootstrap-eval.js || exit 1
node -e "console.log(require('./$generated_folder/bootstrap-eval.js').execute());"

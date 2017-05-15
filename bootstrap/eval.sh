#!/bin/bash

script_path=$(dirname "$0")

mkdir -p $script_path/../generated/
lisp_source=$script_path/../generated/boostrap-eval.lisp
echo "$1 (export execute () $2)" > $lisp_source
$script_path/compile-library.sh $lisp_source $script_path/../generated/boostrap-eval.js
node -e "console.log(require('./$script_path/../generated/boostrap-eval.js').execute())"

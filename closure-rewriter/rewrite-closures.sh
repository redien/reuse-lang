#!/bin/bash

script_path=$(dirname "$0")

$script_path/../bootstrap/compile-program.sh $script_path/source.lisp $script_path/../generated/closure-rewriter.js
node $script_path/../generated/closure-rewriter.js < $1 > $2

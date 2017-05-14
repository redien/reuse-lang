#!/bin/bash

script_path=$(dirname "$0")

$script_path/../bootstrap/compile-program.sh $script_path/source.lisp $script_path/../generated/minimal-partial-evaluator.js
node $script_path/../generated/minimal-partial-evaluator.js < $1 > $2

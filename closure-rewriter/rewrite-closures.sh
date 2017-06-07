#!/bin/bash

script_path=$(dirname "$0")

cat $script_path/../minimal/core.clj $script_path/../minimal/lang.clj $script_path/closure-rewriter.clj > $script_path/../generated/closure-rewriter.clj
$script_path/../bootstrap/compile-program.sh $script_path/../generated/closure-rewriter.clj $script_path/../generated/closure-rewriter.js
node $script_path/../generated/closure-rewriter.js < $1 > $2

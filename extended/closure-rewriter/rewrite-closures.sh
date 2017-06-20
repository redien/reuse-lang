#!/bin/bash

script_path=$(dirname "$0")

node $script_path/../../generated/closure-rewriter/closure-rewriter.js $1 $2

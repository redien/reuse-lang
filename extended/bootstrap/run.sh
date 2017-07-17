#!/bin/bash

script_path=$(dirname "$0")

$script_path/eval.sh "$(cat $1)" "(main stdin)" --stdin

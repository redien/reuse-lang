#!/bin/bash

current_path=$(pwd)

cd $(dirname "$0")

interpreter_source=$(cat ../minimal-interpreter/source.lisp | tr '\n' ' ')
expression="$1 (export main () $2)"
consed_expression=$(echo "$expression" | od -A n -t d1 | sed -e "s/[^0-9][^0-9]*/ (Cons /g" | tr '\n' ' ' | sed 's/.\{8\}$//')
char_count=$(echo "$expression" | od -A n -t d1 | wc -w --)
consed_expression="$consed_expression Empty$(printf "%${char_count}s" |tr " " ")")"

../bootstrap/eval.sh "$interpreter_source" "(eval $consed_expression)"

cd $current_path

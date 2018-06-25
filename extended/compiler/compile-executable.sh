#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

echo "$(cat $1) (export main (stdin) $2)" > $3/executable.reuse

cat "$3/executable.reuse" | "$project_root/generated/extended/compiler-ocaml" > $3/executable.ml

if [ "$4" == "--stdin" ]
then
    printf "\n$(cat $script_path/../stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main _stdin_list))\n" >> $3/executable.ml
else
    printf "\nPrintf.printf \"%%d\" (Int32.to_int (main ()))\n" >> $3/executable.ml
fi

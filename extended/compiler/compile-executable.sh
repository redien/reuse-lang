#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")

echo "$(cat $1) (export main (stdin) $2)" > $3/executable.reuse
$script_path/compile-library.sh $3/executable.reuse $3

if [ "$4" == "--stdin" ]
then
    printf "\n$(cat $script_path/../stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main _stdin_list))\n" >> $3/ocaml/source.ml
else
    printf "\nPrintf.printf \"%%d\" (Int32.to_int (main ()))\n" >> $3/ocaml/source.ml
fi

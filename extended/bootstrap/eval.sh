#!/bin/bash

script_path=$(dirname "$0")

random_name=$(node -e "console.log(crypto.randomBytes(Math.ceil(12)).toString('hex').slice(0,12))")
generated_folder=$script_path/../../generated/$random_name
mkdir -p $generated_folder

program_source=$generated_folder/program_source.lisp
echo "$1 (export execute () $2)" > $program_source

$script_path/compile-library.sh $program_source $generated_folder
printf "\nPrintf.printf \"%%d\\\n\" (Int32.to_int (execute ()))\n" >> $generated_folder/ocaml/source.ml
docker run --rm -v $PWD/$generated_folder/ocaml:/home/ocaml ocaml/opam:alpine-3.6_ocaml-4.06.0 ocaml ../ocaml/source.ml
result=$?

rm -R $generated_folder

exit $result

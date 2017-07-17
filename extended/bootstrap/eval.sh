#!/bin/bash

script_path=$(dirname "$0")

random_name=$(node -e "console.log(crypto.randomBytes(Math.ceil(12)).toString('hex').slice(0,12))")
generated_folder=$script_path/../../generated/$random_name
mkdir -p $generated_folder

program_source=$generated_folder/program_source.lisp

if [ "$3" == "--stdin" ]
then
    echo "(data (list a) (Cons a (list a)) Empty) $1 (export main_$random_name (stdin) $2)" > $program_source
    $script_path/compile-library.sh $program_source $generated_folder
    printf "\n$(cat $script_path/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main_$random_name _stdin_list))\n" >> $generated_folder/ocaml/source.ml
    docker build $script_path -t reuse-ocaml >&2
    docker run --rm -v $PWD/$generated_folder/ocaml:/home/ocaml reuse-ocaml ocamlfind ocamlc -linkpkg -thread -package core /home/ocaml/source.ml -o /home/ocaml/out
    cat | docker run -i --rm -v $PWD/$generated_folder/ocaml:/home/ocaml reuse-ocaml /home/ocaml/out
else
    echo "$1 (export main_$random_name () $2)" > $program_source
    $script_path/compile-library.sh $program_source $generated_folder
    printf "\nPrintf.printf \"%%d\" (Int32.to_int (main_$random_name ()))\n" >> $generated_folder/ocaml/source.ml
    docker run --rm -v $PWD/$generated_folder/ocaml:/home/ocaml ocaml/opam:alpine-3.6_ocaml-4.06.0 ocaml ../ocaml/source.ml
fi

result=$?

rm -R $generated_folder

exit $result

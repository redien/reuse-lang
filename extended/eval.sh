#!/bin/bash

script_path=$(dirname "$0")

random_name=$(node -e "console.log(crypto.randomBytes(Math.ceil(12)).toString('hex').slice(0,12))")
generated_folder=$script_path/../generated/$random_name
mkdir -p $generated_folder

program_source=$generated_folder/program_source.lisp

if [ "$3" == "--stdin" ]
then
    echo "(typ boolean True False) (typ (result a b) (Result a) (Error b)) (typ (list a) (Cons a (list a)) Empty) $1 (export main_$random_name (stdin) $2)" > $program_source
    $script_path/$IMPL/compile-library.sh $program_source $generated_folder
    printf "\n$(cat $script_path/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main_$random_name _stdin_list))\n" >> $generated_folder/ocaml/source.ml
    opam config exec -- ocamlfind ocamlc -linkpkg -thread -package core $generated_folder/ocaml/source.ml -o $generated_folder/ocaml/out
    cat | opam config exec -- $generated_folder/ocaml/out
else
    echo "(typ boolean True False) (typ (result a b) (Result a) (Error b)) (typ (list a) (Cons a (list a)) Empty) $1 (export main_$random_name () $2)" > $program_source
    $script_path/$IMPL/compile-library.sh $program_source $generated_folder
    printf "\nPrintf.printf \"%%d\" (Int32.to_int (main_$random_name ()))\n" >> $generated_folder/ocaml/source.ml
    ocaml $generated_folder/ocaml/source.ml
fi

result=$?

rm -R $generated_folder

exit $result

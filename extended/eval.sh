#!/bin/bash

set -e

script_path=$(dirname "$0")

generated_folder=$(mktemp -d)
cleanup() {
    rm -R $generated_folder
}
trap cleanup EXIT

program_source=$generated_folder/program_source.reuse

print_source() {
    echo Source: >&2
    cat $1 >&2
    echo >&2
}

print_output() {
    echo Compiled library: >&2
    cat $1 >&2
    echo >&2
}

compile() {
    echo >&2
    print_source $program_source
    $script_path/$IMPL/compile-library.sh $program_source $generated_folder
    print_output $generated_folder/ocaml/source.ml
}

if [ "$3" == "--stdin" ]
then
    echo "$1 (export main (stdin) $2)" > $program_source
    compile
    printf "\n$(cat $script_path/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main _stdin_list))\n" >> $generated_folder/ocaml/source.ml
    
    opam config exec -- ocamlfind ocamlc -linkpkg -thread -package core $generated_folder/ocaml/source.ml -o $generated_folder/ocaml/out
    cat | opam config exec -- $generated_folder/ocaml/out
else
    echo "$1 (export main () $2)" > $program_source
    compile
    printf "\nPrintf.printf \"%%d\" (Int32.to_int (main ()))\n" >> $generated_folder/ocaml/source.ml
    
    ocaml $generated_folder/ocaml/source.ml
fi

result=$?

exit $result

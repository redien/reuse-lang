#!/bin/bash

script_path=$(dirname "$0")

random_name=$(node -e "console.log(crypto.randomBytes(Math.ceil(12)).toString('hex').slice(0,12))")
generated_folder=$script_path/../../generated/$random_name
mkdir -p $generated_folder

program_source=$generated_folder/program_source.lisp

echo "(typ (list a) (Cons a (list a)) Empty) $1 (export main_$random_name (stdin) $2)" > $program_source

if [ "$3" == "--stdin" ]
then
    cat > $generated_folder/input
else
    touch $generated_folder/input
fi

node $script_path/interpreter.js "$program_source" "(main_$random_name stdin)" "$generated_folder/input"

result=$?

rm -R $generated_folder

exit $result

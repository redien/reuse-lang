#!/bin/bash

script_path=$(dirname "$0")

random_name=$(node -e "console.log(crypto.randomBytes(Math.ceil(12)).toString('hex').slice(0,12))")
generated_folder=$script_path/../../generated/$random_name
mkdir -p $generated_folder

program_source=$generated_folder/program_source.lisp
echo "$1 (export execute () $2)" > $program_source

$script_path/compile-library.sh $program_source $generated_folder
node -e "console.log(require('./$generated_folder/javascript/index.js').execute());"
result=$?

rm -R $generated_folder

exit $result

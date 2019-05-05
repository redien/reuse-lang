#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..

$project_root/standard-library/build.sh

[ -d $project_root/generated/sexp-parser ] || mkdir $project_root/generated/sexp-parser

if [ "$1" == "haskell" ]; then
    SOURCEFILE="Test.hs"
elif [ "$1" == "ocaml" ]; then
    SOURCEFILE="source.ml"
else
    1>&2 echo "Error: No language specified"
    exit
fi

$project_root/reusec --language $1\
                     --output $project_root/generated/sexp-parser/$SOURCEFILE\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/sexp-parser/main.reuse

$project_root/extended/$1-compiler/compile-stdin-test.sh $project_root/generated/sexp-parser/$SOURCEFILE $project_root/generated/sexp-parser/source.out

time cat $script_path/perf.txt | ./$project_root/generated/sexp-parser/source.out > /dev/null

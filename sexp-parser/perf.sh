#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..

$project_root/standard-library/build.sh

build_dir=$($project_root/dev-env/builddir.sh parser)

if [ "$1" == "haskell" ]; then
    SOURCEFILE="Test.hs"
elif [ "$1" == "ocaml" ]; then
    SOURCEFILE="source.ml"
else
    1>&2 echo "Error: No language specified"
    exit
fi

$project_root/reusec --language $1\
                     --output $build_dir/$SOURCEFILE\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/sexp-parser/main.reuse

$project_root/extended/$1-compiler/compile-stdin-test.sh $build_dir $SOURCEFILE source.out

time cat $script_path/perf.txt | ./$build_dir/source.out > /dev/null

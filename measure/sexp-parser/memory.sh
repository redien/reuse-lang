#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$($script_path/../../dev-env/builddir.sh measure-repo)

build_dir=$($project_root/dev-env/builddir.sh sexp-parser-perf)

if [ -f "$project_root/sexp-parser/sexp-parser.reuse" ]; then
    source_file="$project_root/sexp-parser/sexp-parser.reuse"
else
    source_file="$project_root/sexp-parser/parser.reuse"
fi

$project_root/reusec --language ocaml\
                     --output $build_dir/perf.ml\
                     $source_file\
                     $project_root/sexp-parser/main.reuse

$project_root/compiler-backend/ocaml/compile-stdin-test.sh $build_dir perf.ml perf

cat $script_path/perf.txt | /usr/bin/time -v $build_dir/perf 2>&1 | grep 'Maximum resident' | awk '{print $NF}'

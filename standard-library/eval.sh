#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

mkdir -p $project_root/generated/tests
generated_source=$(mktemp -p $project_root/generated/tests 'standardlibraryXXXXXX')

echo "$1 (def reuse-main (_) $2)" > $generated_source

$project_root/reusec --language ocaml\
                     --output $generated_source.ml\
                     --nostdlib\
                     $project_root/generated/standard-library.reuse\
                     $generated_source

$project_root/extended/ocaml-compiler/compile-stdin-test.sh $generated_source.ml $generated_source.out

echo "" | $generated_source.out

result=$?

rm $generated_source{,.ml,.ml.out,.out,.ml.2.cmi,.ml.2.cmo}

exit $result

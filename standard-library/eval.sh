#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

mkdir -p $project_root/generated/tests
generated_source=$(mktemp -p $project_root/generated/tests 'standardlibraryXXXXXX')

echo "$1 (export main (_) $2)" > $generated_source

$project_root/reusec --language ocaml\
                     --output $generated_source.ml\
                     --nostdlib\
                     $project_root/generated/standard-library.reuse\
                     $generated_source

$project_root/dev-env/compile-stdin-test.sh $generated_source.ml

echo "" | $generated_source.ml.out

result=$?

rm $generated_source{,.ml,.ml.out,.ml.2.cmi,.ml.2.cmo}

exit $result

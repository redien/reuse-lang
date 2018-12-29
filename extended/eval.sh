#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
mkdir -p $script_path/../generated/tests

generated_folder=$(mktemp -d -p $script_path/../generated/tests)
test_source=$generated_folder/test_source.reuse

echo "$1 (export main () $2)" > $test_source
$script_path/$IMPL/compile-test.sh $test_source $generated_folder
./$generated_folder/executable.ml.out

exit $?

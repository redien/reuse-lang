#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
mkdir -p $script_path/../generated/tests
generated_folder=$(mktemp -d -p $script_path/../generated/tests)

cleanup() {
    rm -R $generated_folder
}
trap cleanup EXIT

program_source=$generated_folder/program_source.reuse

echo "$1 (export main (stdin) $2)" > $program_source
$script_path/$IMPL/compile-executable.sh $program_source $generated_folder "$3"
./$generated_folder/executable

exit $?

#!/usr/bin/env bash
set -e

script_path="$(dirname $0)"
project_root="$script_path/../.."

test_dir=$($project_root/dev-env/tempdir.sh interpreter-eval)

echo "$1 (def reuse-main () $2)" > $test_dir/source.reuse
$($project_root/dev-env/builddir.sh interpreter)/interpreter $test_dir/source.reuse

exit $?

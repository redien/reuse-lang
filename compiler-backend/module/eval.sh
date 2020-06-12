#!/usr/bin/env bash
set -e

script_path="$(dirname $0)"
project_root="$script_path/../.."

test_dir=$($project_root/dev-env/tempdir.sh module-compiler-eval)

echo "$1 (def reuse-main () $2)" > "$test_dir/input.reuse"
$($project_root/dev-env/builddir.sh module-compiler)/compiler-module --minimal true --output "$test_dir/output.reuse" "$test_dir/input.reuse"
$($project_root/dev-env/builddir.sh interpreter)/interpreter "$test_dir/output.reuse"

exit $?

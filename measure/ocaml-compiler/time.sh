#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$($script_path/../../dev-env/builddir.sh measure-repo)

build_dir=$($project_root/dev-env/builddir.sh ocaml-compiler-perf)

seconds=$((time -p $project_root/bin/reusec --output $build_dir/source.ml $script_path/source.reuse > /dev/null) 2>&1 | grep real | awk '{print $2}')

echo $seconds

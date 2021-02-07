#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$($script_path/../../dev-env/builddir.sh measure-repo)

build_dir=$($project_root/dev-env/builddir.sh ocaml-compiler-perf)

/usr/bin/time -v $project_root/bin/reuse-ocaml --nostdlib false --output $build_dir/source.ml $script_path/source.reuse 2>&1 | grep 'Maximum resident' | awk '{print $NF}'

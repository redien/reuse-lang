#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$($script_path/../../dev-env/builddir.sh measure-repo)

build_dir=$($project_root/dev-env/builddir.sh stdlib-dictionary-perf)

# We just want the standard library for testing so compile an empty source file
echo "" > $build_dir/empty-source.reuse
$project_root/bin/reuse-ocaml --output $build_dir/Reuse.ml \
                              $build_dir/empty-source.reuse

cp $script_path/$1.ml $build_dir/$1.ml

ocamlopt unix.cmxa \
         -I "$build_dir" \
         "$build_dir/Reuse.ml" \
         "$build_dir/$1.ml" \
         -o "$build_dir/$1"

$build_dir/$1

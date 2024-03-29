#!/usr/bin/env bash
set -e

project_root=$(dirname $0)

[ -d $project_root/bin ] || mkdir $project_root/bin
[ -d $project_root/bin/data ] || mkdir $project_root/bin/data

build_dir=$($project_root/dev-env/builddir.sh bootstrap)

cp -R $project_root/bootstrap/* $build_dir
cp -R $build_dir/data/* $project_root/bin/data

ocamlopt -O3 unix.cmxa \
         -I "$build_dir" \
         "$build_dir/ReuseCompiler.ml" \
         "$build_dir/Cli.ml" \
         -o "$project_root/bin/reusec"

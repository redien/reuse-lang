#!/usr/bin/env bash
set -e

project_root=$(dirname $0)

[ -d $project_root/bin ] || mkdir $project_root/bin

build_dir=$($project_root/dev-env/builddir.sh bootstrap)

cp -R $project_root/bootstrap/* $build_dir

ocamlopt -O3 unix.cmxa \
         -I "$build_dir" \
         "$build_dir/Reuse.ml" \
         "$build_dir/pervasives.ml" \
         "$build_dir/StdinWrapper.ml" \
         "$build_dir/ReuseCompiler.ml" \
         "$build_dir/CompilerMain.ml" \
         -o "$project_root/bin/reuse-ocaml"

$project_root/extended/haskell-compiler/build.sh
cp "$($project_root/dev-env/builddir.sh haskell-compiler)/compiler-haskell" "$project_root/bin/reuse-haskell"

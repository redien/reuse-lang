#!/usr/bin/env bash
set -e

project_root=$(dirname $0)

[ -d $project_root/bin ] || mkdir $project_root/bin

ocamlopt -O3 unix.cmxa \
         -I "$project_root/bootstrap" \
         "$project_root/bootstrap/Reuse.ml" \
         "$project_root/bootstrap/Pervasives.ml" \
         "$project_root/bootstrap/StdinWrapper.ml" \
         "$project_root/bootstrap/ReuseCompiler.ml" \
         "$project_root/bootstrap/CompilerMain.ml" \
         -o "$project_root/bin/reuse-ocaml"

$project_root/extended/haskell-compiler/build.sh
cp "$project_root/generated/extended/haskell-compiler/compiler-haskell" "$project_root/bin/reuse-haskell"

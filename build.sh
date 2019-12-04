#!/usr/bin/env bash
set -e

project_root=$(dirname $0)

[ -d $project_root/bin ] || mkdir $project_root/bin

ocamlopt -O3 unix.cmxa \
         -I "$project_root/standard-library" \
         -I "$project_root/extended/ocaml-compiler" \
         "$project_root/standard-library/Reuse.ml" \
         "$project_root/extended/ocaml-compiler/Pervasives.ml" \
         "$project_root/extended/ocaml-compiler/StdinWrapper.ml" \
         "$project_root/extended/ocaml-compiler/ReuseOcaml.ml" \
         "$project_root/extended/ocaml-compiler/Compiler.ml" \
         -o "$project_root/bin/reuse-ocaml"

ocamlopt -O3 unix.cmxa \
         -I "$project_root/standard-library" \
         -I "$project_root/extended/ocaml-compiler" \
         "$project_root/standard-library/Reuse.ml" \
         "$project_root/extended/ocaml-compiler/Pervasives.ml" \
         "$project_root/extended/ocaml-compiler/StdinWrapper.ml" \
         "$project_root/string-gen/StringGen.ml" \
         -o "$project_root/bin/string-gen"

$project_root/extended/haskell-compiler/build.sh
cp "$project_root/generated/extended/haskell-compiler/compiler-haskell" "$project_root/bin/reuse-haskell"

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
         -o "$project_root/bin/reuse-ocaml"

$project_root/compiler-backend/module/build.sh
[ -f "$project_root/bin/reuse-module" ] && rm "$project_root/bin/reuse-module"
cp "$($project_root/dev-env/builddir.sh module-compiler)/compiler" "$project_root/bin/reuse-module"
cp "$($project_root/dev-env/builddir.sh module-compiler)/data/pervasives.reuse" "$project_root/bin/data/pervasives.reuse"
cp "$($project_root/dev-env/builddir.sh module-compiler)/data/preamble.reuse" "$project_root/bin/data/preamble.reuse"

$project_root/compiler-backend/haskell/build.sh
[ -f "$project_root/bin/reuse-haskell" ] && rm "$project_root/bin/reuse-haskell"
cp "$($project_root/dev-env/builddir.sh haskell-compiler)/compiler" "$project_root/bin/reuse-haskell"
cp "$($project_root/dev-env/builddir.sh haskell-compiler)/data/Pervasives.hs" "$project_root/bin/data/Pervasives.hs"
cp "$($project_root/dev-env/builddir.sh haskell-compiler)/data/preamble.hs" "$project_root/bin/data/preamble.hs"

$project_root/compiler-backend/javascript/build.sh
[ -f "$project_root/bin/reuse-javascript" ] && rm "$project_root/bin/reuse-javascript"
cp "$($project_root/dev-env/builddir.sh javascript-compiler)/compiler" "$project_root/bin/reuse-javascript"
cp "$($project_root/dev-env/builddir.sh javascript-compiler)/data/pervasives.js" "$project_root/bin/data/pervasives.js"
cp "$($project_root/dev-env/builddir.sh javascript-compiler)/data/preamble.js" "$project_root/bin/data/preamble.js"

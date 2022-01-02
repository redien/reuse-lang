#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh cli)

$project_root/parser/build.sh
$project_root/argument-parser/build.sh
$project_root/compiler-frontend/build.sh
$project_root/compiler-backend/build.sh

build_compiler_module() {
    $project_root/reusec --language module\
                         --output $build_dir/$1.reuse\
                         --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                         --module $($project_root/dev-env/builddir.sh argument-parser)/argument-parser.reuse\
                         --module $($project_root/dev-env/builddir.sh compiler-frontend)/compiler-frontend.reuse\
                         --module $($project_root/dev-env/builddir.sh compiler-backend)/compiler-backend.reuse\
                         $project_root/compiler-backend/common.strings\
                         $project_root/compiler-backend/$1/$1.strings\
                         $project_root/compiler-backend/$1/$1.reuse

    # Copy run-time dependencies
    [ -d $build_dir/data ] || mkdir $build_dir/data
    cp $project_root/compiler-backend/$1/*reamble.* $build_dir/data/
    cp $project_root/compiler-backend/$1/*ervasives.* $build_dir/data/
}

backends="$(cd $project_root/compiler-backend/ && ls -d */ | xargs -n 1 basename)"
backend_modules=""

echo "(def compiler-backends () (list " > $build_dir/backends.reuse

while IFS= read -r backend; do
    build_compiler_module $backend
    echo "(compiler-backend-$backend)" >> $build_dir/backends.reuse
    backend_modules="$backend_modules --module $build_dir/$backend.reuse"
done <<< "$backends"

echo "))" >> $build_dir/backends.reuse

# Build compiler
$project_root/reusec --language ocaml\
                     --output $build_dir/ReuseCompiler.ml\
                     --module $($project_root/dev-env/builddir.sh parser)/parser.reuse\
                     --module $($project_root/dev-env/builddir.sh argument-parser)/argument-parser.reuse\
                     --module $($project_root/dev-env/builddir.sh compiler-frontend)/compiler-frontend.reuse\
                     --module $($project_root/dev-env/builddir.sh compiler-backend)/compiler-backend.reuse\
                     $backend_modules\
                     $build_dir/backends.reuse\
                     $project_root/cli/cli.strings\
                     $project_root/cli/cli.reuse

cp $project_root/cli/Cli.ml $build_dir/Cli.ml

if [ "$1" != "--no-binary" ]; then
    ocamlopt -O3 unix.cmxa \
            -I "$build_dir" \
            "$build_dir/ReuseCompiler.ml" \
            "$build_dir/Cli.ml" \
            -o "$build_dir/compiler"
fi

$project_root/standard-library/build.sh
cp $($project_root/dev-env/builddir.sh standard-library)/standard-library.reuse $build_dir/data
cp $($project_root/dev-env/builddir.sh parser)/parser.reuse $build_dir/data

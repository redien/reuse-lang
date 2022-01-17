#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..
build_dir=$($project_root/dev-env/builddir.sh standard-library)

$script_path/build.sh

$project_root/bin/reusec --language haskell\
                         --output $build_dir/ReuseStdlib.hs\
                         --stdlib false\
                         $build_dir/standard-library.reuse

test_file() {
    echo Testing properties of $1
    cp standard-library/specification/$1.hs $build_dir/$1.hs
    ghc -e Main.main $build_dir/$1.hs $build_dir/ReuseStdlib.hs $build_dir/conversions.hs
}

cp standard-library/specification/conversions.hs $build_dir/conversions.hs
test_file string
test_file list
test_file dictionary
test_file array
test_file bigint

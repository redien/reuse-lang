#!/usr/bin/env bash

project_root=$(dirname $0)/..
build_dir=$($project_root/dev-env/builddir.sh repl)

while [[ $# -gt 0 ]]
do
    arg="$1"

    case $arg in
        --nostdlib)
            nostdlib=true
            shift
        ;;
        --*)
            throw_error Unrecognized flag $arg
        ;;
        *)
            additional_sources="$additional_sources $arg"
            shift
        ;;
    esac
done

eval_reuse() {
    echo "(def reuse-main (_) $1)" > $build_dir/repl.reuse

    $project_root/reusec --language ocaml\
                         --output $build_dir/repl.ml\
                         --nostdlib\
                         $additional_sources\
                         $build_dir/repl.reuse

    if [ "$?" != "0" ]; then
        echo
        cleanup
        return
    fi

    $project_root/extended/ocaml-compiler/compile-stdin-test.sh $build_dir repl.ml repl.out
    if [ -e "$build_dir/repl.out" ]; then
        echo "" | $build_dir/repl.out
        printf "\n"
    fi
    cleanup
}

printf "Reuse REPL\n"
while read -p "> " -e line; do
    history -s "$line"
    eval_reuse "$line"
done

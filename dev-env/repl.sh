#!/usr/bin/env bash

project_root=$(dirname $0)/..
generated_source=$project_root/generated/repl.reuse

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

if [ "$nostdlib" != "true" ]; then
    $project_root/standard-library/build.sh
    additional_sources="$project_root/generated/standard-library.reuse $additional_sources"
fi

cleanup() {
    rm $generated_source{,.ml,.ml.out,.out,.ml.2.cmi,.ml.2.cmo} 2>/dev/null
}

eval_reuse() {
    echo "(def main (_) $1)" > $generated_source

    $project_root/reusec --language ocaml\
                         --output $generated_source.ml\
                         --nostdlib\
                         $additional_sources\
                         $generated_source

    if [ "$?" != "0" ]; then
        echo
        cleanup
        return
    fi

    $project_root/dev-env/compile-stdin-test.sh $generated_source.ml $generated_source.out
    if [ -e "$generated_source.out" ]; then
        echo "" | $generated_source.out
        printf "\n"
    fi
    cleanup
}

printf "Reuse REPL\n"
while read -p "> " -e line; do
    history -s "$line"
    eval_reuse "$line"
done

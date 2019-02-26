#!/usr/bin/env bash

project_root=$(dirname $0)/..

$project_root/standard-library/build.sh

generated_source=$project_root/generated/repl.reuse

eval_reuse() {
    echo "$1 (export main (_) $2)" > $generated_source

    $project_root/reusec --language ocaml\
                         --output $generated_source.ml\
                         --nostdlib\
                         $project_root/generated/standard-library.reuse\
                         $generated_source

    $project_root/dev-env/compile-stdin-test.sh $generated_source.ml
    if [ -e "$generated_source.ml.out" ]; then
        echo "" | $generated_source.ml.out
        printf "\n"
    fi
    rm $generated_source{,.ml,.ml.out,.ml.2.cmi,.ml.2.cmo} 2>/dev/null
}

printf "Reuse REPL\n"
while read -p "> " -e line; do
    history -s "$line"
    eval_reuse "" "$line"
done

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

program=''

eval_reuse() {
    local input="$1"
    local new_program="$program"

    if [[ "${input:0:5}" == "(def " || "${input:0:9}" == "(pub def " ||
          "${input:0:5}" == "(typ " || "${input:0:9}" == "(pub typ " ]]; then
        new_program="$program $input"
        echo "$new_program (def reuse-main () 1)" > $build_dir/repl.reuse
        $project_root/generated/interpreter/interpreter $build_dir/repl.reuse > /dev/null
    else
        echo "$program (def reuse-main () $input)" > $build_dir/repl.reuse
        $project_root/generated/interpreter/interpreter $build_dir/repl.reuse
    fi

    if [ "$?" != "0" ]; then
        echo
        return
    else
        echo
        program="$new_program"
    fi
}

printf "Reuse REPL\n"
while read -p "> " -e line; do
    history -s "$line"
    eval_reuse "$line"
done

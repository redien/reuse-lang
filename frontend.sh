#!/usr/bin/env bash

set -e

REUSE_SOURCE=""
REUSE_OUTPUT=""
REUSE_MINIMAL=false
REUSE_EXECUTABLE=false
REUSE_NOSTDLIB=false

while [[ $# -gt 0 ]]
do
    arg="$1"

    case $arg in
        --minimal)
            REUSE_MINIMAL=true
            shift
        ;;
        --executable)
            REUSE_EXECUTABLE=true
            shift
        ;;
        --nostdlib)
            REUSE_NOSTDLIB=true
            shift
        ;;
        --output)
            REUSE_OUTPUT="$2"
            shift
            shift
        ;;
        --*)
            echo Unrecognized flag $arg
            exit 1
        ;;
        *)
            REUSE_SOURCE="$REUSE_SOURCE
$(cat $arg)"
            shift
        ;;
    esac
done

if [ "$REUSE_OUTPUT" == "" ]; then
    echo No output file specified, please use the --output [file] flag. >&2
    exit 1
fi

if [[ "$REUSE_NOSTDLIB" == "true" && "$REUSE_EXECUTABLE" == "true" ]]; then
    echo Cannot compile an executable without the standard library >&2
    exit 1
fi

root_path=$(dirname $(readlink -f "$0"))

if [ "$REUSE_NOSTDLIB" == "false" ]; then
    REUSE_SOURCE="$(cat $root_path/generated/standard-library.reuse)
$REUSE_SOURCE"
fi

if [ "$REUSE_EXECUTABLE" == "true" ]; then
    echo "$REUSE_SOURCE" | $root_path/bin/reuse-ocaml > $REUSE_OUTPUT.ml
    printf "\n$(cat $root_path/extended/ocaml-compiler/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main _stdin_list))\n" >> $REUSE_OUTPUT.ml
    ocamlc -g $REUSE_OUTPUT.ml -o $REUSE_OUTPUT
    rm $REUSE_OUTPUT.ml
    chmod +x $REUSE_OUTPUT
else
    echo "$REUSE_SOURCE" | $root_path/bin/reuse-ocaml > $REUSE_OUTPUT
fi

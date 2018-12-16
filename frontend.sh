#!/usr/bin/env bash

set -e

REUSE_SOURCE=""
REUSE_OUTPUT=""
REUSE_MINIMAL=false
REUSE_STDIN=false
REUSE_EXECUTABLE=false
REUSE_NOSTDLIB=false

while [[ $# -gt 0 ]]
do
    arg="$1"

    case $arg in
        --stdin)
        REUSE_STDIN=true
        shift
        ;;
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

root_path=$(dirname $0)

if [ "$REUSE_NOSTDLIB" == "false" ]; then
    REUSE_SOURCE="$(cat $root_path/generated/standard-library.reuse)
$REUSE_SOURCE"
fi

if [ "$REUSE_EXECUTABLE" == "true" ]; then
    echo "$REUSE_SOURCE" | $root_path/bin/reuse-ocaml > $REUSE_OUTPUT.ml
    if [ "$REUSE_STDIN" == "true" ]; then
        printf "\n$(cat $root_path/extended/ocaml-compiler/stdin_wrapper.ml)\nPrintf.printf \"%%s\" (_list_to_string (main _stdin_list))\n" >> $REUSE_OUTPUT.ml
    else
        printf "\nPrintf.printf \"%%d\" (Int32.to_int (main ()))\n" >> $REUSE_OUTPUT.ml
    fi
    ocamlc -g $REUSE_OUTPUT.ml -o $REUSE_OUTPUT
    rm $REUSE_OUTPUT.ml
    chmod +x $REUSE_OUTPUT
else
    echo "$REUSE_SOURCE" | $root_path/bin/reuse-ocaml > $REUSE_OUTPUT
fi

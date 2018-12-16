#!/usr/bin/env bash

set -e

REUSE_SOURCE=""
REUSE_OUTPUT=""
REUSE_MINIMAL=false
REUSE_EXECUTABLE=false
REUSE_NOSTDLIB=false

usage() {
    echo Usage: $(basename $0) [flags] --output [OUTPUT FILE] [FILE]... >&2
    echo >&2
    echo Compiler for the Reuse programming language>&2
    echo >&2
    echo "       --minimal         Only use the minimal subset language" >&2
    echo "       --executable      Compile an executable file" >&2
    echo "       --nostdlib        Do not include the standard library" >&2
    echo "       --output [FILE]   Write output to FILE" >&2
}

throw_error() {
    echo $(basename $0): $@ >&2
    echo >&2
    usage
    exit 1
}

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
            throw_error Unrecognized flag $arg
        ;;
        *)
            REUSE_SOURCE="$REUSE_SOURCE
$(cat $arg)"
            shift
        ;;
    esac
done

if [ "$REUSE_OUTPUT" == "" ]; then
    throw_error No output file specified, please use the --output [file] flag.
fi

if [[ "$REUSE_NOSTDLIB" == "true" && "$REUSE_EXECUTABLE" == "true" ]]; then
    throw_error Cannot compile an executable without the standard library
fi

if command -v readlink ; then
    root_path=$(dirname $(readlink -f "$0"))
else
    root_path=$(dirname $(greadlink -f "$0"))
fi

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

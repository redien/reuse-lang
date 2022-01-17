#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

cat << END_OF_SOURCE > "$1/$2.2.hs"
import Text.Printf
import Test
import StdinWrapper

main = do
    stdin_list <- StdinWrapper.stdin_list
    printf "%s" (list_to_string (reuse_main (hs_string_to_indexed_iterator stdin_list)))

END_OF_SOURCE

cp $script_path/StdinWrapper.hs $1

ghc "$1/$2" "$1/Reuse.hs" "$1/StdinWrapper.hs" "$1/$2.2.hs" -o "$1/$3"
rm "$1/$2.2.hs"
chmod +x "$1/$3"

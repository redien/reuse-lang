#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

cat << END_OF_SOURCE > "$1.2.hs"
import Text.Printf
import Test
import StdinWrapper

main = do
    stdin_list <- StdinWrapper.stdin_list
    printf "%s" (list_to_string (reuse_45main stdin_list))

END_OF_SOURCE

ghc "$1" "$project_root/generated/Reuse.hs" "$script_path/StdinWrapper.hs" "$1.2.hs" -o "$2"
rm "$1.2.hs"
chmod +x "$2"

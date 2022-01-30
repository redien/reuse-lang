#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

cat << END_OF_SOURCE > "$1/$2.2.hs"
{-# LANGUAGE BangPatterns #-}
import Data.Maybe
import Data.Int
import Data.List
import Data.Char
import Control.Exception
import Control.DeepSeq
import Text.Printf
import $(basename $2 .hs)
$(cat $script_path/StdinWrapper.hs)

main = do
    stdin <- stdin_list
    printf "%s" (list_to_string (reuse_main (hs_string_to_indexed_iterator stdin)))

END_OF_SOURCE

>&2 ghc "$1/$2" "$1/$2.2.hs" -o "$1/$3"
rm "$1/$2.2.hs"
chmod +x "$1/$3"

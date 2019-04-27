#!/usr/bin/env bash
set -e

printf "$(cat $1)\nmain = putStrLn (show reuse_45main)\n" > "$1.2.hs"
ghc -v0 "$1.2.hs" -o "$2"
rm "$1.2.hs"
chmod +x "$2"

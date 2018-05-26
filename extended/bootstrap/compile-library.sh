#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
reuse_script=$project_root/generated/extended/bootstrap/reuse.js

echo >&2

echo Source: >&2
cat $1 >&2
echo >&2

echo OCaml: >&2
mkdir -p $2/ocaml
node $reuse_script $1 $2/ocaml ocaml >&2
cat $2/ocaml/source.ml >&2
echo >&2

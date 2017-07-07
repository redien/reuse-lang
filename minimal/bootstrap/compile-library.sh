#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
node_bin=$project_root/node_modules/.bin
reuse_script=$project_root/generated/minimal/bootstrap/reuse.js

echo >&2

echo Source: >&2
cat $1 >&2
echo >&2
echo >&2

echo OCaml: >&2
mkdir -p $2/ocaml
node $reuse_script $1 $2/ocaml ocaml >&2
cat $2/ocaml/source.ml >&2
echo >&2
echo >&2
docker run --rm -v $PWD/$2/ocaml:/home/ocaml ocaml/opam:alpine-3.6_ocaml-4.06.0 ocamlc ../ocaml/source.ml >&2

echo Javascript: >&2
mkdir -p $2/javascript
node $reuse_script $1 $2/javascript javascript >&2
$node_bin/prettier --single-quote --no-semi --print-width 80 --tab-width 4 --write $2/javascript/index.js >&2
cat $2/javascript/index.js >&2
echo >&2
echo >&2

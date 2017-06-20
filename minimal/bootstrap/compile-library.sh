#!/bin/bash

script_path=$(dirname "$0")

project_root=$script_path/../..
generated_path=$project_root/generated

rm -R $generated_path/bootstrap-ocaml/src >/dev/null >&2
rm -R $generated_path/bootstrap-ocaml/lib >/dev/null >&2
rm -R $generated_path/bootstrap-javascript >/dev/null >&2
rm -R $2 >/dev/null >&2

$project_root/node_modules/.bin/babel minimal -d generated >&2

node $generated_path/bootstrap/reuse.js $1 bootstrap-javascript javascript >&2 || exit 1
node $generated_path/bootstrap/reuse.js $1 bootstrap-ocaml ocaml >&2 || exit 1

cat $generated_path/bootstrap-ocaml/src/source.ml >&2
echo >&2

$project_root/node_modules/.bin/prettier --single-quote --no-semi --print-width 80 --tab-width 4 --write $generated_path/bootstrap-javascript/src/source.js >&2

current_path=$(pwd)
cd $generated_path/bootstrap-ocaml
npm install >&2
node_modules/.bin/bsb >&2 || exit 1
cd $current_path

cp $generated_path/bootstrap-javascript/src/source.js $2

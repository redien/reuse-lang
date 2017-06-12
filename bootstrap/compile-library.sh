#!/bin/bash

script_path=$(dirname "$0")

rm -R $script_path/../generated/bootstrap-ocaml/src >/dev/null >&2
rm -R $script_path/../generated/bootstrap-ocaml/lib >/dev/null >&2
rm -R $script_path/../generated/bootstrap-javascript >/dev/null >&2
rm -R $2 >/dev/null >&2

node $script_path/reuse.js $1 bootstrap-javascript javascript >&2
node $script_path/reuse.js $1 bootstrap-ocaml ocaml >&2

cat $script_path/../generated/bootstrap-ocaml/src/source.ml >&2
echo >&2

$script_path/../node_modules/.bin/prettier --single-quote --no-semi --print-width 80 --tab-width 4 --write $script_path/../generated/bootstrap-javascript/src/source.js >&2

current_path=$(pwd)
cd $script_path/../generated/bootstrap-ocaml
npm install >&2
node_modules/.bin/bsb >&2 || exit 1
cd $current_path

cp $script_path/../generated/bootstrap-javascript/src/source.js $2

#!/bin/bash

script_path=$(dirname "$0")

rm -R $script_path/../generated/bootstrap-library/src >/dev/null >&2
rm -R $script_path/../generated/bootstrap-library/lib >/dev/null >&2
rm -R $2 >/dev/null >&2

node $script_path/reuse.js $1 bootstrap-library >&2

current_path=$(pwd)
cd $script_path/../generated/bootstrap-library
npm install >&2
npm run compile >&2
cd $current_path

cp $script_path/../generated/bootstrap-library/lib/js/src/source.js $2

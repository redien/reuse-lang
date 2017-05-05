#!/bin/bash

current_path=$(pwd)
cd $(dirname "$0")

echo "$1 (export execute () $2)" > ../generated/$3.lisp
rm -R ../generated/$3/src >/dev/null 2>&1
rm -R ../generated/$3/lib >/dev/null 2>&1
node reuse.js ../generated/$3.lisp $3 2>&1 ; cd ../generated/$3 ; npm install 2>&1 ; npm run build 2>&1

cd $current_path

#!/bin/bash

current_path=$(pwd)

cd $(dirname "$0")

echo "(define execute () $1)" > ../generated/test.lisp
build_output=$(node reuse.js ../generated/test.lisp test 2>&1 ; cd ../generated/test ; npm install 2>&1 ; npm run build 2>&1)
node -e "console.log(require('../generated/test/lib/js/src/source.js').execute())"

if [ "$?" != "0" ]; then
    echo Build output: >&2
    echo $build_output >&2
fi

cd $current_path

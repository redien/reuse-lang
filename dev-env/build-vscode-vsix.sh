#!/usr/bin/env bash

script_path="$(dirname $0)"
project_path="$(dirname $0)/.."

$project_path/formatter/build.sh
cp $project_path/generated/formatter/formatter.js $script_path/editor-support/vs-code-reuse/src/formatter.js

cd $script_path/editor-support/vs-code-reuse
npx vsce package

#!/usr/bin/env bash

cd $(dirname $0)/editor-support/vs-code-reuse
npx vsce package

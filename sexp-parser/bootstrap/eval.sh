#!/bin/bash

script_path=$(dirname "$0")

node -e "var ast = require('$script_path/ast'); var parser = require('$script_path/parser'); console.log(ast.toString(parser.parse(process.argv[1]).ast).slice(1, -1));" "$2"

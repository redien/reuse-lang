#!/usr/bin/env bash

project_root=$(dirname "$0")/..

echo "$2" | $project_root/generated/parser/ocaml/executable

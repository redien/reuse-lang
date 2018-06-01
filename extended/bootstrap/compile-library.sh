#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
reuse_script=$project_root/generated/extended/bootstrap/reuse.js

mkdir -p $2/ocaml
node $reuse_script $1 $2/ocaml ocaml >&2

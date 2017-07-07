#!/bin/bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
node_bin=$project_root/node_modules/.bin

$node_bin/babel $project_root/extended -d $project_root/generated/extended >&2
$node_bin/babel $project_root/parser -d $project_root/generated/parser >&2

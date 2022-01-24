#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..
echo "" | $project_root/cli/eval-stdin.sh "$1" "$2"

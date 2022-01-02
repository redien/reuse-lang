#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

$project_root/cli/build.sh

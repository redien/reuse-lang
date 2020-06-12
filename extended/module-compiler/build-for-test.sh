#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

$project_root/interpreter/build.sh
$script_path/build.sh

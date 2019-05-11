#!/usr/bin/env bash
set -e

script_path="$(dirname $0)"
project_root="$script_path/../.."

echo "$1 (def main () $2)" | $project_root/generated/extended/interpreter

exit $?

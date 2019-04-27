#!/usr/bin/env bash

script_path=$(dirname "$0")
project_root=$script_path/../..

$script_path/build.sh --diagnostics

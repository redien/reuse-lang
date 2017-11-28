#!/bin/bash

script_path=$(dirname "$0")
standard_library=$script_path/../standard-library 

program="$(cat $standard_library/list.clj)$(cat $standard_library/string.clj)$(cat $standard_library/boolean.clj)$(cat $script_path/parser.clj)"

echo "$program" > $script_path/../generated/parser/parser.clj


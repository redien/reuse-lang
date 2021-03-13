#!/usr/bin/env bash

script_path="$(dirname $0)"
project_root="$script_path/.."

name="$1"
date=$(date -u +"%Y-%m-%d-%H-%M")
random=$(head -c 5 /dev/random | base32)

basedir="$project_root/generated/$name"

[ -d $basedir ] || mkdir $basedir
[ -d $basedir/$date-$random ] || mkdir $basedir/$date-$random

echo "$basedir/$date-$random"

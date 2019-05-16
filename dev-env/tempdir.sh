#!/usr/bin/env bash

script_path="$(dirname $0)"
project_root="$script_path/.."

name="$1"
date=$(date -u +"%Y-%m-%d-%H-%M")
random=$(cat /dev/random | base32 | head -c 8)

basedir="$project_root/generated/$name"

[ -d $basedir ] || mkdir $basedir
[ -d $basedir/$date ] || mkdir $basedir/$date

generated=$basedir/$date/$random

mkdir $generated
echo "$generated"

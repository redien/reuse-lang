#!/usr/bin/env bash

IMPL=compiler `dirname $0`/../eval.sh "$1" "$2" "$3"

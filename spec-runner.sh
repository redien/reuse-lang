#!/bin/bash

spec=$1
eval_command=$2

tests=0
passing=0
failing=0

function testLine {
    result=$($eval_command ${1:2})

    tests=$((tests+1))

    if [ "$result" == "${2:2}" ]; then
        echo ok $tests - ${1:2}
        passing=$((passing+1))
    else
        echo not ok $tests - ${1:2}
        echo  ---
        echo    expected: \'${2:2}\'
        echo    actual:   \'$result\'
        echo  ...
        failing=$((failing+1))
    fi
}

echo TAP version 13

for f in $spec/*
do
    while read line; do
        firstChar=${line:0:1}
        if [ "$firstChar" == ">" ]; then
            read expected
            testLine "$line" "$expected"
        else
            if [ "$line" != "" ]; then
                echo \# $line
            fi
        fi
    done <$f
done

echo 1..$tests

echo \# tests $tests
echo \# pass  $passing
echo \# fail  $failing

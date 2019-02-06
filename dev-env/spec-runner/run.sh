#!/bin/bash

spec=$1
eval_command=$2

tests=0
passing=0
failing=0

mkdir -p generated
rm generated/build.log > /dev/null 2>&1

function testLine {
    if [ "${3:0:1}" == "=" ]; then
        result=$($eval_command "${2}" "${1:2}" 2> generated/error.log)
    else
        result=$($eval_command "${2}" "${1:2}" 2>&1)
    fi
    status_code="$?"
    tests=$((tests+1))

    if [ "${3:0:1}" == "=" ]; then
        if [ "$status_code" != "0" ]; then
            echo "not ok $tests - program returned non-zero status code"
            echo "---"
            echo "  expression:  '${1:2}'"
            echo "  program:     '${2}'"
            echo "  status-code: '$status_code'"
            echo "  error:"
            echo "$(cat generated/error.log)"
            echo "..."
            failing=$((failing+1))

        elif [ "$result" == "${3:2}" ]; then
            echo "ok $tests - ${1:2} = $result"
            passing=$((passing+1))

        else
            echo "not ok $tests - expected '${3:2}' but got '$result'"
            echo "---"
            echo "  expression: '${1:2}'"
            echo "  program:    '${2}'"
            echo "  expected:   '${3:2}'"
            echo "  actual:     '$result'"
            echo "..."
            failing=$((failing+1))
        fi
    
    else
        if [ "$status_code" == "0" ]; then
            echo "not ok $tests - expected program to return a non-zero status code"
            echo "---"
            echo "  status-code:   '$status_code'"
            echo "..."
            failing=$((failing+1))

        elif [[ "$result" == *"${3:2}"* ]]; then
            echo "ok $tests - Error contains '${3:2}'"
            passing=$((passing+1))

        else
            echo "not ok $tests - expected '$result' to contain '${3:2}'"
            echo "---"
            echo "  expression: '${1:2}'"
            echo "  program:    '${2}'"
            echo "  expected:   '${3:2}'"
            echo "  actual:     '$result'"
            echo "..."
            failing=$((failing+1))
        fi
    fi
}

echo TAP version 13

program=""

for f in $spec/*.spec
do
    while IFS='' read line; do
        firstChar=${line:0:1}
        if [ "$firstChar" == ">" ]; then
            IFS='' read expected
            testLine "${line//'\n'/$'\n'}" "${program//'\n'/$'\n'}" "${expected//'\n'/$'\n'}"
            program=""
        elif [ "$firstChar" == "|" ]; then
            program="$program${line:2}"
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

if [ "$failing" != "0" ]; then
    exit 1
fi

#!/bin/bash

spec=$1
eval_command=$2

tests=0
passing=0
failing=0

mkdir -p generated
rm generated/build.log > /dev/null 2>&1

function testLine {
    local result
    if test "$4" = "="; then
        result="$("$eval_command" "$2" "$1" 2> generated/error.log; printf '%s' 'x')"
    else
        result="$("$eval_command" "$2" "$1" 2>&1; printf '%s' 'x')"
    fi
    result="${result%x}"

    local status_code="$?"
    tests=$((tests+1))

    if test "$4" = "="; then
        if test "$status_code" != "0"; then
            echo "not ok $tests - program returned non-zero status code"
            echo "---"
            echo "  expression:  '$1'"
            echo "  program:     '$2'"
            echo "  status-code: '$status_code'"
            echo "  error:"
            echo "$(cat generated/error.log)"
            echo "..."
            failing=$((failing+1))

        elif test "$result" = "$3"; then
            echo "ok $tests - $1 = $result"
            passing=$((passing+1))

        else
            echo "not ok $tests - expected '$3' but got '$result'"
            echo "---"
            echo "  expression: '$1'"
            echo "  program:    '$2'"
            echo "  expected:   '$3'"
            echo "  actual:     '$result'"
            echo "..."
            failing=$((failing+1))
        fi

    else
        if test "$status_code" = "0"; then
            echo "not ok $tests - expected program to return a non-zero status code"
            echo "---"
            echo "  status-code:   '$status_code'"
            echo "..."
            failing=$((failing+1))

        elif [[ "$result" == *"$3"* ]]; then
            echo "ok $tests - Error contains '$3'"
            passing=$((passing+1))

        else
            echo "not ok $tests - expected '$result' to contain '$3'"
            echo "---"
            echo "  expression: '$1'"
            echo "  program:    '$2'"
            echo "  expected:   '$3'"
            echo "  actual:     '$result'"
            echo "..."
            failing=$((failing+1))
        fi
    fi
}

function runSpec() {
    local file="$1"
    local program=""
    local expression=""
    local expected=""
    while IFS='' read line; do
        local firstChar=${line:0:1}
        if test "$firstChar" = "?" || test "$firstChar" = "="; then
            while test "${line:0:1}" = "$firstChar"; do
                if test -z "$expected"; then
                    expected="${line:2}"
                else
                    printf -v expected '%s\n%s' "$expected" "${line:2}"
                fi
                IFS='' read line
            done
            testLine "$expression" "$program" "$expected" "$firstChar"
            program=""
            expression=""
            expected=""
        elif test "$firstChar" = ">"; then
            if test -z "$expression"; then
                expression="${line:2}"
            else
                printf -v expression '%s\n%s' "$expression" "${line:2}"
            fi
        elif test "$firstChar" = "|"; then
            if test -z "$program"; then
                program="${line:2}"
            else
                printf -v program '%s\n%s' "$program" "${line:2}"
            fi
        else
            if test "$line" != ""; then
                echo \# $line
            fi
        fi
    done <$file
}

echo TAP version 13

if test -f "$spec"; then
    runSpec "$spec"
else
    for file in $spec/*.spec; do
        runSpec "$file"
    done
fi

echo 1..$tests

echo \# tests $tests
echo \# pass  $passing
echo \# fail  $failing

if test "$failing" != "0"; then
    exit 1
fi

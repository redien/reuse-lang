#!/usr/bin/env bash

title_format="  \033[4m"
ok_format="    \033[32m✔\033[90m "
not_ok_format="    \033[91m✖ "
result_failed_format="\033[91m  "
result_passed_format="\033[92m  "
error_data_format="        \033[93m"
reset_format="\033[0m"
failed_tests=0

echo_error_data() {
    echo -e "${error_data_format}---$reset_format"
    while IFS= read -r line; do
        if [[ "$line" == *"..." ]]; then
            break
        else
            echo -e "${error_data_format}$line$reset_format"
        fi
    done
    echo -e "${error_data_format}...$reset_format"
}

while IFS= read -r line; do
    if [[ "$line" == "# fail 0" ]]; then
        echo -e "${result_passed_format}All tests passed\n\n$reset_format"
    elif [[ "$line" == "# fail "* ]]; then
        echo -e "$result_failed_format${line:7} tests failed\n\n$reset_format"
    elif [[ "$line" == "# pass "* ]]; then
        echo -e "$result_passed_format${line:7} tests passed$reset_format"
    elif [[ "$line" == "# tests "* ]]; then
        echo -e "\n\n  ${line:8} tests in total$reset_format"
    elif [[ "$line" == "# "* ]]; then
        echo -e "\n$title_format${line:2}\n$reset_format"
    elif [[ "$line" == "ok "* ]]; then
        echo -e "$ok_format${line:2}$reset_format"
    elif [[ "$line" == "not ok "* ]]; then
        echo -e "$not_ok_format${line:6}$reset_format"
        failed_tests=1
    elif [[ "$line" == *"---" ]]; then
        echo_error_data
    fi
done

if [[ $failed_tests == 1 ]]; then
    exit 1
fi

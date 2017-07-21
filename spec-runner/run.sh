#!/bin/bash

script_path=$(dirname "$0")

docker build $script_path -t bavpj9kxxekvg
docker run --rm -i -v $PWD/$script_path/../:/home/build/ -w /home/build/ --entrypoint /bin/bash bavpj9kxxekvg ./spec-runner/spec-runner.sh "$1" "$2"

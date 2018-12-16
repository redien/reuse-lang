#!/usr/bin/env bash
set -e

project_root=$(dirname "$0")/..

$project_root/standard-library/build.sh

>$project_root/generated/parser.reuse echo "
$(cat $project_root/sexp-parser/parser.reuse)
$(cat $project_root/parser/strings.reuse)
$(cat $project_root/parser/parser.reuse)
(export main (stdin)
        (stringify (definitions-to-sexps (sexps-to-definitions (parse stdin)))))
"

[ -d $project_root/generated/parser ] || mkdir $project_root/generated/parser

$project_root/frontend.sh --executable --stdin --output $project_root/generated/parser/executable $project_root/generated/parser.reuse

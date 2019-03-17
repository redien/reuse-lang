#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..

[ -d $project_root/generated/string-gen ] || mkdir $project_root/generated/string-gen

$project_root/standard-library/build.sh

$project_root/reusec --language ocaml\
                     --output $project_root/generated/string-gen/StringGen.ml\
                     $script_path/string-gen.reuse

cat << END_OF_SOURCE >> $project_root/generated/string-gen/StringGen.ml

let getenv name = try (Sys.getenv name) with Not_found -> ""
let performance = getenv "REUSE_TIME" = "true";;

$(cat $project_root/extended/ocaml-compiler/stdin_wrapper.ml)

let string_gen_start = Unix.gettimeofday ();;
let string_gen_output = string_gen stdin_list;;
let string_gen_end = Unix.gettimeofday ();;
let string_gen_time = string_gen_end -. string_gen_start;;

if performance then
    (Printf.printf "%f" string_gen_time ; exit 0)
else
    match string_gen_output with
          CResult (result) -> Printf.printf "%s" (list_to_string result) ; exit 0
        | CError (error) -> Printf.eprintf "%s" (list_to_string error) ; exit 1;;

END_OF_SOURCE

ocamlopt -O3 unix.cmxa $project_root/generated/string-gen/StringGen.ml -o $project_root/generated/string-gen/string-gen

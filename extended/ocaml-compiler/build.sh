#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

$project_root/standard-library/build.sh

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

$project_root/reusec --language ocaml\
                     --output $project_root/generated/extended/CompilerOCaml.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/ocaml.strings\
                     $script_path/ocaml.reuse

cat << END_OF_SOURCE >> $project_root/generated/extended/CompilerOCaml.ml

let stdin_wrapper_start = Unix.gettimeofday ();;
$(cat $script_path/stdin_wrapper.ml)
let stdin_wrapper_end = Unix.gettimeofday ();;
let stdin_wrapper_time = stdin_wrapper_end -. stdin_wrapper_start;;

let parse' str = stringify_45parse_45errors (sexps_45to_45definitions (parse str));;
let getenv name = try (Sys.getenv name) with Not_found -> ""
let as_minimal = if getenv "REUSE_MINIMAL" = "true" then CTrue else CFalse;;
let performance = getenv "REUSE_TIME" = "true";;

let parse_start = Unix.gettimeofday ();;
let parse_output = (parse' _stdin_list);;
let parse_end = Unix.gettimeofday ();;
let parse_time = parse_end -. parse_start;;
let compile_start = Unix.gettimeofday ();;
let compile_output = (to_ocaml parse_output _stdin_list as_minimal);;
let compile_end = Unix.gettimeofday ();;
let compile_time = compile_end -. compile_start;;

if performance then
    (Printf.printf "%f %f %f" stdin_wrapper_time parse_time compile_time ; exit 0)
else
    match compile_output with
        CResult (source) -> Printf.printf "%s" (_list_to_string source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (_list_to_string error) ; exit 1;;

END_OF_SOURCE

ocamlc unix.cma -g $project_root/generated/extended/CompilerOCaml.ml -o $project_root/generated/extended/compiler-ocaml

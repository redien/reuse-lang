#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/..

build_dir=$($project_root/dev-env/builddir.sh string-gen)

$project_root/reusec --language ocaml\
                     --output $build_dir/StringGen.ml\
                     $script_path/string-gen.reuse

cat << END_OF_SOURCE >> $build_dir/StringGen.ml

let getenv name = try (Sys.getenv name) with Not_found -> ""
let performance = getenv "REUSE_TIME" = "true";;

open StdinWrapper;;

let string_gen_start = Unix.gettimeofday ();;
let string_gen_output = string_gen (read_stdin ());;
let string_gen_end = Unix.gettimeofday ();;
let string_gen_time = string_gen_end -. string_gen_start;;

if performance then
    (Printf.printf "%f" string_gen_time ; exit 0)
else
    match string_gen_output with
          Result (result) -> Printf.printf "%s" (reuse_string_to_ml result) ; exit 0
        | Error (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1;;

END_OF_SOURCE

cp $project_root/compiler-backend/ocaml/StdinWrapper.ml $build_dir

ocamlopt -O3 unix.cmxa \
         -I "$build_dir" \
         "$build_dir/StdinWrapper.ml" \
         "$build_dir/StringGen.ml" \
         -o "$build_dir/string-gen"

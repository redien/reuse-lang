#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..
build_path=$project_root/generated/extended/minimal-compiler

[ -d $project_root/generated ] || mkdir $project_root/generated
[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended
[ -d $project_root/generated/extended/minimal-compiler ] || mkdir $project_root/generated/extended/minimal-compiler

$project_root/reusec --language ocaml\
                     --output $build_path/CompilerMinimal.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/minimal.reuse

cat << END_OF_SOURCE >> $build_path/CompilerMinimal.ml

open Pervasives;;
open StdinWrapper;;

let stdin_list = read_stdin ();;

let parse' str = stringify_45parse_45errors (sexps_45to_45definitions (parse str));;

let output = to_45reuse (parse' stdin_list) stdin_list in
    match output with
        CResult (source) -> Printf.printf "%s" (reuse_string_to_ml source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1;;

END_OF_SOURCE

cp $project_root/standard-library/Reuse.ml $build_path/Reuse.ml
cp $project_root/extended/ocaml-compiler/Pervasives.ml $build_path/Pervasives.ml
cp $project_root/extended/ocaml-compiler/StdinWrapper.ml $build_path/StdinWrapper.ml

ocamlopt -O3 \
         -I "$build_path" \
         "$build_path/Reuse.ml" \
         "$build_path/Pervasives.ml" \
         "$build_path/StdinWrapper.ml" \
         "$build_path/CompilerMinimal.ml" \
         -o "$build_path/compiler-minimal"

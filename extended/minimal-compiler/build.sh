#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

$script_path/../ocaml-compiler/build.sh
$project_root/standard-library/build.sh

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

$project_root/reusec --language ocaml\
                     --output $project_root/generated/extended/CompilerMinimal.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/minimal.reuse

cat << END_OF_SOURCE >> $project_root/generated/extended/CompilerMinimal.ml

open Pervasives;;
open StdinWrapper;;

let stdin_list = read_stdin ();;

let parse' str = stringify_45parse_45errors (sexps_45to_45definitions (parse str));;

let output = to_45reuse (parse' stdin_list) stdin_list in
    match output with
        CResult (source) -> Printf.printf "%s" (reuse_string_to_ml source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1;;

END_OF_SOURCE

ocamlopt -O3 \
         -I "$project_root/extended/ocaml-compiler" \
         -I "$project_root/generated/extended" \
         -I "$project_root/generated" \
         "$project_root/generated/Reuse.ml" \
         "$project_root/extended/ocaml-compiler/Pervasives.ml" \
         "$project_root/extended/ocaml-compiler/StdinWrapper.ml" \
         "$project_root/generated/extended/CompilerMinimal.ml" \
         -o "$project_root/generated/extended/compiler-minimal"

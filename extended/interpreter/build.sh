#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
    DIAGNOSTICS="true"
fi

$project_root/standard-library/build.sh $extra_flags

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $project_root/generated/extended/Interpreter.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../../cli/argument-parser.strings\
                     $script_path/../../cli/argument-parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/scope.reuse\
                     $script_path/interpreter.strings\
                     $script_path/interpreter.reuse

cat << END_OF_SOURCE >> $project_root/generated/extended/Interpreter.ml

$(cat $script_path/../ocaml-compiler/pervasives.ml)
$(cat $script_path/../ocaml-compiler/stdin_wrapper.ml)

let argv = ml_list_to_reuse (List.map ml_string_to_reuse (List.tl (Array.to_list Sys.argv)));;
let read_file filename =
    let channel = open_in (reuse_string_to_ml filename) in
    let file = really_input_string channel (in_channel_length channel) in
    close_in channel;
    ml_string_to_reuse_iterator file;;

let load_files file_paths = list_45zip file_paths (list_45map read_file file_paths);;

let current = ref (CEventArguments argv);;

while true do
    match (on_45event !current) with
          CCommandError (error) -> Printf.eprintf "%s" (list_to_string error) ; exit 1
        | CCommandOutput (output) -> Printf.printf "%s" (list_to_string output) ; exit 0
        | CCommandReadStdin (state) -> current := CEventReadStdin (read_stdin (), state)
        | CCommandReadFiles (file_paths, state) -> current := CEventReadFiles ((load_files file_paths), state)
done
END_OF_SOURCE

ocamlopt -O3 unix.cmxa $project_root/generated/extended/Interpreter.ml -o $project_root/generated/extended/interpreter

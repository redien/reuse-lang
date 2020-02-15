
open Reuse;;
open Pervasives;;
open StdinWrapper;;
open ReuseCompiler;;

let argv = ml_list_to_reuse (List.map ml_string_to_reuse (List.tl (Array.to_list Sys.argv)));;

let read_file filename =
    let channel = open_in (reuse_string_to_ml filename) in
    let file = really_input_string channel (in_channel_length channel) in
    close_in channel;
    ml_string_to_indexed_iterator file;;
let read_files file_paths = list_45zip file_paths (list_45map read_file file_paths);;

let write_file filename content =
    let channel = open_out (reuse_string_to_ml filename) in
    output_string channel (reuse_string_to_ml content);
    close_out channel;;
let write_files files = ignore (list_45map (fun p -> match p with CPair (path, content) -> write_file path content) files);;

let current = ref (CEventArguments argv);;

while true do
    match (on_45event !current) with
          CCommandError (error) -> Printf.eprintf "%s\n" (reuse_string_to_ml error) ; exit 1
        | CCommandOutput (output) -> Printf.printf "%s" (reuse_string_to_ml output) ; exit 0
        | CCommandWriteFiles (files) -> write_files files ; exit 0
        | CCommandReadFiles (file_paths, state) -> current := CEventReadFiles ((read_files file_paths), state)
done

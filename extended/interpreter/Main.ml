
open Reuse;;
open Pervasives;;
open StdinWrapper;;
open Interpreter;;

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
          CCommandError (error) -> Printf.eprintf "%s\n" (reuse_string_to_ml error) ; exit 1
        | CCommandOutput (output) -> Printf.printf "%s" (reuse_string_to_ml output) ; exit 0
        | CCommandReadStdin (state) -> current := CEventReadStdin (read_stdin (), state)
        | CCommandReadFiles (file_paths, state) -> current := CEventReadFiles ((load_files file_paths), state)
done

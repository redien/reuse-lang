
open Interpreter;;

let read_line ic =
    try Some (input_line ic)
    with End_of_file -> None

let read_lines ic =
    let rec loop acc =
        match read_line ic with
        | Some line -> loop (line :: acc)
        | None -> List.rev acc
    in
        loop [];;

let read_stdin _ = String.concat "\n" (read_lines stdin);;

let argv = ml_list_to_reuse (List.map ml_string_to_reuse (List.tl (Array.to_list Sys.argv)));;

let ml_string_list_to_reuse list = ml_list_to_reuse (List.map ml_string_to_reuse list);;

let data_path = (Filename.dirname Sys.executable_name) ^ Filename.dir_sep ^ "data" ^ Filename.dir_sep;;

let stdlib_paths = List.map (fun name -> data_path ^ name) [
    "combinators.reuse";
    "boolean.reuse";
    "pair.reuse";
    "maybe.reuse";
    "iterable.reuse";
    "indexed-iterator.reuse";
    "list.reuse";
    "string.reuse";
    "result.reuse";
    "state.reuse";
    "dictionary.reuse";
    "array.reuse";
] |> ml_string_list_to_reuse;;
let stdlib_module = CModulePath (ml_string_to_reuse "stdlib");;

let read_file filename =
    let channel = open_in (reuse_string_to_ml filename) in
    let file = really_input_string channel (in_channel_length channel) in
    close_in channel;
    ml_string_to_indexed_iterator file;;
let read_files m file_paths = list_45map (fun path -> CSourceFile (m, path, (read_file path))) file_paths;;
let read_modules modules = if (list_45size modules) > 0l then read_files stdlib_module stdlib_paths else CEmpty;;

let current = ref (CEventArguments argv);;

while true do
    match (on_45event !current) with
          CCommandError (error) -> Printf.eprintf "%s\n" (reuse_string_to_ml error) ; exit 1
        | CCommandOutput (output) -> Printf.printf "%s" (reuse_string_to_ml output) ; exit 0
        | CCommandReadStdin (state) -> current := CEventReadStdin (ml_string_to_indexed_iterator (read_stdin ()), state)
        | CCommandReadFiles (file_paths, modules, state) -> current := CEventReadFiles (list_45concat (read_modules modules) (read_files CModuleSelf file_paths), state)
done

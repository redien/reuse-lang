
open Interpreter;;

let read_line ic =
    try Some (input_line ic)
    with End_of_file -> None

let read_lines ic =
    let buffer = Buffer.create 1024 in
    let rec loop () =
        match read_line ic with
        | Some line ->
            if Buffer.length buffer > 0 then Buffer.add_char buffer '\n' ;
            Buffer.add_string buffer line ;
            loop ()
        | None -> buffer
    in
        loop ();;

let read_stdin _ = Buffer.to_bytes (read_lines stdin);;

let argv = ml_list_to_reuse (List.map ml_string_to_reuse (List.tl (Array.to_list Sys.argv)));;

let ml_string_list_to_reuse list = ml_list_to_reuse (List.map ml_string_to_reuse list);;

let data_path = (Filename.dirname Sys.executable_name) ^ Filename.dir_sep ^ "data" ^ Filename.dir_sep;;

let stdlib_paths = List.map (fun name -> data_path ^ name) [
    "standard-library.reuse";
] |> ml_string_list_to_reuse;;
let stdlib_module = ModulePath (ml_string_to_reuse "standard-library", True);;

let read_file m path =
    let channel = open_in (reuse_string_to_ml path) in
    let length = in_channel_length channel in
    let buffer = Bytes.create length in
    really_input channel buffer 0 length ;
    close_in channel;
    SourceFile (m, path, buffer);;
let read_files m files = list_map (read_file m) files;;
let read_modules modules = if (list_size2 modules) > 0l then read_files stdlib_module stdlib_paths else Empty;;

let current = ref (EventArguments argv);;

while true do
    match (on_event !current) with
          CommandError (error) -> Printf.eprintf "%s\n" (reuse_string_to_ml error) ; exit 1
        | CommandOutput (output) -> Printf.printf "%s" (reuse_string_to_ml output) ; exit 0
        | CommandReadStdin (state) -> current := EventReadStdin (read_stdin (), state)
        | CommandReadFiles (file_paths, modules, state) -> current := EventReadFiles (list_concat (read_modules modules) (read_files ModuleSelf file_paths), state)
done

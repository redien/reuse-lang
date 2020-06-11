
open ReuseCompiler;;

let data_path = (Filename.dirname Sys.executable_name) ^ Filename.dir_sep ^ "data" ^ Filename.dir_sep;;

let argv = ml_list_to_reuse (List.map ml_string_to_reuse (List.tl (Array.to_list Sys.argv)));;

let read_file m path =
    let channel = open_in (reuse_string_to_ml path) in
    let file = really_input_string channel (in_channel_length channel) in
    close_in channel;
    CSourceFile (m, path, ml_string_to_indexed_iterator file);;
let read_files m file_paths = list_45map (read_file m) file_paths;;
let read_modules modules = let read_module m = (match m with CPair (module_name, path) -> read_file (CModulePath (module_name)) path)
                            in list_45map read_module modules;;
let with_preamble files = list_45cons (read_file CModuleSelf (ml_string_to_reuse (data_path ^ reuse_string_to_ml (data_45preamble_45filename ())))) files;;

let write_file path content =
    let channel = open_out (reuse_string_to_ml path) in
    output_string channel (reuse_string_to_ml content);
    close_out channel;;
let write_files files = ignore (list_45map (fun p -> match p with CPair (path, content) -> write_file path content) files);;

let current = ref (CEventArguments argv);;

while true do
    match (on_45event (ml_string_to_reuse data_path) !current) with
          CCommandError (error) -> Printf.eprintf "%s\n" (reuse_string_to_ml error) ; exit 1
        | CCommandOutput (output) -> Printf.printf "%s" (reuse_string_to_ml output) ; exit 0
        | CCommandWriteFiles (files) -> write_files files ; exit 0
        | CCommandReadFiles (file_paths, modules, state) -> current := CEventReadFiles (with_preamble (list_45concat (read_modules modules) (read_files CModuleSelf file_paths)), state)
done


open Reuse;;
open Pervasives;;
open ReuseCompiler;;

let ml_string_list_to_reuse list = ml_list_to_reuse (List.map ml_string_to_reuse list);;

let stdlib_paths = List.map (fun name ->
    (Filename.dirname Sys.executable_name) ^
    Filename.dir_sep ^
    ".." ^
    Filename.dir_sep ^
    "standard-library" ^
    Filename.dir_sep ^
    name)
[
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
] |> ml_string_list_to_reuse;;
let stdlib_module = CModulePath (ml_string_to_reuse "stdlib");;

let argv = ml_string_list_to_reuse (List.tl (Array.to_list Sys.argv));;

let read_file filename =
    let channel = open_in (reuse_string_to_ml filename) in
    let file = really_input_string channel (in_channel_length channel) in
    close_in channel;
    ml_string_to_indexed_iterator file;;
let read_files m file_paths = list_45map (fun path -> CSourceFile (m, path, (read_file path))) file_paths;;
let read_modules modules = if (list_45size modules) > 0l then read_files stdlib_module stdlib_paths else CEmpty;;

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
        | CCommandReadFiles (file_paths, modules, state) -> current := CEventReadFiles (list_45concat (read_modules modules) (read_files CModuleSelf file_paths), state)
done

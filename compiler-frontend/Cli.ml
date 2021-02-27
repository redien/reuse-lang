
open ReuseCompiler;;

let data_path = ml_string_to_reuse ((Filename.dirname Sys.executable_name) ^ Filename.dir_sep ^ "data" ^ Filename.dir_sep);;

let argv = ml_list_to_reuse (List.map ml_string_to_reuse (List.tl (Array.to_list Sys.argv)));;
let read_file m path =
    let channel = open_in (reuse_string_to_ml path) in
    let length = in_channel_length channel in
    let buffer = Bytes.create length in
    really_input channel buffer 0 length ;
    close_in channel;
    CSourceFile (m, path, buffer);;
let read_files files = list_45map (pair_45map read_file) files;;

let write_file path content =
    let channel = open_out (reuse_string_to_ml path) in
    output_string channel (reuse_string_to_ml content);
    close_out channel;;
let write_files files = ignore (list_45map (fun p -> match p with CPair (path, content) -> write_file path content) files);;

let current = ref (cli_45main data_path argv);;

while true do
    match !current with
          CCliError (error, k) -> Printf.eprintf "%s\n" (reuse_string_to_ml error) ; current := k ()
        | CCliOutput (output, k) -> Printf.printf "%s" (reuse_string_to_ml output) ; current := k ()
        | CCliTime (k) -> current := k (Int32.of_float ((Sys.time ()) *. 1000000.0))
        | CCliRenderSource (source_string, k) -> current := k (source_45string_45to_45string source_string)
        | CCliMaxHeapSize (k) -> current := k (Int32.of_int ((Gc.stat ()).top_heap_words * (Sys.word_size / 8)))
        | CCliWriteFiles (files, k) -> write_files files ; current := k ()
        | CCliReadFiles (files, k) -> current := k (read_files files)
        | CCliExit (status) -> exit (Int32.to_int status)
done

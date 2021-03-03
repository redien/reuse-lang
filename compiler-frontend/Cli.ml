
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
let read_files files = list_map (pair_map read_file) files;;

let write_file path content =
    let channel = open_out (reuse_string_to_ml path) in
    output_bytes channel content;
    close_out channel;;
let write_files files = ignore (list_map (fun p -> match p with CPair (path, content) -> write_file path content) files);;

let add_char i buffer =
    let c = Char.chr i in
    if (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') then
        (Buffer.add_char buffer c; buffer)
    else if (c == '-') then
        (Buffer.add_char buffer '_'; buffer)
    else
        buffer;;

let add_char_identity c buffer =
    let i = Int32.to_int c in
    add_char i buffer;;

let add_char_lowercase c buffer =
    let i = Int32.to_int c in
    if i >= 65 && i <= 90 then
        (Buffer.add_char buffer (Char.chr (i + 32)); buffer)
    else
        add_char i buffer;;

let identifiers = Hashtbl.create 1000;;
let rendered_identifiers = Hashtbl.create 1000;;
let initialize_source_renderer () =
    Hashtbl.clear identifiers;
    Hashtbl.clear rendered_identifiers;
    ignore (list_map (fun identifier -> Hashtbl.add rendered_identifiers (reuse_string_to_ml (identifier ())) true; identifier) (reserved_identifiers ()));;

let substring_from buffer offset =
    let length = (Buffer.length buffer) - offset in
    Buffer.sub buffer offset length;;

let add_suffix buffer start identifier =
    if (Buffer.length buffer) - start == 0 then
        Buffer.add_char buffer 'x';
    let baseLength = Buffer.length buffer in
    let counter = ref 2 in
    while Hashtbl.mem rendered_identifiers (substring_from buffer start) do
        Buffer.truncate buffer baseLength;
        Buffer.add_string buffer (string_of_int !counter);
        counter := !counter + 1
    done;;

let remove_integers buffer start =
    if (Buffer.length buffer) - start > 0 then
        let c = Buffer.nth buffer start in
        if c >= '0' && c <= '9' then
            Buffer.truncate buffer start;;

let encode_identifier buffer identifier transformation =
    match identifier_id identifier with
        | CSome (id) ->
            (match Hashtbl.find_opt identifiers id with
                 | Some (encoded) ->
                    Buffer.add_string buffer encoded;
                    buffer
                 | None ->
                     let name = identifier_name identifier in
                     let previousLength = Buffer.length buffer in
                     let buffer = match transformation with
                        | CIdentifierTransformationNone -> string_foldl add_char_identity buffer name
                        | CIdentifierTransformationLowercase -> string_foldl add_char_lowercase buffer name
                        | CIdentifierTransformationCapitalize -> (match string_first name with
                                | CSome (c) -> Buffer.add_char buffer (Char.uppercase_ascii (Char.chr (Int32.to_int c))); string_foldl add_char_identity buffer (string_rest name)
                                | CNone     -> buffer) in
                     remove_integers buffer previousLength;
                     add_suffix buffer previousLength identifier;
                     let substring = substring_from buffer previousLength in
                     Hashtbl.add identifiers id substring;
                     Hashtbl.add rendered_identifiers substring true;
                     buffer)
        | CNone ->
            buffer;;

let rec source_string_to_buffer buffer source_string =
    match source_string with
        | CSourceStringEmpty                          -> buffer
        | CSourceStringChar (c)                       -> Buffer.add_char buffer (Char.chr (Int32.to_int c)); buffer
        | CSourceString (s)                           -> Buffer.add_string buffer (reuse_string_to_ml s); buffer
        | CSourceStringIdentifier (i, transformation) -> encode_identifier buffer i transformation
        | CSourceStringConcat (a, b)                  -> ignore (source_string_to_buffer buffer a); ignore (source_string_to_buffer buffer b); buffer;;

let current = ref (cli_main data_path argv);;

while true do
    match !current with
          CCliError (error, k) -> Printf.eprintf "%s\n" (reuse_string_to_ml error) ; current := k ()
        | CCliOutput (output, k) -> Printf.printf "%s" (reuse_string_to_ml output) ; current := k ()
        | CCliTime (k) -> current := k (Int32.of_float ((Sys.time ()) *. 1000000.0))
        | CCliRenderSource (source_string, k) ->
            initialize_source_renderer ();
            current := k (Buffer.to_bytes (source_string_to_buffer (Buffer.create 32768) source_string))
        | CCliMaxHeapSize (k) -> current := k (Int32.of_int ((Gc.stat ()).top_heap_words * (Sys.word_size / 8)))
        | CCliWriteFiles (files, k) -> write_files files ; current := k ()
        | CCliReadFiles (files, k) -> current := k (read_files files)
        | CCliExit (status) -> exit (Int32.to_int status)
done

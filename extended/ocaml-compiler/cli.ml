
let stdin_wrapper_start = Unix.gettimeofday ();;

let argv = ml_list_to_reuse (List.map ml_string_to_reuse (List.tl (Array.to_list Sys.argv)));;

let filenames = ref CEmpty;;
let key_value_arguments = ref CEmpty;;

let key_has_value key value =
    match list_45find_45first (fun pair -> (string_45equal_63 (pair_45left pair) (ml_string_to_reuse key))) !key_value_arguments with
        | CSome (pair) -> string_45equal_63 (pair_45right pair) (ml_string_to_reuse value)
        | CNone -> CFalse;;

let cli_arguments = parse_45arguments argv;;
match cli_arguments with
    | CCliArguments (kv_args, input) -> key_value_arguments := kv_args; filenames := input
    | CCliErrorMissingValue (key) -> Printf.eprintf "CLI Error: Key '%s' is missing a value\n" (reuse_string_to_ml key) ; exit 1;;

let read_file filename =
    let channel = open_in (reuse_string_to_ml filename) in
    let file = really_input_string channel (in_channel_length channel) in
    close_in channel;
    file;;

let files = list_45map read_file !filenames;;
let file_entries = list_45zip !filenames files;;

let source = Buffer.contents (list_45foldr (fun a b -> Buffer.add_string b a; b) (Buffer.create 1_000_000) files);;

let ml_string_get succ fail s index =
    let i = (Int32.to_int index) in
    if i < (String.length s) && i >= 0 then
            succ (Int32.of_int (Char.code (String.get s i)))
    else
            fail ();;

let stdin_list = (indexed_45iterator_45from source (ml_string_get (fun x -> CSome (x)) (fun _ -> CNone)));;




let as_minimal = key_has_value  "--minimal"      "true";;
let performance = key_has_value "--diagnostics"  "true";;

let stdin_wrapper_end = Unix.gettimeofday ();;
let stdin_wrapper_time = stdin_wrapper_end -. stdin_wrapper_start;;

let parse_sexp_start = Unix.gettimeofday ();;
let parse_sexp_output = (parse stdin_list);;
let parse_sexp_end = Unix.gettimeofday ();;
let parse_sexp_time = parse_sexp_end -. parse_sexp_start;;

let parse_start = Unix.gettimeofday ();;
let definitions = stringify_45parse_45errors (sexps_45to_45definitions parse_sexp_output);;
let parse_end = Unix.gettimeofday ();;
let parse_time = parse_end -. parse_start;;

let codegen_start = Unix.gettimeofday ();;
let exported_identifiers = collect_45exported_45identifiers definitions;;
let codegen_output = (to_45ocaml definitions stdin_list as_minimal);;
let codegen_end = Unix.gettimeofday ();;
let codegen_time = codegen_end -. codegen_start;;

let total_time = stdin_wrapper_time +. parse_sexp_time +. parse_time +. codegen_time;;

let print_diagnostics output =
    Printf.printf "Reading:         %fs\n" stdin_wrapper_time;
    Printf.printf "Parsing (sexps): %fs\n" parse_sexp_time;
    Printf.printf "Parsing:         %fs\n" parse_time;
    Printf.printf "Code Gen:        %fs\n" codegen_time;
    Printf.printf "Total:           %fs\n" total_time;
    Printf.printf "\n";
(*    Printf.printf "Lines:           %d\n" line_count;
    Printf.printf "Throughput:      %f lines/s\n" (total_time /. line_count);*)
    Printf.printf "Input size:      %d bytes\n" (String.length source);
    Printf.printf "Output size:     %ld bytes\n" (string_45size output);;

if reuse_boolean_to_ml performance then
    match codegen_output with
      | CResult (output) -> print_diagnostics output ; exit 0
      | CError (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1
else
    match codegen_output with
      | CResult (output) -> Printf.printf "%s" (reuse_string_to_ml output) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1;;

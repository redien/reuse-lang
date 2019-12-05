
open Reuse;;
open ReuseHaskell;;
open Pervasives;;
open StdinWrapper;;

let getenv name = try (Sys.getenv name) with Not_found -> ""
let as_minimal = if getenv "REUSE_MINIMAL" = "true" then CTrue else CFalse;;
let with_stdlib = if getenv "REUSE_NOSTDLIB" = "false" then CTrue else CFalse;;
let output_filename = Seq.fold_left (fun s c -> string_45append (Int32.of_int (Char.code c)) s) (string_45empty ()) (String.to_seq (getenv "REUSE_OUTPUT_FILENAME"));;
let performance = getenv "REUSE_TIME" = "true";;

let stdin_wrapper_start = Unix.gettimeofday ();;
let stdin_list = read_stdin ();;
let stdin_wrapper_end = Unix.gettimeofday ();;
let stdin_wrapper_time = stdin_wrapper_end -. stdin_wrapper_start;;

let parse_sexp_start = Unix.gettimeofday ();;
let parse_sexp_output = (parse stdin_list);;
let parse_sexp_end = Unix.gettimeofday ();;
let parse_sexp_time = parse_sexp_end -. parse_sexp_start;;

let parse_start = Unix.gettimeofday ();;
let parse_output = stringify_45parse_45errors (sexps_45to_45definitions parse_sexp_output);;
let parse_end = Unix.gettimeofday ();;
let parse_time = parse_end -. parse_start;;

let codegen_start = Unix.gettimeofday ();;
let codegen_output = (to_45haskell output_filename with_stdlib parse_output stdin_list as_minimal);;
let codegen_end = Unix.gettimeofday ();;
let codegen_time = codegen_end -. codegen_start;;

if performance then
    match codegen_output with
        CResult (source) -> Printf.printf "%f %f %f %f %ld" stdin_wrapper_time parse_sexp_time parse_time codegen_time (string_45size source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1
else
    match codegen_output with
        CResult (source) -> Printf.printf "%s" (reuse_string_to_ml source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1;;

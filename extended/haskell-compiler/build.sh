#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
    DIAGNOSTICS="true"
fi

$project_root/standard-library/build.sh $extra_flags

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language ocaml\
                     --output $project_root/generated/extended/CompilerHaskell.ml\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/haskell.strings\
                     $script_path/haskell.reuse

cat << END_OF_SOURCE >> $project_root/generated/extended/CompilerHaskell.ml

$(cat $project_root/extended/ocaml-compiler/pervasives.ml)
$(cat $project_root/extended/ocaml-compiler/stdin_wrapper.ml)

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
      | CError (error) -> Printf.eprintf "%s" (list_to_string error) ; exit 1
else
    match codegen_output with
        CResult (source) -> Printf.printf "%s" (list_to_string source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (list_to_string error) ; exit 1;;

END_OF_SOURCE

compile_binary() {
    ocamlopt -O3 unix.cmxa $project_root/generated/extended/CompilerHaskell.ml -o $project_root/generated/extended/compiler-haskell
}

if [ "$1" != "--no-binary" ]; then
    if [ "$1" == "--diagnostics" ]; then
        2>&1 echo "[build.sh] ocamlopt"
        echo "Haskell:          " $(echo "time -p ocamlopt -O3 unix.cmxa $project_root/generated/extended/CompilerHaskell.ml -o $project_root/generated/extended/compiler-haskell" | bash 2>&1 | grep "real" | awk '{ print $2; }')s
    else
        compile_binary
    fi
fi

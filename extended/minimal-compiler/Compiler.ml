
open ReuseMinimal;;
open StdinWrapper;;

let stdin_list = read_stdin ();;

let parse' str = stringify_45parse_45errors (parser_45context_45definitions (sexps_45to_45definitions (parse (ml_string_to_indexed_iterator str)) (parser_45context_45new ())));;

let output = to_45reuse (parse' stdin_list) stdin_list in
    match output with
        CResult (source) -> Printf.printf "%s" (reuse_string_to_ml source) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (reuse_string_to_ml error) ; exit 1;;


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

let list_to_string = reuse_string_to_ml;;

let read_stdin _ = ml_string_to_reuse_iterator (String.concat "\n" (read_lines stdin));;

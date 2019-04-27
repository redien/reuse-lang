
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

let stdin_string _ =
    String.concat "\n" (read_lines stdin);;

let string_cons x xs =
    let string_from_int = (String.make 1 (Char.chr (Int32.to_int x))) in
    xs ^ string_from_int;;

let stdin_get succ fail s index =
    let i = (Int32.to_int index) in
    if i < (String.length s) && i >= 0 then
            succ (Int32.of_int (Char.code (String.get s i)))
    else
            fail ();;

let list_to_string = fun input -> (string_45foldl string_cons "" input);;
let stdin_list = (indexed_45iterator_45from (stdin_string ()) (stdin_get (fun x -> CSome (x)) (fun _ -> CNone)));;

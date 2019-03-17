
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

let rec list_to_string_r = fun input result ->
    match input with
          CCons(x, rest) ->
            let string_from_int = (String.make 1 (Char.chr (Int32.to_int x))) in
            let new_result = (String.concat "" (result :: string_from_int :: [])) in
                (list_to_string_r rest new_result)
        | CEmpty -> result;;

let list_to_string = fun input -> (list_to_string_r (string_45to_45list input) "");;

let stdin_get s index =
    let i = (Int32.to_int index) in
    if i < (String.length s) && i >= 0 then
            CSome (Int32.of_int (Char.code (String.get s i)))
    else
            CNone;;

let stdin_list = CIndexedIterator (
        stdin_string (), 0l, stdin_get,
        (fun iter _ __ ->
                match iter with
                | CIndexedIterator (s, i, get, next) -> CIndexedIterator (s, Int32.succ i, get, next)));;

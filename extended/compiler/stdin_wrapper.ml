
let _read_line ic =
    try Some (input_line ic)
    with End_of_file -> None

let _read_lines ic =
    let rec loop acc =
        match _read_line ic with
        | Some line -> loop (line :: acc)
        | None -> List.rev acc
    in
        loop [];;

let _stdin_string = String.concat "\n" (_read_lines stdin);;

let rec _string_to_list_i = fun input i result ->
    if i > 0 then
        let sub_input = (String.sub input 0 ((String.length input) - 1)) in
            _string_to_list_i sub_input (i - 1) (CCons ((Int32.of_int (Char.code (String.get input i))), result))
    else
        CCons ((Int32.of_int (Char.code (String.get input i))), result);;

let _string_to_list = fun input ->
    if String.length input == 0
    then CEmpty
    else _string_to_list_i input ((String.length input) - 1) CEmpty;;

let rec _list_to_string_r = fun input result ->
    match input with
          CCons(x, rest) ->
            let string_from_int = (String.make 1 (Char.chr (Int32.to_int x))) in
            let new_result = (String.concat "" (result :: string_from_int :: [])) in
                (_list_to_string_r rest new_result)
        | CEmpty -> result;;

let _list_to_string = fun input -> (_list_to_string_r input "");;

let _stdin_list = _string_to_list _stdin_string;;

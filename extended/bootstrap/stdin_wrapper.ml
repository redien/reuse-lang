
open Stdio;;

let _stdin_str = In_channel.input_all stdin;;

let rec _string_to_list_i = fun input i result ->
    if i > 0 then
        let sub_input = (String.sub input 0 ((String.length input) - 1)) in
            _string_to_list_i sub_input (i - 1) (Char.code (String.get input i) :: result)
    else
        (Char.code (String.get input i)) :: result;;

let _string_to_list = fun input -> _string_to_list_i input ((String.length input) - 1) [];;

let rec _list_to_string_r = fun input result ->
    match input with
          x :: rest ->
            let string_from_int = (String.make 1 (Char.chr x)) in
            let new_result = (String.concat "" (result :: string_from_int :: [])) in
                (_list_to_string_r rest new_result)
        | [] -> result;;

let _list_to_string = fun input -> (_list_to_string_r input "");;

let _stdin_list = _string_to_list _stdin_str;;

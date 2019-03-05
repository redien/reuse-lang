
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

let rec _list_to_string_r = fun input result ->
    match input with
          CCons(x, rest) ->
            let string_from_int = (String.make 1 (Char.chr (Int32.to_int x))) in
            let new_result = (String.concat "" (result :: string_from_int :: [])) in
                (_list_to_string_r rest new_result)
        | CEmpty -> result;;

let _list_to_string = fun input -> (_list_to_string_r (string_45to_45list input) "");;

let _chunk_size s = Int32.of_int (String.length s);;
let _chunk_get index s =
        let string_size = String.length s in
        let i = Int32.to_int index in
        if i < 0 || i >= string_size then
                65l
        else
                Int32.of_int (Char.code (String.get s i));;
let rec _chunk_slice offset size s =
        let string_size = String.length s in
        let offset = Int32.to_int offset in
        let size = Int32.to_int size in
        if offset < 0 || size < 0 || offset + size > string_size then
                CChunk (s, _chunk_size, _chunk_get, _chunk_slice)
        else
                CChunk (String.sub s offset size, _chunk_size, _chunk_get, _chunk_slice);;

let _stdin_list =
        CChunk (_stdin_string, _chunk_size, _chunk_get, _chunk_slice);;

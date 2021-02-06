
let read_line ic =
    try Some (input_line ic)
    with End_of_file -> None

let read_lines ic =
    let buffer = Buffer.create 1024 in
    let rec loop () =
        match read_line ic with
        | Some line ->
            if Buffer.length buffer > 0 then Buffer.add_char buffer '\n' ;
            Buffer.add_string buffer line ;
            loop ()
        | None -> buffer
    in
        loop ();;

let read_stdin _ = Buffer.to_bytes (read_lines stdin);;

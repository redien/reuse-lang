
let ml_string_to_reuse s =
    Seq.fold_left (fun a b -> string_45append (Int32.of_int (Char.code b)) a)
                  (string_45empty ())
                  (String.to_seq s);;

let ml_list_to_reuse l =
    List.fold_right list_45cons l CEmpty;;

let reuse_string_to_ml s =
    Buffer.contents (string_45foldl (fun a b -> Buffer.add_char b (Char.chr (Int32.to_int a)); b) (Buffer.create 32) s);;

let reuse_boolean_to_ml b =
    match b with
      | CTrue -> true
      | CFalse -> false;;

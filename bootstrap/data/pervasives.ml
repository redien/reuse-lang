
let ml_string_to_reuse s =
    Seq.fold_left (fun a b -> string_append (Int32.of_int (Char.code b)) a)
                  (string_empty ())
                  (String.to_seq s);;

let ml_list_to_reuse l =
    List.fold_right list_cons l Empty;;

let reuse_string_to_ml s =
    Buffer.contents (string_foldl (fun a b -> Buffer.add_char b (Char.chr (Int32.to_int a)); b) (Buffer.create 32) s);;

let reuse_boolean_to_ml b =
    match b with
      | True -> true
      | False -> false;;

let ml_string_get s index =
    let i = (Int32.to_int index) in
    if i < (String.length s) && i >= 0 then
            Some (Int32.of_int (Char.code (String.get s i)))
    else
            None;;

let ml_string_next iterable =
    match iterable with
        Pair (s, index) -> Pair (
            (ml_string_get s index),
            Pair (s, Int32.add index 1l));;
let ml_string_to_indexed_iterator s = indexed_iterator_from_iterable (IterableClass (ml_string_next)) (Pair (s, 0l));;

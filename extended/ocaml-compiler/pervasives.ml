
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

let ml_string_get succ fail s index =
    let i = (Int32.to_int index) in
    if i < (String.length s) && i >= 0 then
            succ (Int32.of_int (Char.code (String.get s i)))
    else
            fail ();;

let ml_string_next iterable =
    match iterable with
        CPair (s, index) -> CPair (
            (ml_string_get (fun x -> CSome (x)) (fun _ -> CNone) s index),
            CPair (s, Int32.add index 1l));;
let ml_string_to_indexed_iterator s = indexed_45iterator_45from_45iterable (CIterableClass (ml_string_next)) (CPair (s, 0l));;

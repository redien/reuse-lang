type slice' = bytes;;
let slice_empty x = Bytes.empty;;
let slice_of_u8 x count = if x >= 0l && x < 256l && count > 0l then Bytes.make (Int32.to_int count) (Char.chr (Int32.to_int x)) else Bytes.make 1 (Char.chr 0);;
let slice_size slice = Int32.of_int (Bytes.length slice);;
let slice_get slice index =
    if index >= 0l && index < (slice_size slice) then
        Int32.of_int (Char.code (Bytes.get slice (Int32.to_int index)))
    else
        0l ;;
let slice_concat a b = Bytes.concat (Bytes.empty) [a; b];;
let slice_foldl f ys xs =
    let rec slice_foldl i f ys xs =
        if i < Bytes.length xs then
            slice_foldl (i + 1) f (f (Int32.of_int (Char.code (Bytes.get xs i))) ys) xs
        else
            ys in
    slice_foldl 0 f ys xs;;
let slice_subslice slice s e =
    let size = slice_size slice in
    let s' = if s < 0l then 0l else (if s >= size then (Int32.sub size 1l) else s) in
    let e' = if e < 0l then 0l else (if e >= size then (Int32.sub size 1l) else e) in
    if Int32.sub e s <= 0l then
        slice_empty ()
    else
        Bytes.sub slice (Int32.to_int s') (Int32.to_int (Int32.sub e' s'));;

type array_binary_operator' =
   | ArrayAdd
   | ArraySubtract
   | ArrayMultiply
   | ArrayDivide
   | ArrayAnd
   | ArrayOr
   | ArrayNand
   | ArrayXor
   | ArrayEqual
   | ArrayNotEqual
   | ArrayLessThan
   | ArrayLessThanEqual
   | ArrayGreaterThan
   | ArrayGreaterThanEqual;;

type array' = ArrayOfInt32 of int32
            | ArrayConcat of array' * array'
            | ArrayGenerate of array' * int32
            | ArrayShape of array'
            | ArrayMap of array_binary_operator' * array' * array'
            | ArrayReduce of array_binary_operator' * int32 * array'
            | ArrayScan of array_binary_operator' * int32 * array'
            | ArrayCompress of array' * array';;

(** Reuse array expressions are evaluated to a tuple of OCaml Arrays where the first value is the shape and
    the second value is an array with the actual data. *)

let array_add' = Int32.add;;
let array_subtract' = Int32.sub;;
let array_multiply' = Int32.mul;;
let array_divide' x y = if y <> 0l then Int32.div x y else 0l;;
let array_and' = Int32.logand;;
let array_or' = Int32.logor;;
let array_xor' = Int32.logxor;;
let array_nand' x y = Int32.lognot (Int32.logand x y);;
let array_equal' x y = if x = y then 1l else 0l;;
let array_not_equal' x y = if x <> y then 1l else 0l;;
let array_less_than' x y = if x < y then 1l else 0l;;
let array_less_than_equal' x y = if x <= y then 1l else 0l;;
let array_greater_than' x y = if x > y then 1l else 0l;;
let array_greater_than_equal' x y = if x >= y then 1l else 0l;;
let select_op' op = match op with
    | ArrayAdd -> array_add'
    | ArraySubtract -> array_subtract'
    | ArrayMultiply -> array_multiply'
    | ArrayDivide -> array_divide'
    | ArrayAnd -> array_and'
    | ArrayOr -> array_or'
    | ArrayNand -> array_nand'
    | ArrayXor -> array_xor'
    | ArrayEqual -> array_equal'
    | ArrayNotEqual -> array_not_equal'
    | ArrayLessThan -> array_less_than'
    | ArrayLessThanEqual -> array_less_than_equal'
    | ArrayGreaterThan -> array_greater_than'
    | ArrayGreaterThanEqual -> array_greater_than_equal';;

let compress' selection values =
    let length = min (Array.length selection) (Array.length values) in
    let j = ref 0 in
    let result = Array.make length 0l in
    for i = 0 to length - 1 do
        result.(!j) <- values.(i);
        j := !j + (if selection.(i) <> 0l then 1 else 0)
    done;
    Array.sub result 0 !j;;

let rec array_eval' arr =
    let sizeFromShape shape = Int32.to_int (Array.fold_left (fun a b -> Int32.mul a (Int32.max b 0l)) 1l shape) in
    match arr with
        | ArrayOfInt32 x -> (Array.make 1 1l, Array.make 1 x)
        | ArrayConcat (a', b') ->
            let a = array_eval' a' in
            let b = array_eval' b' in
            let data = Array.append (snd a) (snd b) in
            (Array.make 1 (Int32.of_int (Array.length data)), data)
        | ArrayGenerate (shape', x) ->
            let (_, shape'') = array_eval' shape' in
            let shape = compress' (Array.map (array_less_than_equal' 0l) shape'') shape'' in
            if Array.length shape > 0 then
                (shape, Array.make (sizeFromShape shape) x)
            else
                (Array.make 0 0l, Array.make 0 0l)
        | ArrayShape array' ->
            let array = array_eval' array' in
            (Array.make 1 (Int32.of_int (Array.length (fst array))), fst array)
        | ArrayMap (op, a', b') ->
            let a = array_eval' a' in
            let b = array_eval' b' in
            let result = Array.map2 (select_op' op) (snd a) (snd b) in
            (Array.make 1 (Int32.of_int (Array.length result)), result)
        | ArrayReduce (op, k, array') ->
            let array = array_eval' array' in
            (Array.make 1 1l, Array.make 1 (Array.fold_left (select_op' op) k (snd array)))
        | ArrayScan (op, k, array') ->
            let array = array_eval' array' in
            let partial_op y x = (select_op' op x y, select_op' op x y) in
            (match Array.fold_left_map partial_op k (snd array) with
                (_, data) -> (fst array, data))
        | ArrayCompress (a', b') ->
            let a = array_eval' a' in
            let b = array_eval' b' in
            let selection = snd a in
            let values = snd b in
            let result = compress' selection values in
            let len = Array.length result in
            (Array.make 1 (Int32.of_int len), result);;

let array_foldl f ys xs =
    Array.fold_left f ys (snd (array_eval' xs));;

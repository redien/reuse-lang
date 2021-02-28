type _slice = bytes;;
let slice_empty x = Bytes.empty;;
let slice_of x = if x >= 0l && x < 256l then Bytes.make 1 (Char.chr (Int32.to_int x)) else Bytes.make 1 (Char.chr 0);;
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
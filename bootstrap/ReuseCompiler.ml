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

let rec id x7 = 
    x7;;

let rec const a b = 
    a;;

let rec flip f = 
    (fun b2 a2 -> (f a2 b2));;

let rec x f2 g x8 y = 
    (f2 (g x8 y));;

let rec fix f3 = 
    (f3 (fix f3));;

let rec let_bind x9 f4 = 
    (f4 x9);;

type boolean  = 
     | True
     | False;;

let rec not a3 = 
    (match a3 with
         | True -> 
            False
         | False -> 
            True);;

let rec and2 a4 b3 = 
    (match a4 with
         | True -> 
            b3
         | False -> 
            False);;

let rec or2 a5 b4 = 
    (match a5 with
         | True -> 
            True
         | False -> 
            b4);;

let rec x2 a6 b5 = 
    (if a6<b5 then True else False);;

let rec x3 a7 b6 = 
    (x2 b6 a7);;

let rec x4 a8 b7 = 
    (not (or2 (x2 a8 b7) (x3 a8 b7)));;

let rec x5 a9 b8 = 
    (or2 (x2 a9 b8) (x4 a9 b8));;

let rec x6 a10 b9 = 
    (or2 (x3 a10 b9) (x4 a10 b9));;

let rec max a11 b10 = 
    (if a11<b10 then b10 else a11);;

let rec min a12 b11 = 
    (if a12<b11 then a12 else b11);;

type ('Ta13,'Tb12) pair  = 
     | Pair : 'Ta13 * 'Tb12 -> ('Ta13,'Tb12) pair;;

let rec pair_cons a14 b13 = 
    (Pair (a14, b13));;

let rec pair_dup a15 = 
    (Pair (a15, a15));;

let rec pair_left pair2 = 
    (match pair2 with
         | (Pair (x10, x11)) -> 
            x10);;

let rec pair_right pair3 = 
    (match pair3 with
         | (Pair (x12, x13)) -> 
            x13);;

let rec pair_map f5 pair4 = 
    (match pair4 with
         | (Pair (x14, y2)) -> 
            (f5 x14 y2));;

let rec pair_bimap f6 g2 pair5 = 
    (match pair5 with
         | (Pair (x15, y3)) -> 
            (Pair ((f6 x15), (g2 y3))));;

let rec pair_map_left f7 pair6 = 
    (match pair6 with
         | (Pair (x16, y4)) -> 
            (Pair ((f7 x16), y4)));;

let rec pair_map_right f8 pair7 = 
    (match pair7 with
         | (Pair (x17, y5)) -> 
            (Pair (x17, (f8 y5))));;

let rec pair_swap pair8 = 
    (match pair8 with
         | (Pair (x18, y6)) -> 
            (Pair (y6, x18)));;

type ('Ta16) maybe  = 
     | Some : 'Ta16 -> ('Ta16) maybe
     | None;;

let rec maybe_map f9 maybe2 = 
    (match maybe2 with
         | (Some (x19)) -> 
            (Some ((f9 x19)))
         | None -> 
            None);;

let rec maybe_flatmap f10 maybe3 = 
    (match maybe3 with
         | (Some (x20)) -> 
            (f10 x20)
         | None -> 
            None);;

let rec maybe_bind maybe4 f11 = 
    (maybe_flatmap f11 maybe4);;

let rec maybe_return x21 = 
    (Some (x21));;

let rec maybe_filter f12 maybe5 = 
    (match maybe5 with
         | (Some (x22)) -> 
            (match (f12 x22) with
                 | True -> 
                    maybe5
                 | False -> 
                    None)
         | None -> 
            None);;

let rec maybe_else f13 maybe6 = 
    (match maybe6 with
         | None -> 
            (f13 ())
         | (Some (x23)) -> 
            x23);;

let rec maybe_or_else value2 maybe7 = 
    (match maybe7 with
         | None -> 
            value2
         | (Some (x24)) -> 
            x24);;

type ('Tcollection,'Telement) iterable_class  = 
     | IterableClass : ('Tcollection -> (('Telement) maybe,'Tcollection) pair) -> ('Tcollection,'Telement) iterable_class;;

let rec iterable_next class2 collection2 = 
    (match class2 with
         | (IterableClass (next)) -> 
            (next collection2));;

type ('Telement2) indexed_iterator  = 
     | IndexedIterator : ('Titerable,'Telement2) iterable_class * 'Titerable * int32 -> ('Telement2) indexed_iterator;;

let rec indexed_iterator_from_iterable i iterable2 = 
    (IndexedIterator (i, iterable2, (0l)));;

let rec indexed_iterator_next iterator = 
    (match iterator with
         | (IndexedIterator (i2, iterable3, index)) -> 
            (match (iterable_next i2 iterable3) with
                 | (Pair (value3, next_iterable)) -> 
                    (Pair (value3, (IndexedIterator (i2, next_iterable, (Int32.add index (1l))))))));;

let rec indexed_iterator_index iterator2 = 
    (match iterator2 with
         | (IndexedIterator (x25, x26, index2)) -> 
            index2);;

type ('Ta17) list  = 
     | Cons : 'Ta17 * ('Ta17) list -> ('Ta17) list
     | Empty;;

let rec list_empty () = 
    Empty;;

let rec list_cons x27 xs = 
    (Cons (x27, xs));;

let rec list_from x28 = 
    (Cons (x28, Empty));;

let rec list_from_range2 from to2 rest = 
    (match (x3 to2 from) with
         | True -> 
            (list_from_range2 from (Int32.sub to2 (1l)) (Cons ((Int32.sub to2 (1l)), rest)))
         | False -> 
            rest);;

let rec list_from_range from2 to3 = 
    (list_from_range2 from2 to3 Empty);;

let rec list_first list2 = 
    (match list2 with
         | (Cons (x29, x30)) -> 
            (Some (x29))
         | Empty -> 
            None);;

let rec list_rest list3 = 
    (match list3 with
         | (Cons (x31, rest2)) -> 
            rest2
         | Empty -> 
            Empty);;

let rec list_last list4 = 
    (match list4 with
         | Empty -> 
            None
         | (Cons (x32, Empty)) -> 
            (Some (x32))
         | (Cons (x33, rest3)) -> 
            (list_last rest3));;

let rec list_is_empty list5 = 
    (match list5 with
         | (Cons (x34, x35)) -> 
            False
         | Empty -> 
            True);;

let rec list_size2 list6 size = 
    (match list6 with
         | (Cons (x36, rest4)) -> 
            (list_size2 rest4 (Int32.add size (1l)))
         | Empty -> 
            size);;

let rec list_size list7 = 
    (list_size2 list7 (0l));;

let rec list_foldrk f14 initial list8 continue = 
    (match list8 with
         | Empty -> 
            (continue initial)
         | (Cons (x37, xs2)) -> 
            (list_foldrk f14 initial xs2 (fun value4 -> (f14 x37 value4 continue))));;

let rec list_foldlk f15 initial2 list9 continue2 = 
    (match list9 with
         | Empty -> 
            (continue2 initial2)
         | (Cons (x38, xs3)) -> 
            (f15 x38 initial2 (fun new_value -> (list_foldlk f15 new_value xs3 continue2))));;

let rec list_foldr f16 initial3 list10 = 
    (list_foldrk (fun x39 value5 continue3 -> (continue3 (f16 x39 value5))) initial3 list10 (fun x40 -> x40));;

let rec list_foldl f17 initial4 list11 = 
    (match list11 with
         | Empty -> 
            initial4
         | (Cons (x41, xs4)) -> 
            (list_foldl f17 (f17 x41 initial4) xs4));;

let rec list_concat a18 b14 = 
    (list_foldr list_cons b14 a18);;

let rec list_reverse list12 = 
    (list_foldl list_cons Empty list12);;

let rec list_map f18 list13 = 
    (list_foldr (fun head tail -> (list_cons (f18 head) tail)) Empty list13);;

let rec list_flatmap f19 list14 = 
    (list_foldr (fun head2 tail2 -> (list_concat (f19 head2) tail2)) Empty list14);;

let rec list_flatten list15 = 
    (list_foldr list_concat Empty list15);;

let rec list_split_at2 n a19 b15 = 
    (match (x3 n (0l)) with
         | True -> 
            (match b15 with
                 | (Cons (x42, xs5)) -> 
                    (list_split_at2 (Int32.sub n (1l)) (Cons (x42, a19)) xs5)
                 | Empty -> 
                    (Pair ((list_reverse a19), b15)))
         | False -> 
            (Pair ((list_reverse a19), b15)));;

let rec list_split_at n2 xs6 = 
    (list_split_at2 n2 Empty xs6);;

let rec list_partition2 n3 xs7 partitions = 
    (match (list_split_at n3 xs7) with
         | (Pair (Empty, x43)) -> 
            partitions
         | (Pair (partition, xs8)) -> 
            (list_partition2 n3 xs8 (Cons (partition, partitions))));;

let rec list_partition n4 xs9 = 
    (list_reverse (list_partition2 n4 xs9 Empty));;

let rec list_partition_by2 x44 xs10 = 
    (match xs10 with
         | (Cons (partition2, rest5)) -> 
            (Cons ((Cons (x44, partition2)), rest5))
         | Empty -> 
            xs10);;

let rec list_partition_by f20 xs11 = 
    (match xs11 with
         | Empty -> 
            Empty
         | (Cons (x45, Empty)) -> 
            (Cons ((Cons (x45,Empty)),Empty))
         | (Cons (x46, (Cons (x47, rest6)))) -> 
            (match (f20 x46 x47) with
                 | True -> 
                    (list_partition_by2 x46 (list_partition_by f20 (Cons (x47, rest6))))
                 | False -> 
                    (Cons ((Cons (x46,Empty)), (list_partition_by f20 (Cons (x47, rest6)))))));;

let rec list_skip count list16 = 
    (pair_right (list_split_at count list16));;

let rec list_take count2 list17 = 
    (pair_left (list_split_at count2 list17));;

let rec list_zip2 xs12 ys collected = 
    (match xs12 with
         | Empty -> 
            collected
         | (Cons (x48, xs13)) -> 
            (match ys with
                 | Empty -> 
                    collected
                 | (Cons (y7, ys2)) -> 
                    (list_zip2 xs13 ys2 (Cons ((Pair (x48, y7)), collected)))));;

let rec list_zip xs14 ys3 = 
    (list_reverse (list_zip2 xs14 ys3 Empty));;

let rec list_mapi f21 list18 = 
    (list_map (pair_map f21) (list_zip list18 (list_from_range (0l) (list_size list18))));;

let rec list_pairs xs15 = 
    (match xs15 with
         | (Cons (a20, (Cons (b16, rest7)))) -> 
            (Cons ((Pair (a20, b16)), (list_pairs rest7)))
         | x49 -> 
            Empty);;

let rec list_find_first predicate list19 = 
    (match list19 with
         | Empty -> 
            None
         | (Cons (x50, xs16)) -> 
            (match (predicate x50) with
                 | True -> 
                    (Some (x50))
                 | False -> 
                    (list_find_first predicate xs16)));;

let rec list_filter f22 list20 = 
    (list_foldr (fun head3 tail3 -> (match (f22 head3) with
         | True -> 
            (Cons (head3, tail3))
         | False -> 
            tail3)) Empty list20);;

let rec list_exclude f23 list21 = 
    (list_filter (fun x' -> x' |> f23 |> not) list21);;

let rec list_any f24 list22 = 
    (match (list_find_first f24 list22) with
         | (Some (x51)) -> 
            True
         | x52 -> 
            False);;

let rec list_every f25 list23 = 
    (match (list_find_first (fun x53 -> (not (f25 x53))) list23) with
         | (Some (x54)) -> 
            False
         | x55 -> 
            True);;

let rec list_from_maybe maybe8 = 
    (match maybe8 with
         | (Some (x56)) -> 
            (Cons (x56,Empty))
         | None -> 
            Empty);;

let rec list_collect_from_indexed_iterator2 predicate2 iterator3 initial5 = 
    (match (indexed_iterator_next iterator3) with
         | (Pair (None, x57)) -> 
            (Pair (iterator3, initial5))
         | (Pair ((Some (x58)), next2)) -> 
            (match (predicate2 x58) with
                 | True -> 
                    (list_collect_from_indexed_iterator2 predicate2 next2 (Cons (x58, initial5)))
                 | False -> 
                    (Pair (iterator3, initial5))));;

let rec list_collect_from_indexed_iterator predicate3 iterator4 = 
    (match (list_collect_from_indexed_iterator2 predicate3 iterator4 Empty) with
         | (Pair (iterator5, result2)) -> 
            (Pair (iterator5, (list_reverse result2))));;

let rec maybe_concat maybes = 
    (list_foldr (fun maybe9 values -> (match maybe9 with
         | (Some (value6)) -> 
            (Cons (value6, values))
         | None -> 
            values)) Empty maybes);;

type string_node  = 
     | FTValue : int32 -> string_node
     | FTNode2 : int32 * string_node * string_node -> string_node
     | FTNode3 : int32 * string_node * string_node * string_node -> string_node;;

type string  = 
     | FTEmpty
     | FTSingle : string_node -> string
     | FTDeep : (string_node) list * string * (string_node) list -> string;;

let rec string_empty () = 
    FTEmpty;;

let rec string_of_char character = 
    (FTSingle ((FTValue (character))));;

let rec string_node_size node = 
    (match node with
         | (FTValue (x59)) -> 
            (1l)
         | (FTNode2 (size2, x60, x61)) -> 
            size2
         | (FTNode3 (size3, x62, x63, x64)) -> 
            size3);;

let rec string_node2 a21 b17 = 
    (FTNode2 ((Int32.add (string_node_size a21) (string_node_size b17)), a21, b17));;

let rec string_node3 a22 b18 c = 
    (FTNode3 ((Int32.add (string_node_size a22) (Int32.add (string_node_size b18) (string_node_size c))), a22, b18, c));;

let rec string_prepend_node a23 tree = 
    (match tree with
         | FTEmpty -> 
            (FTSingle (a23))
         | (FTSingle (x65)) -> 
            (FTDeep ((Cons (a23,Empty)), FTEmpty, (Cons (x65,Empty))))
         | (FTDeep (first, middle, last)) -> 
            (match first with
                 | (Cons (b19, (Cons (c2, (Cons (d, (Cons (e, Empty)))))))) -> 
                    (FTDeep ((Cons (a23,Cons (b19,Empty))), (string_prepend_node (string_node3 c2 d e) middle), last))
                 | x66 -> 
                    (FTDeep ((Cons (a23, first)), middle, last))));;

let rec string_prepend char string2 = 
    (string_prepend_node (FTValue (char)) string2);;

let rec string_append_node a24 tree2 = 
    (match tree2 with
         | FTEmpty -> 
            (FTSingle (a24))
         | (FTSingle (x67)) -> 
            (FTDeep ((Cons (x67,Empty)), FTEmpty, (Cons (a24,Empty))))
         | (FTDeep (first2, middle2, last2)) -> 
            (match last2 with
                 | (Cons (b20, (Cons (c3, (Cons (d2, (Cons (e2, Empty)))))))) -> 
                    (FTDeep (first2, (string_append_node (string_node3 e2 d2 c3) middle2), (Cons (a24,Cons (b20,Empty)))))
                 | x68 -> 
                    (FTDeep (first2, middle2, (Cons (a24, last2))))));;

let rec string_append char2 string3 = 
    (string_append_node (FTValue (char2)) string3);;

let rec string_first_node node2 = 
    (match node2 with
         | (FTValue (x69)) -> 
            x69
         | (FTNode2 (x70, x71, x72)) -> 
            (string_first_node x71)
         | (FTNode3 (x73, x74, x75, x76)) -> 
            (string_first_node x74));;

let rec string_first string4 = 
    (match string4 with
         | FTEmpty -> 
            None
         | (FTSingle (node3)) -> 
            (Some ((string_first_node node3)))
         | (FTDeep (first3, middle3, last3)) -> 
            (maybe_map string_first_node (list_first first3)));;

let rec string_rest_node node4 = 
    (match node4 with
         | (FTValue (x77)) -> 
            None
         | (FTNode2 (x78, a25, b21)) -> 
            (match (string_rest_node a25) with
                 | (Some (node5)) -> 
                    (Some ((string_node2 node5 b21)))
                 | None -> 
                    (Some (b21)))
         | (FTNode3 (x79, a26, b22, c4)) -> 
            (match (string_rest_node a26) with
                 | (Some (node6)) -> 
                    (Some ((string_node3 node6 b22 c4)))
                 | None -> 
                    (Some ((string_node2 b22 c4)))));;

let rec string_rest string5 = 
    (match string5 with
         | FTEmpty -> 
            string5
         | (FTSingle (node7)) -> 
            (match (string_rest_node node7) with
                 | (Some (node8)) -> 
                    (FTSingle (node8))
                 | None -> 
                    FTEmpty)
         | (FTDeep ((Cons (node9, rest8)), middle4, last4)) -> 
            (match (string_rest_node node9) with
                 | (Some (node10)) -> 
                    (FTDeep ((Cons (node10, rest8)), middle4, last4))
                 | None -> 
                    (match rest8 with
                         | Empty -> 
                            (list_foldr string_append_node middle4 last4)
                         | x80 -> 
                            (FTDeep (rest8, middle4, last4))))
         | x81 -> 
            string5);;

let rec string_foldr_node f26 node11 identity = 
    (match node11 with
         | (FTValue (a27)) -> 
            (f26 a27 identity)
         | (FTNode2 (x82, a28, b23)) -> 
            (string_foldr_node f26 a28 (string_foldr_node f26 b23 identity))
         | (FTNode3 (x83, a29, b24, c5)) -> 
            (string_foldr_node f26 a29 (string_foldr_node f26 b24 (string_foldr_node f26 c5 identity))));;

let rec string_foldr f27 identity2 tree3 = 
    (match tree3 with
         | FTEmpty -> 
            identity2
         | (FTSingle (x84)) -> 
            (string_foldr_node f27 x84 identity2)
         | (FTDeep (first4, middle5, last5)) -> 
            (list_foldr (string_foldr_node f27) (string_foldr f27 (list_foldl (string_foldr_node f27) identity2 last5) middle5) first4));;

let rec string_foldl_node f28 node12 identity3 = 
    (match node12 with
         | (FTValue (a30)) -> 
            (f28 a30 identity3)
         | (FTNode2 (x85, b25, a31)) -> 
            (string_foldl_node f28 a31 (string_foldl_node f28 b25 identity3))
         | (FTNode3 (x86, c6, b26, a32)) -> 
            (string_foldl_node f28 a32 (string_foldl_node f28 b26 (string_foldl_node f28 c6 identity3))));;

let rec string_foldl f29 identity4 tree4 = 
    (match tree4 with
         | FTEmpty -> 
            identity4
         | (FTSingle (x87)) -> 
            (string_foldl_node f29 x87 identity4)
         | (FTDeep (first5, middle6, last6)) -> 
            (list_foldr (string_foldl_node f29) (string_foldl f29 (list_foldl (string_foldl_node f29) identity4 first5) middle6) last6));;

let rec string_size string6 = 
    (match string6 with
         | FTEmpty -> 
            (0l)
         | (FTSingle (x88)) -> 
            (string_node_size x88)
         | (FTDeep (first6, middle7, last7)) -> 
            (Int32.add (list_foldr Int32.add (0l) (list_map string_node_size first6)) (Int32.add (list_foldr Int32.add (0l) (list_map string_node_size last7)) (string_size middle7))));;

let rec string_concat_nodes nodes = 
    (match nodes with
         | (Cons (a33, (Cons (b27, Empty)))) -> 
            (Cons ((string_node2 a33 b27),Empty))
         | (Cons (a34, (Cons (b28, (Cons (c7, Empty)))))) -> 
            (Cons ((string_node3 a34 b28 c7),Empty))
         | (Cons (a35, (Cons (b29, (Cons (c8, (Cons (d3, Empty)))))))) -> 
            (Cons ((string_node2 a35 b29),Cons ((string_node2 c8 d3),Empty)))
         | (Cons (a36, (Cons (b30, (Cons (c9, rest9)))))) -> 
            (Cons ((string_node3 a36 b30 c9), (string_concat_nodes rest9)))
         | x89 -> 
            Empty);;

type ('Ta37,'Tb31,'Tc10) triple  = 
     | Triple : 'Ta37 * 'Tb31 * 'Tc10 -> ('Ta37,'Tb31,'Tc10) triple;;

let rec string_concat2 a38 nodes2 b32 = 
    (match (Triple (a38, nodes2, b32)) with
         | (Triple (FTEmpty, nodes3, b33)) -> 
            (list_foldr string_prepend_node b33 nodes3)
         | (Triple (a39, nodes4, FTEmpty)) -> 
            (list_foldl string_append_node a39 nodes4)
         | (Triple ((FTSingle (x90)), nodes5, b34)) -> 
            (string_prepend_node x90 (list_foldr string_prepend_node b34 nodes5))
         | (Triple (a40, nodes6, (FTSingle (x91)))) -> 
            (string_append_node x91 (list_foldl string_append_node a40 nodes6))
         | (Triple ((FTDeep (first1, middle1, last1)), nodes7, (FTDeep (first22, middle22, last22)))) -> 
            (FTDeep (first1, (string_concat2 middle1 (string_concat_nodes (list_concat (list_reverse last1) (list_concat nodes7 first22))) middle22), last22)));;

let rec string_concat a41 b35 = 
    (string_concat2 a41 Empty b35);;

let rec string_is_empty string7 = 
    (match (string_first string7) with
         | (Some (x92)) -> 
            False
         | None -> 
            True);;

let rec string_any predicate4 string8 = 
    (string_foldl (fun x93 b36 -> (or2 (predicate4 x93) b36)) False string8);;

let rec string_every predicate5 string9 = 
    (string_foldl (fun x94 b37 -> (and2 (predicate5 x94) b37)) True string9);;

let rec string_to_list string10 = 
    (string_foldr list_cons Empty string10);;

let rec string_from_list list24 = 
    (list_foldl string_append (string_empty ()) list24);;

let rec string_skip count3 string11 = 
    (match string11 with
         | FTEmpty -> 
            FTEmpty
         | x95 -> 
            (match (x3 count3 (0l)) with
                 | True -> 
                    (string_skip (Int32.sub count3 (1l)) (string_rest string11))
                 | False -> 
                    string11));;

let rec string_take2 count4 string12 taken = 
    (match (x3 count4 (0l)) with
         | True -> 
            (match (string_first string12) with
                 | (Some (char3)) -> 
                    (string_take2 (Int32.sub count4 (1l)) (string_rest string12) (string_append char3 taken))
                 | None -> 
                    taken)
         | False -> 
            taken);;

let rec string_take count5 string13 = 
    (string_take2 count5 string13 (string_empty ()));;

let rec string_reverse string14 = 
    (string_foldl string_prepend (string_empty ()) string14);;

let rec string_repeat string15 n5 = 
    (list_foldl (x (string_concat string15) (flip const)) (string_empty ()) (list_from_range (0l) n5));;

let rec string_substring start size4 string16 = 
    (string_take size4 (string_skip start string16));;

let rec string_join separator strings = 
    (match strings with
         | (Cons (first7, rest10)) -> 
            (list_foldl (fun string17 joined -> (string_concat joined (string_concat separator string17))) first7 rest10)
         | Empty -> 
            (string_empty ()));;

let rec string_flatmap f30 string18 = 
    (string_foldl (fun x96 xs17 -> (string_concat xs17 (f30 x96))) (string_empty ()) string18);;

let rec string_split2 separator2 list25 current parts = 
    (match list25 with
         | Empty -> 
            (list_reverse (Cons ((list_reverse current), parts)))
         | (Cons (c11, rest11)) -> 
            (match (x4 separator2 c11) with
                 | True -> 
                    (string_split2 separator2 rest11 Empty (Cons ((list_reverse current), parts)))
                 | False -> 
                    (string_split2 separator2 rest11 (Cons (c11, current)) parts)));;

let rec string_split separator3 string19 = 
    (list_map string_from_list (string_split2 separator3 (string_to_list string19) Empty Empty));;

let rec string_trim_start2 list26 = 
    (match list26 with
         | (Cons (x97, xs18)) -> 
            (match (x4 x97 (32l)) with
                 | True -> 
                    (string_trim_start2 xs18)
                 | False -> 
                    list26)
         | Empty -> 
            list26);;

let rec string_trim_start string20 = 
    (string_from_list (string_trim_start2 (string_to_list string20)));;

let rec string_trim_end string21 = 
    (string_reverse (string_trim_start (string_reverse string21)));;

let rec string_trim string22 = 
    (string_trim_start (string_trim_end string22));;

let rec string_equal a42 b38 = 
    (match (string_first a42) with
         | (Some (xa)) -> 
            (match (string_first b38) with
                 | (Some (xb)) -> 
                    (match (x4 xa xb) with
                         | True -> 
                            (string_equal (string_rest a42) (string_rest b38))
                         | False -> 
                            False)
                 | None -> 
                    (string_is_empty a42))
         | None -> 
            (string_is_empty b38));;

let rec string_index_of2 index3 substring substring_size string23 string_size2 = 
    (match (x6 index3 string_size2) with
         | True -> 
            None
         | False -> 
            (match (string_equal substring (string_substring index3 substring_size string23)) with
                 | True -> 
                    (Some (index3))
                 | False -> 
                    (string_index_of2 (Int32.add index3 (1l)) substring substring_size string23 string_size2)));;

let rec string_index_of index4 substring2 string24 = 
    (string_index_of2 index4 substring2 (string_size substring2) string24 (string_size string24));;

let rec string_point_is_digit point = 
    (match (x3 point (47l)) with
         | False -> 
            False
         | True -> 
            (match (x2 point (58l)) with
                 | True -> 
                    True
                 | False -> 
                    False));;

let rec string_to_int322 string_to_int323 string25 accumulator x98 = 
    (string_to_int323 string25 (Some ((Int32.add (Int32.mul (10l) accumulator) (Int32.sub x98 (48l))))));;

let rec string_to_int324 string26 accumulator2 = 
    (match string26 with
         | Empty -> 
            accumulator2
         | (Cons (x99, rest12)) -> 
            (maybe_flatmap (fun accumulator3 -> ((Some (x99)) |> (maybe_filter string_point_is_digit) |> (maybe_flatmap (string_to_int322 string_to_int324 rest12 accumulator3)))) accumulator2));;

let rec string_to_int325 string27 = 
    (match string27 with
         | (Cons (45l, string28)) -> 
            (match (list_is_empty string28) with
                 | True -> 
                    None
                 | False -> 
                    (maybe_map (fun x100 -> (Int32.mul (-1l) x100)) (string_to_int325 string28)))
         | (Cons (x101, rest13)) -> 
            (match (string_point_is_digit x101) with
                 | True -> 
                    (string_to_int324 string27 (Some ((0l))))
                 | False -> 
                    None)
         | Empty -> 
            None);;

let rec string_to_int32 string29 = 
    (string_to_int325 (string_to_list string29));;

let rec string_from_int322 integer string30 = 
    (match (x3 integer (9l)) with
         | True -> 
            (string_from_int322 (Int32.div integer (10l)) (Cons ((Int32.add (Int32.rem integer (10l)) (48l)), string30)))
         | False -> 
            (Cons ((Int32.add integer (48l)), string30)));;

let rec string_from_int323 integer2 = 
    (match (x2 integer2 (0l)) with
         | True -> 
            (match (x4 integer2 (-2147483648l)) with
                 | True -> 
                    (Cons ((45l),Cons ((50l),Cons ((49l),Cons ((52l),Cons ((55l),Cons ((52l),Cons ((56l),Cons ((51l),Cons ((54l),Cons ((52l),Cons ((56l),Empty))))))))))))
                 | False -> 
                    (Cons ((45l), (string_from_int323 (Int32.mul integer2 (-1l))))))
         | False -> 
            (string_from_int322 integer2 Empty));;

let rec string_from_int32 integer3 = 
    (string_from_list (string_from_int323 integer3));;

let rec string_collect_from_slice2 predicate6 index5 slice2 initial6 = 
    (match (x2 index5 (slice_size slice2)) with
         | False -> 
            (Pair (index5, initial6))
         | True -> 
            (match (predicate6 (slice_get slice2 index5)) with
                 | True -> 
                    (string_collect_from_slice2 predicate6 (Int32.add index5 (1l)) slice2 (string_append (slice_get slice2 index5) initial6))
                 | False -> 
                    (Pair (index5, initial6))));;

let rec string_collect_from_slice predicate7 index6 slice3 = 
    (string_collect_from_slice2 predicate7 index6 slice3 (string_empty ()));;

let rec string_to_slice string31 = 
    (string_foldl (fun c12 slice4 -> (slice_concat slice4 (slice_of_u8 c12 (1l)))) (slice_empty ()) string31);;

let rec string_from_slice slice5 = 
    (slice_foldl string_append (string_empty ()) slice5);;

let rec string_collect_from_indexed_iterator2 predicate8 iterator6 initial7 = 
    (match (indexed_iterator_next iterator6) with
         | (Pair (None, x102)) -> 
            (Pair (iterator6, initial7))
         | (Pair ((Some (x103)), next3)) -> 
            (match (predicate8 x103) with
                 | True -> 
                    (string_collect_from_indexed_iterator2 predicate8 next3 (string_append x103 initial7))
                 | False -> 
                    (Pair (iterator6, initial7))));;

let rec string_collect_from_indexed_iterator predicate9 iterator7 = 
    (string_collect_from_indexed_iterator2 predicate9 iterator7 (string_empty ()));;

let rec string_from_indexed_iterator iterator8 = 
    (pair_right (string_collect_from_indexed_iterator (fun x104 -> True) iterator8));;

let rec string_iterable () = 
    (IterableClass ((fun string32 -> (Pair ((string_first string32), (string_rest string32))))));;

let rec string_from_boolean boolean2 = 
    (match boolean2 with
         | True -> 
            (string_from_list (Cons ((84l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))))
         | False -> 
            (string_from_list (Cons ((70l),Cons ((97l),Cons ((108l),Cons ((115l),Cons ((101l),Empty))))))));;

let rec valid_string_from_unicode_code_point point2 = 
    (match (x3 point2 (65535l)) with
         | True -> 
            (string_from_list (Cons ((Int32.add (240l) (Int32.div (Int32.logand point2 (1835008l)) (262144l))),Cons ((Int32.add (128l) (Int32.div (Int32.logand point2 (258048l)) (4096l))),Cons ((Int32.add (128l) (Int32.div (Int32.logand point2 (4032l)) (64l))),Cons ((Int32.add (128l) (Int32.logand point2 (63l))),Empty))))))
         | False -> 
            (match (x3 point2 (2047l)) with
                 | True -> 
                    (string_from_list (Cons ((Int32.add (224l) (Int32.div (Int32.logand point2 (61440l)) (4096l))),Cons ((Int32.add (128l) (Int32.div (Int32.logand point2 (4032l)) (64l))),Cons ((Int32.add (128l) (Int32.logand point2 (63l))),Empty)))))
                 | False -> 
                    (match (x3 point2 (127l)) with
                         | True -> 
                            (string_from_list (Cons ((Int32.add (192l) (Int32.div (Int32.logand point2 (1984l)) (64l))),Cons ((Int32.add (128l) (Int32.logand point2 (63l))),Empty))))
                         | False -> 
                            (string_of_char point2))));;

let rec invalid_code_point () = 
    (string_from_list (Cons ((255l),Cons ((253l),Empty))));;

let rec string_from_unicode_code_point point3 = 
    (match (x3 point3 (1114111l)) with
         | True -> 
            (invalid_code_point ())
         | False -> 
            (match (x3 point3 (55295l)) with
                 | True -> 
                    (match (x2 point3 (57344l)) with
                         | True -> 
                            (invalid_code_point ())
                         | False -> 
                            (valid_string_from_unicode_code_point point3))
                 | False -> 
                    (valid_string_from_unicode_code_point point3)));;

type ('Tv,'Te3) result  = 
     | Result : 'Tv -> ('Tv,'Te3) result
     | Error : 'Te3 -> ('Tv,'Te3) result;;

let rec result_lift result3 = 
    (Result (result3));;

let rec result_error error2 = 
    (Error (error2));;

let rec result_prod return result4 = 
    (match result4 with
         | (Result (m)) -> 
            m
         | (Error (error3)) -> 
            (return (Error (error3))));;

let rec result_bimap f31 g3 result5 = 
    (match result5 with
         | (Result (x105)) -> 
            (Result ((f31 x105)))
         | (Error (y8)) -> 
            (Error ((g3 y8))));;

let rec result_either f32 g4 result6 = 
    (match result6 with
         | (Result (x106)) -> 
            (f32 x106)
         | (Error (x107)) -> 
            (g4 x107));;

let rec result_map f33 result7 = 
    (result_bimap f33 id result7);;

let rec result_flatmap f34 result8 = 
    (match result8 with
         | (Result (x108)) -> 
            (f34 x108)
         | (Error (error4)) -> 
            (Error (error4)));;

let rec result_or_else value7 result9 = 
    (match result9 with
         | (Result (x109)) -> 
            x109
         | (Error (x110)) -> 
            value7);;

let rec result_error2 result10 = 
    (match result10 with
         | (Error (x111)) -> 
            True
         | x112 -> 
            False);;

let rec result_filter_list list27 = 
    (list_foldr (fun result11 new_list -> (match result11 with
         | (Result (x113)) -> 
            (Cons (x113, new_list))
         | x114 -> 
            new_list)) Empty list27);;

let rec result_partition list28 = 
    (list_foldr (fun result12 state2 -> (match result12 with
         | (Result (x115)) -> 
            (Pair ((Cons (x115, (pair_left state2))), (pair_right state2)))
         | (Error (e4)) -> 
            (Pair ((pair_left state2), (Cons (e4, (pair_right state2))))))) (Pair (Empty, Empty)) list28);;

let rec result_concat list29 = 
    (match (list_filter result_error2 list29) with
         | (Cons ((Error (error5)), x116)) -> 
            (Error (error5))
         | (Cons ((Result (x117)), x118)) -> 
            (Result (Empty))
         | Empty -> 
            (Result ((result_filter_list list29))));;

let rec result_of_maybe error6 maybe10 = 
    (match maybe10 with
         | (Some (x119)) -> 
            (Result (x119))
         | None -> 
            (Error (error6)));;

let rec result_bind result13 f35 = 
    (result_flatmap f35 result13);;

let rec result_return value8 = 
    (result_lift value8);;

type ('Ts,'Tv2) state  = 
     | Operation : ('Ts -> ('Ts,'Tv2) pair) -> ('Ts,'Tv2) state;;

let rec state_run state3 operation = 
    (match operation with
         | (Operation (f36)) -> 
            (f36 state3));;

let rec state_final_value initial_state operation2 = 
    (match (state_run initial_state operation2) with
         | (Pair (x120, value9)) -> 
            value9);;

let rec state_return value10 = 
    (Operation ((fun state4 -> (Pair (state4, value10)))));;

let rec state_bind operation3 f37 = 
    (Operation ((fun state5 -> (match (state_run state5 operation3) with
         | (Pair (new_state, new_value2)) -> 
            (state_run new_state (f37 new_value2))))));;

let rec state_get () = 
    (Operation ((fun state6 -> (Pair (state6, state6)))));;

let rec state_set state7 = 
    (Operation ((fun x121 -> (Pair (state7, state7)))));;

let rec state_modify f38 = 
    (state_bind (state_get ()) (fun state8 -> (state_set (f38 state8))));;

let rec state_let value11 f39 = 
    (state_bind (state_return value11) f39);;

let rec state_foldr f40 initial_value operations = 
    (list_foldr (fun operation4 chain -> (state_bind operation4 (fun x122 -> (state_bind chain (fun xs19 -> (state_return (f40 x122 xs19))))))) (state_return initial_value) operations);;

let rec state_foreach f41 xs20 = 
    (state_foldr list_cons Empty (list_map f41 xs20));;

let rec state_flatmap f42 operation5 = 
    (state_bind operation5 f42);;

let rec state_map f43 operation6 = 
    (state_flatmap (fun x' -> x' |> f43 |> state_return) operation6);;

let rec state_lift value12 = 
    (state_return value12);;

type array_color  = 
     | ArrayRed
     | ArrayBlack;;

type ('Tvalue13) array  = 
     | ArrayEmpty
     | ArrayTree : array_color * ('Tvalue13) array * (int32,'Tvalue13) pair * ('Tvalue13) array -> ('Tvalue13) array;;

let rec array_empty () = 
    ArrayEmpty;;

let rec array_make_black array2 = 
    (match array2 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (x123, a43, y9, b39)) -> 
            (ArrayTree (ArrayBlack, a43, y9, b39)));;

let rec array_balance array3 = 
    (match array3 with
         | (ArrayTree (ArrayBlack, (ArrayTree (ArrayRed, (ArrayTree (ArrayRed, a44, x124, b40)), y10, c13)), z, d4)) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a44, x124, b40)), y10, (ArrayTree (ArrayBlack, c13, z, d4))))
         | (ArrayTree (ArrayBlack, (ArrayTree (ArrayRed, a45, x125, (ArrayTree (ArrayRed, b41, y11, c14)))), z2, d5)) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a45, x125, b41)), y11, (ArrayTree (ArrayBlack, c14, z2, d5))))
         | (ArrayTree (ArrayBlack, a46, x126, (ArrayTree (ArrayRed, (ArrayTree (ArrayRed, b42, y12, c15)), z3, d6)))) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a46, x126, b42)), y12, (ArrayTree (ArrayBlack, c15, z3, d6))))
         | (ArrayTree (ArrayBlack, a47, x127, (ArrayTree (ArrayRed, b43, y13, (ArrayTree (ArrayRed, c16, z4, d7)))))) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a47, x127, b43)), y13, (ArrayTree (ArrayBlack, c16, z4, d7))))
         | rest14 -> 
            rest14);;

let rec array_set2 x128 value14 array4 = 
    (match array4 with
         | ArrayEmpty -> 
            (ArrayTree (ArrayRed, ArrayEmpty, (Pair (x128, value14)), ArrayEmpty))
         | (ArrayTree (color, a48, y14, b44)) -> 
            (match (x2 x128 (pair_left y14)) with
                 | True -> 
                    (array_balance (ArrayTree (color, (array_set2 x128 value14 a48), y14, b44)))
                 | False -> 
                    (match (x3 x128 (pair_left y14)) with
                         | True -> 
                            (array_balance (ArrayTree (color, a48, y14, (array_set2 x128 value14 b44))))
                         | False -> 
                            (ArrayTree (color, a48, (Pair (x128, value14)), b44)))));;

let rec array_set x129 value15 array5 = 
    (array_make_black (array_set2 x129 value15 array5));;

let rec array_get x130 array6 = 
    (match array6 with
         | ArrayEmpty -> 
            None
         | (ArrayTree (x131, a49, (Pair (y15, value16)), b45)) -> 
            (match (x2 x130 y15) with
                 | True -> 
                    (array_get x130 a49)
                 | False -> 
                    (match (x3 x130 y15) with
                         | True -> 
                            (array_get x130 b45)
                         | False -> 
                            (Some (value16)))));;

let rec array_min array7 default = 
    (match array7 with
         | ArrayEmpty -> 
            default
         | (ArrayTree (x132, ArrayEmpty, y16, x133)) -> 
            y16
         | (ArrayTree (x134, a50, x135, x136)) -> 
            (array_min a50 default));;

let rec array_remove_min array8 = 
    (match array8 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (x137, ArrayEmpty, y17, b46)) -> 
            b46
         | (ArrayTree (color2, a51, y18, b47)) -> 
            (array_balance (ArrayTree (color2, (array_remove_min a51), y18, b47))));;

let rec array_remove_root array9 = 
    (match array9 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (x138, ArrayEmpty, y19, ArrayEmpty)) -> 
            ArrayEmpty
         | (ArrayTree (x139, a52, y20, ArrayEmpty)) -> 
            a52
         | (ArrayTree (x140, ArrayEmpty, y21, b48)) -> 
            b48
         | (ArrayTree (color3, a53, y22, b49)) -> 
            (array_balance (ArrayTree (color3, a53, (array_min b49 y22), (array_remove_min b49)))));;

let rec array_remove2 x141 array10 = 
    (match array10 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (color4, a54, y23, b50)) -> 
            (match (x2 x141 (pair_left y23)) with
                 | True -> 
                    (array_balance (ArrayTree (color4, (array_remove2 x141 a54), y23, b50)))
                 | False -> 
                    (match (x3 x141 (pair_left y23)) with
                         | True -> 
                            (array_balance (ArrayTree (color4, a54, y23, (array_remove2 x141 b50))))
                         | False -> 
                            (array_remove_root array10))));;

let rec array_remove x142 array11 = 
    (array_make_black (array_remove2 x142 array11));;

let rec array_entries array12 = 
    (match array12 with
         | ArrayEmpty -> 
            Empty
         | (ArrayTree (x143, a55, entry, b51)) -> 
            (list_flatten (Cons ((array_entries a55),Cons ((Cons (entry,Empty)),Cons ((array_entries b51),Empty))))));;

let rec array_from_list2 entries index7 array13 = 
    (match entries with
         | (Cons (x144, xs21)) -> 
            (array_from_list2 xs21 (Int32.add index7 (1l)) (array_set index7 x144 array13))
         | Empty -> 
            array13);;

let rec array_from_list entries2 = 
    (array_from_list2 entries2 (0l) ArrayEmpty);;

let rec array_of entries3 = 
    (list_foldl (fun entry2 array14 -> (match entry2 with
         | (Pair (key, value17)) -> 
            (array_set key value17 array14))) ArrayEmpty entries3);;

let rec array_singleton index8 value18 = 
    (ArrayTree (ArrayBlack, ArrayEmpty, (Pair (index8, value18)), ArrayEmpty));;

let rec array_get_or index9 default2 array15 = 
    (match (array_get index9 array15) with
         | (Some (value19)) -> 
            value19
         | None -> 
            default2);;

let rec array_size array16 = 
    (list_size (array_entries array16));;

type ('Tvalue20) dictionary  = 
     | Dictionary : (((string,'Tvalue20) pair) list) array -> ('Tvalue20) dictionary;;

let rec dictionary_empty () = 
    (Dictionary ((array_empty ())));;

let rec dictionary_bucket_from_key key2 = 
    (string_foldl (fun c17 h -> (Int32.add (Int32.mul h (33l)) c17)) (5381l) key2);;

let rec dictionary_set key3 new_value3 dictionary2 = 
    (match dictionary2 with
         | (Dictionary (array17)) -> 
            (match (dictionary_bucket_from_key key3) with
                 | bucket_id -> 
                    (match (array_get bucket_id array17) with
                         | (Some (bucket)) -> 
                            (match (list_filter (fun entry3 -> (not (string_equal (pair_left entry3) key3))) bucket) with
                                 | new_bucket -> 
                                    (Dictionary ((array_set bucket_id (Cons ((Pair (key3, new_value3)), new_bucket)) array17))))
                         | None -> 
                            (Dictionary ((array_set bucket_id (Cons ((Pair (key3, new_value3)),Empty)) array17))))));;

let rec dictionary_get key4 dictionary3 = 
    (match dictionary3 with
         | (Dictionary (array18)) -> 
            (match (dictionary_bucket_from_key key4) with
                 | bucket_id2 -> 
                    (match (array_get bucket_id2 array18) with
                         | (Some (bucket2)) -> 
                            (maybe_map pair_right (list_find_first (fun entry4 -> (string_equal (pair_left entry4) key4)) bucket2))
                         | None -> 
                            None)));;

let rec dictionary_remove key5 dictionary4 = 
    (match dictionary4 with
         | (Dictionary (array19)) -> 
            (match (dictionary_bucket_from_key key5) with
                 | bucket_id3 -> 
                    (match (array_get bucket_id3 array19) with
                         | (Some (bucket3)) -> 
                            (match (list_filter (fun entry5 -> (not (string_equal (pair_left entry5) key5))) bucket3) with
                                 | new_bucket2 -> 
                                    (Dictionary ((array_set bucket_id3 new_bucket2 array19))))
                         | None -> 
                            dictionary4)));;

let rec dictionary_entries dictionary5 = 
    (match dictionary5 with
         | (Dictionary (array20)) -> 
            (list_flatten (list_map pair_right (array_entries array20))));;

let rec dictionary_of entries4 = 
    (list_foldl (pair_map dictionary_set) (dictionary_empty ()) entries4);;

let rec dictionary_singleton key6 value21 = 
    (dictionary_set key6 value21 (dictionary_empty ()));;

let rec dictionary_get_or key7 default3 dictionary6 = 
    (match (dictionary_get key7 dictionary6) with
         | (Some (value22)) -> 
            value22
         | None -> 
            default3);;

let rec dictionary_size dictionary7 = 
    (list_size (dictionary_entries dictionary7));;

let rec dictionary_has key8 dictionary8 = 
    (match (dictionary_get key8 dictionary8) with
         | (Some (x145)) -> 
            True
         | None -> 
            False);;

let rec dictionary_values dictionary9 = 
    (list_map pair_right (dictionary_entries dictionary9));;

let rec dictionary_keys dictionary10 = 
    (list_map pair_left (dictionary_entries dictionary10));;

type bigint  = 
     | Bigint : boolean * (int32) list -> bigint;;

let rec bigint_trim_parts_reversed parts2 = 
    (match parts2 with
         | (Cons (x146, Empty)) -> 
            parts2
         | (Cons (x147, xs22)) -> 
            (match (x4 x147 (0l)) with
                 | True -> 
                    (bigint_trim_parts_reversed xs22)
                 | False -> 
                    parts2)
         | Empty -> 
            Empty);;

let rec bigint_trim_parts parts3 = 
    (list_reverse (bigint_trim_parts_reversed (list_reverse parts3)));;

let rec bigint_from_string string33 = 
    (match (string_first string33) with
         | (Some (45l)) -> 
            (Bigint (True, (bigint_trim_parts (list_reverse (list_map ((flip Int32.sub) (48l)) (string_to_list (string_rest string33)))))))
         | x148 -> 
            (Bigint (False, (bigint_trim_parts (list_reverse (list_map ((flip Int32.sub) (48l)) (string_to_list string33)))))));;

let rec bigint_from int = 
    (bigint_from_string (string_from_int32 int));;

let rec bigint_zero () = 
    (Bigint (False, (Cons ((0l),Empty))));;

let rec bigint_one () = 
    (Bigint (False, (Cons ((1l),Empty))));;

let rec bigint_negate int2 = 
    (match int2 with
         | (Bigint (negative, (Cons (0l, Empty)))) -> 
            int2
         | (Bigint (negative2, parts4)) -> 
            (Bigint ((match negative2 with
                 | True -> 
                    False
                 | False -> 
                    True), parts4)));;

let rec stringify_parts parts5 = 
    (string_join (string_empty ()) (list_reverse (list_map string_from_int32 parts5)));;

let rec bigint_to_string int3 = 
    (match int3 with
         | (Bigint (True, parts6)) -> 
            (string_prepend (45l) (stringify_parts parts6))
         | (Bigint (False, parts7)) -> 
            (stringify_parts parts7));;

let rec less_than_with_carry x149 y24 previous_less_than = 
    (match (x2 x149 y24) with
         | True -> 
            True
         | False -> 
            (match (x4 x149 y24) with
                 | True -> 
                    previous_less_than
                 | False -> 
                    False));;

let rec bigint_less_than_parts a56 b52 previous_less_than2 = 
    (match (Pair (a56, b52)) with
         | (Pair (Empty, Empty)) -> 
            False
         | (Pair ((Cons (x150, x151)), Empty)) -> 
            False
         | (Pair (Empty, (Cons (x152, x153)))) -> 
            True
         | (Pair ((Cons (x154, Empty)), (Cons (y25, Empty)))) -> 
            (less_than_with_carry x154 y25 previous_less_than2)
         | (Pair ((Cons (x155, xs23)), (Cons (y26, ys4)))) -> 
            (bigint_less_than_parts xs23 ys4 (less_than_with_carry x155 y26 previous_less_than2)));;

let rec bigint_less_than a57 b53 = 
    (match (Pair (a57, b53)) with
         | (Pair ((Bigint (True, x156)), (Bigint (False, x157)))) -> 
            True
         | (Pair ((Bigint (False, x158)), (Bigint (True, x159)))) -> 
            False
         | (Pair ((Bigint (True, a_parts)), (Bigint (True, b_parts)))) -> 
            (bigint_less_than_parts b_parts a_parts False)
         | (Pair ((Bigint (x160, a_parts2)), (Bigint (x161, b_parts2)))) -> 
            (bigint_less_than_parts a_parts2 b_parts2 False));;

let rec bigint_subtract_parts a58 b54 carry = 
    (match (Pair (a58, b54)) with
         | (Pair ((Cons (x162, xs24)), Empty)) -> 
            (bigint_subtract_parts a58 (Cons ((0l), Empty)) carry)
         | (Pair ((Cons (x163, xs25)), (Cons (y27, ys5)))) -> 
            (match (x2 (Int32.sub x163 (Int32.add y27 carry)) (0l)) with
                 | True -> 
                    (Cons ((Int32.sub (Int32.add x163 (10l)) (Int32.add y27 carry)), (bigint_subtract_parts xs25 ys5 (1l))))
                 | False -> 
                    (Cons ((Int32.sub x163 (Int32.add y27 carry)), (bigint_subtract_parts xs25 ys5 (0l)))))
         | x164 -> 
            Empty);;

let rec bigint_add_parts a59 b55 carry2 = 
    (match (Pair (a59, b55)) with
         | (Pair ((Cons (x165, xs26)), (Cons (y28, ys6)))) -> 
            (match (x3 (Int32.add x165 (Int32.add y28 carry2)) (9l)) with
                 | True -> 
                    (Cons ((Int32.sub (Int32.add x165 (Int32.add y28 carry2)) (10l)), (bigint_add_parts xs26 ys6 (1l))))
                 | False -> 
                    (Cons ((Int32.add x165 (Int32.add y28 carry2)), (bigint_add_parts xs26 ys6 (0l)))))
         | (Pair ((Cons (x166, x167)), Empty)) -> 
            (bigint_add_parts a59 (Cons ((0l), Empty)) carry2)
         | (Pair (Empty, (Cons (x168, x169)))) -> 
            (bigint_add_parts (Cons ((0l), Empty)) b55 carry2)
         | (Pair (Empty, Empty)) -> 
            (match (x3 carry2 (0l)) with
                 | True -> 
                    (Cons (carry2, Empty))
                 | False -> 
                    Empty));;

let rec bigint_add_zeroes n6 digits = 
    (match n6 with
         | 0l -> 
            digits
         | x170 -> 
            (bigint_add_zeroes (Int32.sub n6 (1l)) (Cons ((0l), digits))));;

let rec bigint_multiply_digit x171 digits2 carry3 = 
    (match digits2 with
         | Empty -> 
            (match (x3 carry3 (0l)) with
                 | True -> 
                    (Cons (carry3, Empty))
                 | False -> 
                    Empty)
         | (Cons (y29, ys7)) -> 
            (Cons ((Int32.rem (Int32.add (Int32.mul x171 y29) carry3) (10l)), (bigint_multiply_digit x171 ys7 (Int32.div (Int32.add (Int32.mul x171 y29) carry3) (10l))))));;

let rec bigint_multiply_parts a60 b56 base = 
    (match a60 with
         | (Cons (x172, xs27)) -> 
            (bigint_add_parts (bigint_add_zeroes base (bigint_multiply_digit x172 b56 (0l))) (bigint_multiply_parts xs27 b56 (Int32.add base (1l))) (0l))
         | Empty -> 
            Empty);;

let rec bigint_subtract a61 b57 = 
    (match (Pair (a61, b57)) with
         | (Pair ((Bigint (False, a_parts3)), (Bigint (True, b_parts3)))) -> 
            (Bigint (False, (bigint_add_parts a_parts3 b_parts3 (0l))))
         | (Pair ((Bigint (True, a_parts4)), (Bigint (False, b_parts4)))) -> 
            (Bigint (True, (bigint_add_parts a_parts4 b_parts4 (0l))))
         | (Pair ((Bigint (True, a_parts5)), (Bigint (True, b_parts5)))) -> 
            (match (bigint_less_than a61 b57) with
                 | True -> 
                    (Bigint (True, (bigint_trim_parts (bigint_subtract_parts a_parts5 b_parts5 (0l)))))
                 | False -> 
                    (Bigint (False, (bigint_trim_parts (bigint_subtract_parts b_parts5 a_parts5 (0l))))))
         | (Pair ((Bigint (False, a_parts6)), (Bigint (False, b_parts6)))) -> 
            (match (bigint_less_than a61 b57) with
                 | True -> 
                    (Bigint (True, (bigint_trim_parts (bigint_subtract_parts b_parts6 a_parts6 (0l)))))
                 | False -> 
                    (Bigint (False, (bigint_trim_parts (bigint_subtract_parts a_parts6 b_parts6 (0l)))))));;

let rec bigint_add a62 b58 = 
    (match (Pair (a62, b58)) with
         | (Pair ((Bigint (False, a_parts7)), (Bigint (False, b_parts7)))) -> 
            (Bigint (False, (bigint_add_parts a_parts7 b_parts7 (0l))))
         | (Pair ((Bigint (True, a_parts8)), (Bigint (True, b_parts8)))) -> 
            (Bigint (True, (bigint_add_parts a_parts8 b_parts8 (0l))))
         | (Pair ((Bigint (True, x173)), (Bigint (False, x174)))) -> 
            (bigint_subtract b58 (bigint_negate a62))
         | (Pair ((Bigint (False, x175)), (Bigint (True, x176)))) -> 
            (bigint_subtract a62 (bigint_negate b58)));;

let rec bigint_multiply a63 b59 = 
    (match (Pair (a63, b59)) with
         | (Pair ((Bigint (x177, (Cons (0l, Empty)))), (Bigint (x178, x179)))) -> 
            (Bigint (False, (Cons ((0l), Empty))))
         | (Pair ((Bigint (x180, x181)), (Bigint (x182, (Cons (0l, Empty)))))) -> 
            (Bigint (False, (Cons ((0l), Empty))))
         | (Pair ((Bigint (True, a_parts9)), (Bigint (False, b_parts9)))) -> 
            (Bigint (True, (bigint_multiply_parts a_parts9 b_parts9 (0l))))
         | (Pair ((Bigint (False, a_parts10)), (Bigint (True, b_parts10)))) -> 
            (Bigint (True, (bigint_trim_parts (bigint_multiply_parts a_parts10 b_parts10 (0l)))))
         | (Pair ((Bigint (x183, a_parts11)), (Bigint (x184, b_parts11)))) -> 
            (Bigint (False, (bigint_trim_parts (bigint_multiply_parts a_parts11 b_parts11 (0l))))));;

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


let rec whitespace character2 = 
    (match character2 with
         | 32l -> 
            True
         | 13l -> 
            True
         | 9l -> 
            True
         | 10l -> 
            True
         | x185 -> 
            False);;

let rec atom_character character3 = 
    (match character3 with
         | 40l -> 
            False
         | 41l -> 
            False
         | x186 -> 
            (not (whitespace character3)));;

type range  = 
     | Range : int32 * int32 -> range;;

type sexp  = 
     | Symbol : int32 * string * range -> sexp
     | Integer : int32 * range -> sexp
     | List : (sexp) list * range -> sexp;;

let rec sexp_range sexp2 = 
    (match sexp2 with
         | (Symbol (x187, x188, range2)) -> 
            range2
         | (Integer (x189, range3)) -> 
            range3
         | (List (x190, range4)) -> 
            range4);;

let rec sexp_symbol_text sexp3 = 
    (match sexp3 with
         | (Symbol (x191, text, x192)) -> 
            (Some (text))
         | x193 -> 
            None);;

type parse_error  = 
     | ParseErrorTooFewClosingBrackets
     | ParseErrorTooManyClosingBrackets;;

type ('Tsymbol,'Tvalue23) parser_result  = 
     | ParserResult : int32 * (int32,('Tsymbol) dictionary) pair * 'Tvalue23 -> ('Tsymbol,'Tvalue23) parser_result
     | ParserError : parse_error -> ('Tsymbol,'Tvalue23) parser_result
     | ParserEnd : int32 -> ('Tsymbol,'Tvalue23) parser_result;;

let rec intern_string index10 next_index name symbol_state = 
    (match symbol_state with
         | (Pair (token, symbols)) -> 
            (match (dictionary_get name symbols) with
                 | (Some ((Pair (token2, name2)))) -> 
                    (ParserResult (next_index, symbol_state, (Symbol (token2, name2, (Range (index10, next_index))))))
                 | None -> 
                    (ParserResult (next_index, (Pair ((Int32.add token (1l)), (dictionary_set name (Pair (token, name)) symbols))), (Symbol (token, name, (Range (index10, next_index))))))));;

let rec parse_symbol index11 slice6 symbols2 = 
    (match (string_collect_from_slice atom_character index11 slice6) with
         | (Pair (next_index2, name3)) -> 
            (match (string_to_int32 name3) with
                 | (Some (integer4)) -> 
                    (ParserResult (next_index2, symbols2, (Integer (integer4, (Range (index11, next_index2))))))
                 | None -> 
                    (match (string_is_empty name3) with
                         | False -> 
                            (intern_string index11 next_index2 name3 symbols2)
                         | True -> 
                            (ParserEnd (index11)))));;

let rec parse_list index12 slice7 parse_sexps2 symbols3 = 
    (match (parse_sexps2 index12 slice7 symbols3 Empty) with
         | (ParserResult (next_index3, symbols4, expressions)) -> 
            (ParserResult (next_index3, symbols4, (List (expressions, (Range ((Int32.sub index12 (1l)), next_index3))))))
         | (ParserError (error7)) -> 
            (ParserError (error7))
         | (ParserEnd (index13)) -> 
            (ParserEnd (index13)));;

let rec parse_expression depth index14 slice8 parse_sexps3 symbols5 = 
    (match (x2 index14 (slice_size slice8)) with
         | False -> 
            (match depth with
                 | 0l -> 
                    (ParserEnd (index14))
                 | x194 -> 
                    (ParserError (ParseErrorTooFewClosingBrackets)))
         | True -> 
            (match (slice_get slice8 index14) with
                 | 40l -> 
                    (parse_list (Int32.add index14 (1l)) slice8 (parse_sexps3 (Int32.add depth (1l))) symbols5)
                 | 41l -> 
                    (match depth with
                         | 0l -> 
                            (ParserError (ParseErrorTooManyClosingBrackets))
                         | x195 -> 
                            (ParserEnd ((Int32.add index14 (1l)))))
                 | x196 -> 
                    (match (whitespace x196) with
                         | True -> 
                            (parse_expression depth (Int32.add index14 (1l)) slice8 parse_sexps3 symbols5)
                         | False -> 
                            (parse_symbol index14 slice8 symbols5))));;

let rec parse_sexps4 depth2 index15 slice9 symbols6 expressions2 = 
    (match (parse_expression depth2 index15 slice9 parse_sexps4 symbols6) with
         | (ParserResult (index16, symbols7, expression2)) -> 
            (parse_sexps4 depth2 index16 slice9 symbols7 (Cons (expression2, expressions2)))
         | (ParserError (error8)) -> 
            (ParserError (error8))
         | (ParserEnd (index17)) -> 
            (ParserResult (index17, symbols6, (list_reverse expressions2))));;

let rec parse_sexps symbols8 slice10 = 
    (match (parse_sexps4 (0l) (0l) slice10 symbols8 Empty) with
         | (ParserResult (x197, symbols9, expressions3)) -> 
            (Result ((Pair (symbols9, expressions3))))
         | (ParserError (error9)) -> 
            (Error (error9))
         | (ParserEnd (x198)) -> 
            (Error (ParseErrorTooFewClosingBrackets)));;

let rec wrap_in_brackets string34 = 
    (string_concat (string_of_char (40l)) (string_concat string34 (string_of_char (41l))));;

let rec stringify_sexp2 stringify_sexps2 expression3 = 
    (match expression3 with
         | (Symbol (x199, name4, x200)) -> 
            name4
         | (Integer (integer5, x201)) -> 
            (string_from_int32 integer5)
         | (List (expressions4, x202)) -> 
            (wrap_in_brackets (stringify_sexps2 expressions4)));;

let rec stringify_sexps expressions5 = 
    (string_join (string_of_char (32l)) (list_map (stringify_sexp2 stringify_sexps) expressions5));;

let rec stringify_sexp expression4 = 
    (stringify_sexp2 stringify_sexps expression4);;

let rec parts_are_empty parts8 = 
    (match parts8 with
         | Empty -> 
            True
         | (Cons (part, Empty)) -> 
            (string_is_empty part)
         | x203 -> 
            False);;

let rec transform_line line2 = 
    (match (string_split (124l) line2) with
         | (Cons (name5, parts9)) -> 
            (string_concat (string_from_list (Cons ((40l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((32l),Cons ((100l),Cons ((97l),Cons ((116l),Cons ((97l),Cons ((45l),Empty)))))))))))) (string_concat (string_trim name5) (string_concat (string_from_list (Cons ((32l),Cons ((40l),Cons ((41l),Cons ((32l),Cons ((40l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((105l),Cons ((110l),Cons ((103l),Empty))))))))))))) (string_concat (string_from_list (Cons ((45l),Cons ((102l),Cons ((114l),Cons ((111l),Cons ((109l),Cons ((45l),Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((32l),Empty))))))))))))) (match (parts_are_empty parts9) with
                 | True -> 
                    (string_from_list (Cons ((69l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Cons ((41l),Cons ((41l),Empty)))))))))
                 | False -> 
                    (string_concat (string_from_list (Cons ((40l),Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((32l),Empty)))))))) (string_concat (string_join (string_of_char (32l)) (list_map string_from_int32 (string_to_list (string_join (string_of_char (124l)) parts9)))) (string_from_list (Cons ((41l),Cons ((41l),Cons ((41l),Empty))))))))))))
         | Empty -> 
            (string_empty ()));;

let rec string_gen stdin_iterator = 
    (match (string_collect_from_slice (const True) (0l) stdin_iterator) with
         | (Pair (x204, stdin)) -> 
            (Result ((string_join (string_of_char (10l)) (list_map transform_line (string_split (10l) stdin))))));;

let rec data_strings_file_ending () = 
    (string_from_list (Cons ((46l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((115l),Empty))))))))));;

let rec data_reuse_file_ending () = 
    (string_from_list (Cons ((46l),Cons ((114l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Empty))))))));;

type module_reference  = 
     | ModulePath : string * boolean -> module_reference
     | ModuleSelf
     | ModuleInternal;;

type source_reference  = 
     | SourceReference : int32 * string * module_reference -> source_reference;;

type source_file  = 
     | SourceFile : source_reference * slice' -> source_file;;

type source_file_type  = 
     | SourceFileTypeReuse
     | SourceFileTypeStrings
     | SourceFileTypeTargetLanguage;;

let rec module_equal a64 b60 = 
    (match a64 with
         | (ModulePath (a65, x205)) -> 
            (match b60 with
                 | (ModulePath (b61, x206)) -> 
                    (string_equal a65 b61)
                 | x207 -> 
                    False)
         | ModuleSelf -> 
            (match b60 with
                 | ModuleSelf -> 
                    True
                 | x208 -> 
                    False)
         | ModuleInternal -> 
            (match b60 with
                 | ModuleInternal -> 
                    True
                 | x209 -> 
                    False));;

let rec source_reference_file_index source_reference2 = 
    (match source_reference2 with
         | (SourceReference (file_index, x210, x211)) -> 
            file_index);;

let rec source_reference_file_path source_reference3 = 
    (match source_reference3 with
         | (SourceReference (x212, file_path, x213)) -> 
            file_path);;

let rec source_reference_module source_reference4 = 
    (match source_reference4 with
         | (SourceReference (x214, x215, module2)) -> 
            module2);;

let rec source_reference_equal a66 b62 = 
    (x4 (source_reference_file_index a66) (source_reference_file_index b62));;

let rec source_file_of module3 path iterator9 index18 = 
    (SourceFile ((SourceReference (index18, path, module3)), iterator9));;

let rec source_file_module file = 
    (match file with
         | (SourceFile (reference, x216)) -> 
            (source_reference_module reference));;

let rec source_file_path file2 = 
    (match file2 with
         | (SourceFile (reference2, x217)) -> 
            (source_reference_file_path reference2));;

let rec source_file_content file3 = 
    (match file3 with
         | (SourceFile (x218, content)) -> 
            content);;

let rec source_file_size file4 = 
    (match file4 with
         | (SourceFile (x219, content2)) -> 
            (slice_size content2));;

let rec source_file_index file5 = 
    (match file5 with
         | (SourceFile (reference3, x220)) -> 
            (source_reference_file_index reference3));;

let rec source_file_reference file6 = 
    (match file6 with
         | (SourceFile (reference4, x221)) -> 
            reference4);;

let rec source_file_in_same_module a67 b63 = 
    (module_equal (source_file_module a67) (source_file_module b63));;

let rec last_n_chars n7 path2 = 
    (string_substring (Int32.sub (string_size path2) n7) n7 path2);;

let rec is_reuse_source file7 = 
    (string_equal (last_n_chars (6l) (source_file_path file7)) (data_reuse_file_ending ()));;

let rec is_strings_source file8 = 
    (string_equal (last_n_chars (8l) (source_file_path file8)) (data_strings_file_ending ()));;

let rec source_file_type2 file9 = 
    (match (is_reuse_source file9) with
         | True -> 
            SourceFileTypeReuse
         | False -> 
            (match (is_strings_source file9) with
                 | True -> 
                    SourceFileTypeStrings
                 | False -> 
                    SourceFileTypeTargetLanguage));;

type definition_kind  = 
     | PublicFunctionDefinition
     | PublicTypeDefinition
     | PublicConstructorDefinition
     | PrivateFunctionDefinition
     | PrivateTypeDefinition
     | PrivateConstructorDefinition
     | VariableDefinition
     | TypeVariableDefinition;;

type identifier_universe  = 
     | TypeUniverse
     | ValueUniverse;;

type ('Tidentifier2) identifier_reference  = 
     | Resolved : 'Tidentifier2 -> ('Tidentifier2) identifier_reference
     | Definition : int32 * definition_kind -> ('Tidentifier2) identifier_reference;;

type identifier  = 
     | Identifier : ((identifier) identifier_reference) maybe * identifier_universe * string * source_reference * range -> identifier;;

type ast_type  = 
     | SimpleType : identifier -> ast_type
     | ComplexType : identifier * (ast_type) list * range -> ast_type
     | FunctionType : (ast_type) list * ast_type * range -> ast_type;;

type type_parameter  = 
     | UniversalParameter : identifier -> type_parameter
     | ExistentialParameter : identifier -> type_parameter;;

type constructor  = 
     | SimpleConstructor : identifier -> constructor
     | ComplexConstructor : identifier * (ast_type) list * range -> constructor;;

type pattern  = 
     | Capture : identifier -> pattern
     | IntegerPattern : int32 * range -> pattern
     | ConstructorPattern : identifier * (pattern) list * range -> pattern;;

type expression  = 
     | IntegerConstant : int32 * range -> expression
     | Variable : identifier -> expression
     | Lambda : (identifier) list * expression * range -> expression
     | Match : expression * ((pattern,expression) pair) list * range -> expression
     | Constructor : identifier * (expression) list * range -> expression
     | FunctionApplication : (expression) list * range -> expression
     | ListExpression : (expression) list * range -> expression
     | Pipe : (expression) list * range -> expression
     | Compose : (expression) list * range -> expression;;

type definition  = 
     | TypeDefinition : identifier * boolean * (type_parameter) list * (constructor) list * range -> definition
     | FunctionDefinition : identifier * boolean * (identifier) list * expression * range -> definition
     | TargetDefinition : source_reference * slice' -> definition;;

let rec identifier_universe_from_kind kind = 
    (match kind with
         | PublicFunctionDefinition -> 
            ValueUniverse
         | PublicConstructorDefinition -> 
            ValueUniverse
         | PublicTypeDefinition -> 
            TypeUniverse
         | PrivateFunctionDefinition -> 
            ValueUniverse
         | PrivateConstructorDefinition -> 
            ValueUniverse
         | PrivateTypeDefinition -> 
            TypeUniverse
         | VariableDefinition -> 
            ValueUniverse
         | TypeVariableDefinition -> 
            TypeUniverse);;

let rec identifier_definition identifier3 = 
    (match identifier3 with
         | (Identifier ((Some ((Resolved ((Identifier ((Some ((Definition (id2, kind2)))), x222, x223, x224, x225)))))), x226, x227, x228, x229)) -> 
            (Some ((Definition (id2, kind2))))
         | (Identifier ((Some ((Definition (id3, kind3)))), x230, x231, x232, x233)) -> 
            (Some ((Definition (id3, kind3))))
         | x234 -> 
            None);;

let rec identifier_id identifier4 = 
    (match (identifier_definition identifier4) with
         | (Some ((Definition (id4, x235)))) -> 
            (Some (id4))
         | x236 -> 
            None);;

let rec identifier_name identifier5 = 
    (match identifier5 with
         | (Identifier (x237, x238, name6, x239, x240)) -> 
            name6);;

let rec identifier_with_name name7 identifier6 = 
    (match identifier6 with
         | (Identifier (x241, x242, x243, x244, x245)) -> 
            (Identifier (x241, x242, name7, x244, x245)));;

let rec identifier_source_reference identifier7 = 
    (match identifier7 with
         | (Identifier (x246, x247, x248, source_reference5, x249)) -> 
            source_reference5);;

let rec identifier_module identifier8 = 
    (source_reference_module (identifier_source_reference identifier8));;

let rec identifier_range identifier9 = 
    (match identifier9 with
         | (Identifier (x250, x251, x252, x253, range5)) -> 
            range5);;

let rec identifier_public identifier10 = 
    (match (identifier_definition identifier10) with
         | (Some ((Definition (x254, PublicFunctionDefinition)))) -> 
            True
         | (Some ((Definition (x255, PublicTypeDefinition)))) -> 
            True
         | (Some ((Definition (x256, PublicConstructorDefinition)))) -> 
            True
         | x257 -> 
            False);;

let rec identifier_universe2 identifier11 = 
    (match identifier11 with
         | (Identifier (x258, universe, x259, x260, x261)) -> 
            universe);;

let rec identifier_is id5 identifier12 = 
    (maybe_or_else False (maybe_map (x4 id5) (identifier_id identifier12)));;

let rec identifier_equal a68 b64 = 
    (maybe_or_else (source_reference_equal (identifier_source_reference a68) (identifier_source_reference b64)) (maybe_map ((flip identifier_is) b64) (identifier_id a68)));;

let rec identifier_from_definition id6 kind4 text2 source_reference6 range6 = 
    (Identifier ((Some ((Definition (id6, kind4)))), (identifier_universe_from_kind kind4), text2, source_reference6, range6));;

let rec identifier_resolved defined_identifier source_reference7 range7 = 
    (Identifier ((Some ((Resolved (defined_identifier)))), (identifier_universe2 defined_identifier), (identifier_name defined_identifier), source_reference7, range7));;

let rec identifier_unresolved universe2 text3 source_reference8 range8 = 
    (Identifier (None, universe2, text3, source_reference8, range8));;

let rec definition_source_reference definition2 = 
    (match definition2 with
         | (TypeDefinition (identifier13, x262, x263, x264, x265)) -> 
            (identifier_source_reference identifier13)
         | (FunctionDefinition (identifier14, x266, x267, x268, x269)) -> 
            (identifier_source_reference identifier14)
         | (TargetDefinition (source_reference9, x270)) -> 
            source_reference9);;

let rec definition_module definition3 = 
    (source_reference_module (definition_source_reference definition3));;

let rec definition_public definition4 = 
    (match definition4 with
         | (TypeDefinition (x271, public, x272, x273, x274)) -> 
            public
         | (FunctionDefinition (x275, public2, x276, x277, x278)) -> 
            public2
         | (TargetDefinition (x279, x280)) -> 
            False);;

let rec definition_identifier definition5 = 
    (match definition5 with
         | (TypeDefinition (identifier15, x281, x282, x283, x284)) -> 
            (Some (identifier15))
         | (FunctionDefinition (identifier16, x285, x286, x287, x288)) -> 
            (Some (identifier16))
         | (TargetDefinition (x289, x290)) -> 
            None);;

let rec constructor_identifier constructor2 = 
    (match constructor2 with
         | (ComplexConstructor (identifier17, x291, x292)) -> 
            identifier17
         | (SimpleConstructor (identifier18)) -> 
            identifier18);;

let rec type_parameter_identifier parameter = 
    (match parameter with
         | (UniversalParameter (identifier19)) -> 
            identifier19
         | (ExistentialParameter (identifier20)) -> 
            identifier20);;

let rec captured_identifiers_from_pattern pattern2 = 
    (match pattern2 with
         | (Capture (identifier21)) -> 
            (Cons (identifier21,Empty))
         | (ConstructorPattern (x293, patterns, x294)) -> 
            (list_flatmap captured_identifiers_from_pattern patterns)
         | x295 -> 
            Empty);;

let rec identifiers_from_definition definition6 = 
    (match definition6 with
         | (TypeDefinition (name8, x296, x297, constructors, x298)) -> 
            (Cons (name8, (list_map constructor_identifier constructors)))
         | (FunctionDefinition (name9, x299, arguments, x300, x301)) -> 
            (Cons (name9, Empty))
         | (TargetDefinition (x302, x303)) -> 
            Empty);;

let rec public_identifiers definitions = 
    (definitions |> (list_filter definition_public) |> (list_map definition_identifier) |> (list_flatmap list_from_maybe));;

let rec over_match_pair_expression f44 pair9 = 
    (match pair9 with
         | (Pair (pattern3, expression5)) -> 
            (result_bind (f44 expression5) (fun expression6 -> (result_return (Pair (pattern3, expression6))))));;

let rec over_match_pair_expressions over_subexpressions2 f45 pairs = 
    (result_concat (list_map (over_match_pair_expression (fun x' -> x' |> f45 |> (result_flatmap (over_subexpressions2 f45)))) pairs));;

let rec over_subexpressions f46 expression7 = 
    (result_bind (f46 expression7) (fun expression8 -> (match expression8 with
         | (Lambda (arguments2, expression9, range9)) -> 
            (result_bind (f46 expression9) (fun expression10 -> (result_bind (over_subexpressions f46 expression10) (fun expression11 -> (result_return (Lambda (arguments2, expression11, range9)))))))
         | (Match (expression12, pairs2, range10)) -> 
            (result_bind (f46 expression12) (fun expression13 -> (result_bind (over_subexpressions f46 expression13) (fun expression14 -> (result_bind (over_match_pair_expressions over_subexpressions f46 pairs2) (fun pairs3 -> (result_return (Match (expression14, pairs3, range10)))))))))
         | (Constructor (identifier22, expressions6, range11)) -> 
            (result_bind (result_concat (list_map (fun x' -> x' |> f46 |> (result_flatmap (over_subexpressions f46))) expressions6)) (fun expressions7 -> (result_return (Constructor (identifier22, expressions7, range11)))))
         | (FunctionApplication (expressions8, range12)) -> 
            (result_bind (result_concat (list_map (fun x' -> x' |> f46 |> (result_flatmap (over_subexpressions f46))) expressions8)) (fun expressions9 -> (result_return (FunctionApplication (expressions9, range12)))))
         | (ListExpression (expressions10, range13)) -> 
            (result_bind (result_concat (list_map (fun x' -> x' |> f46 |> (result_flatmap (over_subexpressions f46))) expressions10)) (fun expressions11 -> (result_return (ListExpression (expressions11, range13)))))
         | (Pipe (expressions12, range14)) -> 
            (result_bind (result_concat (list_map (fun x' -> x' |> f46 |> (result_flatmap (over_subexpressions f46))) expressions12)) (fun expressions13 -> (result_return (Pipe (expressions13, range14)))))
         | (Compose (expressions14, range15)) -> 
            (result_bind (result_concat (list_map (fun x' -> x' |> f46 |> (result_flatmap (over_subexpressions f46))) expressions14)) (fun expressions15 -> (result_return (Compose (expressions15, range15)))))
         | x304 -> 
            (result_return expression8))));;

let rec over_definition_expressions f47 definition7 = 
    (match definition7 with
         | (FunctionDefinition (identifier23, public3, arguments3, expression15, range16)) -> 
            (result_bind (f47 expression15) (fun expression16 -> (result_return (FunctionDefinition (identifier23, public3, arguments3, expression16, range16)))))
         | x305 -> 
            (result_return definition7));;

let rec over_function_application f48 expression17 = 
    (match expression17 with
         | (FunctionApplication (expressions16, range17)) -> 
            (f48 expressions16 range17)
         | x306 -> 
            (result_return expression17));;

let rec over_match_expression f49 expression18 = 
    (match expression18 with
         | (Match (expression19, pairs4, range18)) -> 
            (f49 expression19 pairs4 range18)
         | x307 -> 
            (result_return expression18));;

let rec over_match_pattern_identifiers f50 pattern4 = 
    (match pattern4 with
         | (ConstructorPattern (identifier24, patterns2, range19)) -> 
            (result_bind (result_concat (list_map (over_match_pattern_identifiers f50) patterns2)) (fun patterns3 -> (result_bind (f50 identifier24) (fun identifier25 -> (result_return (ConstructorPattern (identifier25, patterns3, range19)))))))
         | x308 -> 
            (result_return pattern4));;

let rec over_match_rule_identifiers over_identifiers2 f51 rule = 
    (match rule with
         | (Pair (pattern5, expression20)) -> 
            (result_bind (over_match_pattern_identifiers f51 pattern5) (fun pattern6 -> (result_bind (over_identifiers2 f51 expression20) (fun expression21 -> (result_return (Pair (pattern6, expression21))))))));;

let rec over_identifiers f52 expression22 = 
    (match expression22 with
         | (Variable (name10)) -> 
            (result_bind (f52 name10) (fun name11 -> (result_return (Variable (name11)))))
         | (Lambda (arguments4, expression23, range20)) -> 
            (result_bind (over_identifiers f52 expression23) (fun expression24 -> (result_bind (result_concat (list_map f52 arguments4)) (fun arguments5 -> (result_return (Lambda (arguments5, expression24, range20)))))))
         | (Constructor (name12, Empty, range21)) -> 
            (result_bind (f52 name12) (fun name13 -> (result_return (Constructor (name13, Empty, range21)))))
         | (Constructor (name14, expressions17, range22)) -> 
            (result_bind (result_concat (list_map (over_identifiers f52) expressions17)) (fun expressions18 -> (result_bind (f52 name14) (fun name15 -> (result_return (Constructor (name15, expressions18, range22)))))))
         | (FunctionApplication (expressions19, range23)) -> 
            (result_bind (result_concat (list_map (over_identifiers f52) expressions19)) (fun expressions20 -> (result_return (FunctionApplication (expressions20, range23)))))
         | (Match (expression25, rules, range24)) -> 
            (result_bind (result_concat (list_map (over_match_rule_identifiers over_identifiers f52) rules)) (fun rules2 -> (result_bind (over_identifiers f52 expression25) (fun expression26 -> (result_return (Match (expression26, rules2, range24)))))))
         | (ListExpression (expressions21, range25)) -> 
            (result_bind (result_concat (list_map (over_identifiers f52) expressions21)) (fun expressions22 -> (result_return (ListExpression (expressions22, range25)))))
         | (Pipe (expressions23, range26)) -> 
            (result_bind (result_concat (list_map (over_identifiers f52) expressions23)) (fun expressions24 -> (result_return (Pipe (expressions24, range26)))))
         | (Compose (expressions25, range27)) -> 
            (result_bind (result_concat (list_map (over_identifiers f52) expressions25)) (fun expressions26 -> (result_return (Compose (expressions26, range27)))))
         | x309 -> 
            (result_return expression22));;

let rec over_identifiers_in_type f53 type2 = 
    (match type2 with
         | (SimpleType (identifier26)) -> 
            (result_bind (f53 identifier26) (fun identifier27 -> (result_return (SimpleType (identifier27)))))
         | (ComplexType (identifier28, types, range28)) -> 
            (result_bind (f53 identifier28) (fun identifier29 -> (result_bind (result_concat (list_map (over_identifiers_in_type f53) types)) (fun types2 -> (result_return (ComplexType (identifier29, types2, range28)))))))
         | (FunctionType (types3, result_type, range29)) -> 
            (result_bind (over_identifiers_in_type f53 result_type) (fun result_type2 -> (result_bind (result_concat (list_map (over_identifiers_in_type f53) types3)) (fun types4 -> (result_return (FunctionType (types4, result_type2, range29))))))));;

let rec over_identifiers_in_constructor f54 constructor3 = 
    (match constructor3 with
         | (SimpleConstructor (identifier30)) -> 
            (result_bind (f54 identifier30) (fun identifier31 -> (result_return (SimpleConstructor (identifier31)))))
         | (ComplexConstructor (identifier32, types5, range30)) -> 
            (result_bind (f54 identifier32) (fun identifier33 -> (result_bind (result_concat (list_map (over_identifiers_in_type f54) types5)) (fun types6 -> (result_return (ComplexConstructor (identifier33, types6, range30))))))));;

let rec expression_calls_function_in_tail_position name16 expression27 = 
    (match expression27 with
         | (FunctionApplication ((Cons ((Variable (f55)), rest15)), x310)) -> 
            (identifier_equal name16 f55)
         | (Match (x311, rules3, x312)) -> 
            (list_any (fun pair10 -> (match pair10 with
                 | (Pair (pattern7, expression28)) -> 
                    (and2 (not (list_any (identifier_equal name16) (captured_identifiers_from_pattern pattern7))) (expression_calls_function_in_tail_position name16 expression28)))) rules3)
         | x313 -> 
            False);;

let rec any_captures_match name17 pattern8 = 
    (list_any (identifier_equal name17) (captured_identifiers_from_pattern pattern8));;

let rec over_tail_recursive_match_rule name18 f56 over_tail_recursive_call2 rule2 = 
    (match rule2 with
         | (Pair (pattern9, expression29)) -> 
            (match (any_captures_match name18 pattern9) with
                 | True -> 
                    (Pair (pattern9, expression29))
                 | False -> 
                    (Pair (pattern9, (over_tail_recursive_call2 name18 f56 expression29)))));;

let rec over_tail_recursive_call name19 f57 expression30 = 
    (match expression30 with
         | (FunctionApplication ((Cons ((Variable (applied_name)), rest16)), range31)) -> 
            (match (identifier_equal name19 applied_name) with
                 | True -> 
                    (f57 rest16 range31)
                 | False -> 
                    expression30)
         | (Match (expression31, rules4, range32)) -> 
            (Match (expression31, (list_map (over_tail_recursive_match_rule name19 f57 over_tail_recursive_call) rules4), range32))
         | x314 -> 
            expression30);;

let rec data_def () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Empty)))));;

let rec data_typ () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Empty)))));;

let rec data_fn () = 
    (string_from_list (Cons ((102l),Cons ((110l),Empty))));;

let rec data_match () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_exists () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((115l),Empty))))))));;

let rec data_pub () = 
    (string_from_list (Cons ((112l),Cons ((117l),Cons ((98l),Empty)))));;

let rec data_ () = 
    (string_from_list (Cons ((43l),Empty)));;

let rec data__ () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_2 () = 
    (string_from_list (Cons ((42l),Empty)));;

let rec data_3 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec data_4 () = 
    (string_from_list (Cons ((37l),Empty)));;

let rec data_5 () = 
    (string_from_list (Cons ((38l),Empty)));;

let rec data_int32_less_than () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((45l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((45l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((110l),Empty)))))))))))))))));;

let rec data_pipe () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_dot () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_list () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_slice_empty () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))))))))));;

let rec data_slice_of_u8 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((117l),Cons ((56l),Empty)))))))))))));;

let rec data_slice_size () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Empty))))))))))));;

let rec data_slice_get () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((103l),Cons ((101l),Cons ((116l),Empty)))))))))));;

let rec data_slice_concat () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((99l),Cons ((97l),Cons ((116l),Empty))))))))))))));;

let rec data_slice_foldl () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((100l),Cons ((108l),Empty)))))))))))));;

let rec data_slice_subslice () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((117l),Cons ((98l),Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty))))))))))))))));;

let rec data_slice () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_int32 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec symbol_def () = 
    (-1l);;

let rec symbol_typ () = 
    (-2l);;

let rec symbol_fn () = 
    (-3l);;

let rec symbol_match () = 
    (-4l);;

let rec symbol_exists () = 
    (-5l);;

let rec symbol_pub () = 
    (-6l);;

let rec identifier_ () = 
    (-7l);;

let rec identifier__ () = 
    (-8l);;

let rec identifier_2 () = 
    (-9l);;

let rec identifier_3 () = 
    (-10l);;

let rec identifier_4 () = 
    (-11l);;

let rec identifier_5 () = 
    (-12l);;

let rec identifier_int32_less_than () = 
    (-13l);;

let rec identifier_list () = 
    (-14l);;

let rec identifier_pipe () = 
    (-15l);;

let rec identifier_dot () = 
    (-16l);;

let rec identifier_slice_empty () = 
    (-17l);;

let rec identifier_slice_of_u8 () = 
    (-18l);;

let rec identifier_slice_size () = 
    (-19l);;

let rec identifier_slice_get () = 
    (-20l);;

let rec identifier_slice_concat () = 
    (-21l);;

let rec identifier_slice_foldl () = 
    (-22l);;

let rec identifier_slice_subslice () = 
    (-23l);;

let rec identifier_int32 () = 
    (-24l);;

let rec identifier_slice () = 
    (-25l);;

let rec identifier_is_operator identifier34 = 
    (maybe_or_else False (maybe_bind (identifier_id identifier34) (fun id7 -> (maybe_return (and2 (x5 id7 (-7l)) (x6 id7 (-12l)))))));;

let rec predefined_identifier text4 id8 kind5 = 
    (Identifier ((Some ((Definition ((id8 ()), kind5)))), (identifier_universe_from_kind kind5), (text4 ()), (SourceReference ((-1l), (string_empty ()), ModuleInternal)), (Range ((0l), (0l)))));;

let rec predefined_identifiers () = 
    (Cons ((predefined_identifier data_ identifier_ PrivateFunctionDefinition),Cons ((predefined_identifier data__ identifier__ PrivateFunctionDefinition),Cons ((predefined_identifier data_2 identifier_2 PrivateFunctionDefinition),Cons ((predefined_identifier data_3 identifier_3 PrivateFunctionDefinition),Cons ((predefined_identifier data_4 identifier_4 PrivateFunctionDefinition),Cons ((predefined_identifier data_5 identifier_5 PrivateFunctionDefinition),Cons ((predefined_identifier data_int32_less_than identifier_int32_less_than PrivateFunctionDefinition),Cons ((predefined_identifier data_list identifier_list PrivateFunctionDefinition),Cons ((predefined_identifier data_pipe identifier_pipe PrivateFunctionDefinition),Cons ((predefined_identifier data_dot identifier_dot PrivateFunctionDefinition),Cons ((predefined_identifier data_slice_empty identifier_slice_empty PrivateFunctionDefinition),Cons ((predefined_identifier data_slice_of_u8 identifier_slice_of_u8 PrivateFunctionDefinition),Cons ((predefined_identifier data_slice_size identifier_slice_size PrivateFunctionDefinition),Cons ((predefined_identifier data_slice_get identifier_slice_get PrivateFunctionDefinition),Cons ((predefined_identifier data_slice_concat identifier_slice_concat PrivateFunctionDefinition),Cons ((predefined_identifier data_slice_foldl identifier_slice_foldl PrivateFunctionDefinition),Cons ((predefined_identifier data_slice_subslice identifier_slice_subslice PrivateFunctionDefinition),Cons ((predefined_identifier data_int32 identifier_int32 PrivateTypeDefinition),Cons ((predefined_identifier data_slice identifier_slice PrivateTypeDefinition),Empty))))))))))))))))))));;

let rec predefined_identifier_to_symbol identifier35 = 
    (pair_cons (maybe_or_else (-1l) (identifier_id identifier35)) (identifier_name identifier35));;

let rec max_symbol_id symbols10 = 
    (list_foldl (fun x315 xs28 -> (max xs28 (pair_left x315))) (0l) symbols10);;

let rec symbol_state2 symbols11 = 
    (Pair ((Int32.add (max_symbol_id symbols11) (1l)), (dictionary_of (list_map (fun x316 -> (Pair ((pair_right x316), x316))) symbols11))));;

let rec predefined_symbols () = 
    (symbol_state2 (list_concat (Cons ((Pair ((symbol_def ()), (data_def ()))),Cons ((Pair ((symbol_typ ()), (data_typ ()))),Cons ((Pair ((symbol_fn ()), (data_fn ()))),Cons ((Pair ((symbol_match ()), (data_match ()))),Cons ((Pair ((symbol_exists ()), (data_exists ()))),Cons ((Pair ((symbol_pub ()), (data_pub ()))),Empty))))))) (list_map predefined_identifier_to_symbol (predefined_identifiers ()))));;

type error  = 
     | InternalParserError : source_reference * range -> error
     | MalformedExpressionError : source_reference * range -> error
     | MalformedDefinitionError : source_reference * range -> error
     | MalformedTypeDefinitionError : source_reference * range -> error
     | TypeDefinitionMissingName : source_reference * range -> error
     | TypeDefinitionMissingConstructors : source_reference * range -> error
     | MalformedFunctionDefinitionError : source_reference * range -> error
     | FunctionDefinitionMissingName : source_reference * range -> error
     | MalformedPatternError : source_reference * range -> error
     | MalformedMatchExpressionError : source_reference * range -> error
     | MalformedSymbolError : source_reference * range -> error
     | MalformedConstructorError : source_reference * range -> error
     | MalformedTypeError : source_reference * range -> error
     | ErrorNotDefined : string * source_reference * range -> error
     | ErrorNotAccessible : string * source_reference * range -> error
     | ErrorAlreadyDefined : string * source_reference * range -> error
     | ErrorReservedIdentifier : string * source_reference * range -> error
     | MalformedSexpTooFewClosingBrackets
     | MalformedSexpTooManyClosingBrackets;;

let rec malformed_function_definition source_reference10 range33 = 
    (MalformedFunctionDefinitionError (source_reference10, range33));;

let rec malformed_type_definition source_reference11 range34 = 
    (MalformedTypeDefinitionError (source_reference11, range34));;

let rec malformed_type source_reference12 range35 = 
    (MalformedTypeError (source_reference12, range35));;

let rec malformed_pattern source_reference13 range36 = 
    (MalformedPatternError (source_reference13, range36));;

let rec not_defined text5 source_reference14 range37 = 
    (match text5 with
         | (Some (text6)) -> 
            (ErrorNotDefined (text6, source_reference14, range37))
         | None -> 
            (InternalParserError (source_reference14, range37)));;

let rec identifier_to_symbol identifier36 = 
    (match identifier36 with
         | (Identifier (x317, x318, name20, x319, range38)) -> 
            (Symbol ((0l), name20, range38)));;

let rec type_to_sexp types_to_sexp type3 = 
    (match type3 with
         | (SimpleType (identifier37)) -> 
            (identifier_to_symbol identifier37)
         | (FunctionType (arg_types, return_type, range39)) -> 
            (List ((Cons ((Symbol ((symbol_fn ()), (data_fn ()), range39)),Cons ((List ((types_to_sexp arg_types), range39)),Cons ((type_to_sexp types_to_sexp return_type),Empty)))), range39))
         | (ComplexType (identifier38, types7, range40)) -> 
            (List ((Cons ((identifier_to_symbol identifier38), (types_to_sexp types7))), range40)));;

let rec types_to_sexp2 types8 = 
    (list_map (type_to_sexp types_to_sexp2) types8);;

let rec constructor_to_sexp constructor4 = 
    (match constructor4 with
         | (SimpleConstructor (identifier39)) -> 
            (identifier_to_symbol identifier39)
         | (ComplexConstructor (identifier40, types9, range41)) -> 
            (List ((Cons ((identifier_to_symbol identifier40), (types_to_sexp2 types9))), range41)));;

let rec constructors_to_sexp constructors2 = 
    (list_map constructor_to_sexp constructors2);;

let rec type_parameter_to_sexp parameter2 = 
    (match parameter2 with
         | (ExistentialParameter (identifier41)) -> 
            (List ((Cons ((Symbol ((symbol_exists ()), (data_exists ()), (identifier_range identifier41))),Cons ((identifier_to_symbol identifier41),Empty))), (identifier_range identifier41)))
         | (UniversalParameter (identifier42)) -> 
            (identifier_to_symbol identifier42));;

let rec type_name_to_sexp id9 range42 name21 parameters = 
    (match parameters with
         | Empty -> 
            (Symbol (id9, name21, range42))
         | x320 -> 
            (List ((Cons ((Symbol (id9, name21, range42)), (list_map type_parameter_to_sexp parameters))), range42)));;

let rec function_arguments_to_sexp arguments6 range43 = 
    (List ((list_map identifier_to_symbol arguments6), range43));;

let rec pattern_to_sexp pattern10 = 
    (match pattern10 with
         | (ConstructorPattern (identifier43, Empty, x321)) -> 
            (identifier_to_symbol identifier43)
         | (ConstructorPattern (identifier44, patterns4, range44)) -> 
            (List ((Cons ((identifier_to_symbol identifier44), (list_map pattern_to_sexp patterns4))), range44))
         | (IntegerPattern (value24, range45)) -> 
            (Integer (value24, range45))
         | (Capture (identifier45)) -> 
            (identifier_to_symbol identifier45));;

let rec match_pair_to_sexp expression_to_sexp2 pair11 = 
    (match pair11 with
         | (Pair (pattern11, expression32)) -> 
            (Cons ((pattern_to_sexp pattern11),Cons ((expression_to_sexp2 expression32),Empty))));;

let rec expression_to_sexp expression33 = 
    (match expression33 with
         | (IntegerConstant (integer6, range46)) -> 
            (Integer (integer6, range46))
         | (Variable ((Identifier (x322, x323, string35, x324, range47)))) -> 
            (Symbol ((0l), string35, range47))
         | (Lambda (arguments7, expression34, range48)) -> 
            (List ((Cons ((Symbol ((symbol_fn ()), (data_fn ()), range48)),Cons ((function_arguments_to_sexp arguments7 range48),Cons ((expression_to_sexp expression34),Empty)))), range48))
         | (Match (expression35, pairs5, range49)) -> 
            (List ((Cons ((Symbol ((symbol_match ()), (data_match ()), range49)), (Cons ((expression_to_sexp expression35), (list_flatmap (match_pair_to_sexp expression_to_sexp) pairs5))))), range49))
         | (Constructor (identifier46, expressions27, range50)) -> 
            (match expressions27 with
                 | Empty -> 
                    (identifier_to_symbol identifier46)
                 | x325 -> 
                    (List ((Cons ((identifier_to_symbol identifier46), (list_map expression_to_sexp expressions27))), range50)))
         | (FunctionApplication (expressions28, range51)) -> 
            (List ((list_map expression_to_sexp expressions28), range51))
         | (ListExpression (expressions29, range52)) -> 
            (List ((Cons ((Symbol ((identifier_list ()), (data_list ()), range52)), (list_map expression_to_sexp expressions29))), range52))
         | (Pipe (expressions30, range53)) -> 
            (List ((Cons ((Symbol ((identifier_pipe ()), (data_pipe ()), range53)), (list_map expression_to_sexp expressions30))), range53))
         | (Compose (expressions31, range54)) -> 
            (List ((Cons ((Symbol ((identifier_dot ()), (data_dot ()), range54)), (list_map expression_to_sexp expressions31))), range54)));;

let rec type_definition_to_sexp id10 name22 parameters2 constructors3 range55 = 
    (list_concat (Cons ((Symbol ((symbol_typ ()), (data_typ ()), range55)),Cons ((type_name_to_sexp id10 range55 name22 parameters2),Empty))) (constructors_to_sexp constructors3));;

let rec function_definition_to_sexp name23 arguments8 expression36 range56 = 
    (Cons ((Symbol ((symbol_def ()), (data_def ()), range56)),Cons ((identifier_to_symbol name23),Cons ((function_arguments_to_sexp arguments8 range56),Cons ((expression_to_sexp expression36),Empty)))));;

let rec definition_to_sexp2 public4 range57 sexp4 = 
    (List ((match public4 with
         | True -> 
            (Cons ((Symbol ((symbol_pub ()), (data_pub ()), range57)), sexp4))
         | False -> 
            sexp4), range57));;

let rec definition_to_sexp definition8 = 
    (match definition8 with
         | (TypeDefinition ((Identifier (x326, x327, name24, x328, x329)), public5, parameters3, constructors4, range58)) -> 
            (definition_to_sexp2 public5 range58 (type_definition_to_sexp (0l) name24 parameters3 constructors4 range58))
         | (FunctionDefinition (name25, public6, arguments9, expression37, range59)) -> 
            (definition_to_sexp2 public6 range59 (function_definition_to_sexp name25 arguments9 expression37 range59))
         | (TargetDefinition (x330, data)) -> 
            (Symbol ((0l), (string_from_slice data), (Range ((0l), (0l))))));;

let rec definitions_to_sexps definitions2 = 
    (list_map definition_to_sexp definitions2);;

let rec data_6 () = 
    (string_from_list (Cons ((43l),Empty)));;

let rec data__2 () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_7 () = 
    (string_from_list (Cons ((42l),Empty)));;

let rec data_8 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec data_9 () = 
    (string_from_list (Cons ((37l),Empty)));;

let rec data_10 () = 
    (string_from_list (Cons ((38l),Empty)));;

let rec data_int32_less_than2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((45l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((45l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((110l),Empty)))))))))))))))));;

let rec data_pipe2 () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_dot2 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_list2 () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_slice_empty2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))))))))));;

let rec data_slice_of_u82 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((117l),Cons ((56l),Empty)))))))))))));;

let rec data_slice_size2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Empty))))))))))));;

let rec data_slice_get2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((103l),Cons ((101l),Cons ((116l),Empty)))))))))));;

let rec data_slice_concat2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((99l),Cons ((97l),Cons ((116l),Empty))))))))))))));;

let rec data_slice_foldl2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((100l),Cons ((108l),Empty)))))))))))));;

let rec data_slice_subslice2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((117l),Cons ((98l),Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty))))))))))))))));;

let rec data_slice2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_int322 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec source_reference_from file10 = 
    (SourceReference ((source_file_index file10), (source_file_path file10), (source_file_module file10)));;

type ('Ta69,'Te5) parser2  = 
     | Parser : (int32,('Ta69,'Te5) result) state -> ('Ta69,'Te5) parser2;;

let rec parser_run parsers = 
    (pair_right (list_foldr (fun parser3 state9 -> (match parser3 with
         | (Parser (parser4)) -> 
            (pair_bimap id ((flip list_cons) (pair_right state9)) (state_run (pair_left state9) parser4)))) (Pair ((0l), Empty)) parsers));;

let rec parser_return value25 = 
    (Parser ((state_return (result_return value25))));;

let rec parser_error error10 = 
    (Parser ((state_return (result_error error10))));;

let rec parser_bind parser5 f58 = 
    (match parser5 with
         | (Parser (parser6)) -> 
            (Parser ((state_bind parser6 (fun result14 -> (result_prod state_return (result_bind result14 (fun value26 -> (match (f58 value26) with
                 | (Parser (value27)) -> 
                    (result_return value27))))))))));;

let rec increment_id () = 
    (Parser ((state_bind (state_get ()) (fun state10 -> (state_bind (state_set (Int32.add state10 (1l))) (fun id11 -> (state_return (result_return id11))))))));;

let rec parser_sequence parsers2 = 
    (list_foldr (fun a70 b65 -> (parser_bind a70 (fun a71 -> (parser_bind b65 (fun b66 -> (parser_return (Cons (a71, b66)))))))) (parser_return Empty) parsers2);;

let rec sequence f59 items = 
    (parser_sequence (list_map f59 items));;

let rec sexp_error_to_ast_error error11 = 
    (match error11 with
         | ParseErrorTooFewClosingBrackets -> 
            MalformedSexpTooFewClosingBrackets
         | ParseErrorTooManyClosingBrackets -> 
            MalformedSexpTooManyClosingBrackets);;

let rec new_identifier source_reference15 error12 kind6 symbol2 = 
    (match symbol2 with
         | (Symbol (token3, text7, range60)) -> 
            (parser_bind (increment_id ()) (fun id12 -> (parser_return (identifier_from_definition id12 kind6 text7 source_reference15 range60))))
         | (Integer (x331, range61)) -> 
            (parser_error (error12 source_reference15 range61))
         | (List (x332, range62)) -> 
            (parser_error (error12 source_reference15 range62)));;

let rec scope_empty () = 
    (Pair ((dictionary_empty ()), (dictionary_empty ())));;

let rec add_identifier id13 scope = 
    (match scope with
         | (Pair (value_scope, type_scope)) -> 
            (match (identifier_universe2 id13) with
                 | ValueUniverse -> 
                    (Pair ((dictionary_set (identifier_name id13) id13 value_scope), type_scope))
                 | TypeUniverse -> 
                    (Pair (value_scope, (dictionary_set (identifier_name id13) id13 type_scope)))));;

let rec scope_with identifiers scope2 = 
    (list_foldl add_identifier scope2 identifiers);;

let rec scope_merge first8 second = 
    (list_foldl add_identifier (list_foldl add_identifier first8 (dictionary_values (pair_right second))) (dictionary_values (pair_left second)));;

let rec scope_resolve text8 universe3 scope3 = 
    (match universe3 with
         | ValueUniverse -> 
            (dictionary_get text8 (pair_left scope3))
         | TypeUniverse -> 
            (dictionary_get text8 (pair_right scope3)));;

let rec lookup_identifier source_reference16 error13 scope4 universe4 name26 = 
    (match name26 with
         | (Symbol (x333, text9, range63)) -> 
            (match (scope_resolve text9 universe4 scope4) with
                 | (Some (identifier47)) -> 
                    (parser_return (identifier_resolved identifier47 source_reference16 range63))
                 | None -> 
                    (parser_return (identifier_unresolved universe4 text9 source_reference16 range63)))
         | x334 -> 
            (parser_error (error13 source_reference16 (sexp_range name26))));;

let rec lookup_identifiers source_reference17 scope5 universe5 names = 
    (parser_sequence (list_map (fun name27 -> (lookup_identifier source_reference17 (not_defined (sexp_symbol_text name27)) scope5 universe5 name27)) names));;

let rec collect_captures pattern12 = 
    (match pattern12 with
         | (Capture (identifier48)) -> 
            (Cons (identifier48,Empty))
         | (IntegerPattern (value28, range64)) -> 
            Empty
         | (ConstructorPattern (x335, patterns5, x336)) -> 
            (list_flatten (list_map collect_captures patterns5)));;

let rec capital_letter c18 = 
    (and2 (x6 c18 (65l)) (x5 c18 (90l)));;

let rec capitalized s2 = 
    (maybe_or_else False (maybe_map capital_letter (string_first s2)));;

let rec parse_pattern source_reference18 scope6 pattern13 = 
    (match pattern13 with
         | (Symbol (x337, text10, range65)) -> 
            (match (capitalized text10) with
                 | True -> 
                    (parser_bind (lookup_identifier source_reference18 (not_defined (Some (text10))) scope6 ValueUniverse pattern13) (fun constructor5 -> (parser_return (ConstructorPattern (constructor5, Empty, range65)))))
                 | False -> 
                    (parser_bind (new_identifier source_reference18 malformed_pattern VariableDefinition pattern13) (fun identifier49 -> (parser_return (Capture (identifier49))))))
         | (Integer (value29, range66)) -> 
            (parser_return (IntegerPattern (value29, range66)))
         | (List ((Cons (constructor6, patterns6)), range67)) -> 
            (parser_bind (lookup_identifier source_reference18 (not_defined (sexp_symbol_text constructor6)) scope6 ValueUniverse constructor6) (fun constructor7 -> (parser_bind (sequence (parse_pattern source_reference18 scope6) patterns6) (fun patterns7 -> (parser_return (ConstructorPattern (constructor7, patterns7, range67)))))))
         | (List (x338, range68)) -> 
            (parser_error (MalformedPatternError (source_reference18, range68))));;

let rec parse_match_rule parse_expression2 source_reference19 scope7 rule3 = 
    (match rule3 with
         | (Pair (pattern14, expression38)) -> 
            (parser_bind (parse_pattern source_reference19 scope7 pattern14) (fun pattern15 -> (parser_bind (parse_expression2 source_reference19 (scope_with (collect_captures pattern15) scope7) expression38) (fun expression39 -> (parser_return (Pair (pattern15, expression39))))))));;

let rec parse_expression3 source_reference20 scope8 expression40 = 
    (match expression40 with
         | (Integer (value30, range69)) -> 
            (parser_return (IntegerConstant (value30, range69)))
         | (Symbol (x339, text11, range70)) -> 
            (match (capitalized text11) with
                 | True -> 
                    (parser_bind (lookup_identifier source_reference20 (not_defined (Some (text11))) scope8 ValueUniverse expression40) (fun constructor8 -> (parser_return (Constructor (constructor8, Empty, range70)))))
                 | False -> 
                    (parser_bind (lookup_identifier source_reference20 (not_defined (Some (text11))) scope8 ValueUniverse expression40) (fun identifier50 -> (parser_return (Variable (identifier50))))))
         | (List ((Cons ((Symbol (-3l, x340, x341)), (Cons ((List (arguments10, x342)), (Cons (expression41, Empty)))))), range71)) -> 
            (parser_bind (sequence (new_identifier source_reference20 malformed_function_definition VariableDefinition) arguments10) (fun arguments11 -> (parser_bind (parse_expression3 source_reference20 (scope_with arguments11 scope8) expression41) (fun expression42 -> (parser_return (Lambda (arguments11, expression42, range71)))))))
         | (List ((Cons ((Symbol (-4l, x343, x344)), (Cons (expression43, Empty)))), range72)) -> 
            (parser_error (MalformedMatchExpressionError (source_reference20, range72)))
         | (List ((Cons ((Symbol (-4l, x345, x346)), (Cons (expression44, rules5)))), range73)) -> 
            (match (x4 (Int32.rem (list_size rules5) (2l)) (0l)) with
                 | True -> 
                    (parser_bind (parser_sequence (list_map (parse_match_rule parse_expression3 source_reference20 scope8) (list_pairs rules5))) (fun rules6 -> (parser_bind (parse_expression3 source_reference20 scope8 expression44) (fun expression45 -> (parser_return (Match (expression45, rules6, range73)))))))
                 | False -> 
                    (parser_error (MalformedMatchExpressionError (source_reference20, range73))))
         | (List ((Cons ((Symbol (token4, text12, range74)), expressions32)), range75)) -> 
            (match token4 with
                 | -14l -> 
                    (parser_bind (parser_sequence (list_map (parse_expression3 source_reference20 scope8) expressions32)) (fun expressions33 -> (parser_return (ListExpression (expressions33, range75)))))
                 | -15l -> 
                    (parser_bind (parser_sequence (list_map (parse_expression3 source_reference20 scope8) expressions32)) (fun expressions34 -> (parser_return (Pipe (expressions34, range75)))))
                 | -16l -> 
                    (parser_bind (parser_sequence (list_map (parse_expression3 source_reference20 scope8) expressions32)) (fun expressions35 -> (parser_return (Compose (expressions35, range75)))))
                 | x347 -> 
                    (match (capitalized text12) with
                         | True -> 
                            (parser_bind (lookup_identifier source_reference20 (not_defined (Some (text12))) scope8 ValueUniverse (Symbol (token4, text12, range75))) (fun constructor9 -> (parser_bind (parser_sequence (list_map (parse_expression3 source_reference20 scope8) expressions32)) (fun expressions36 -> (parser_return (Constructor (constructor9, expressions36, range75)))))))
                         | False -> 
                            (parser_bind (parser_sequence (list_map (parse_expression3 source_reference20 scope8) (Cons ((Symbol (token4, text12, range75)), expressions32)))) (fun expressions37 -> (parser_return (FunctionApplication (expressions37, range75)))))))
         | (List (Empty, range76)) -> 
            (parser_error (MalformedExpressionError (source_reference20, range76)))
         | (List (expressions38, range77)) -> 
            (parser_bind (parser_sequence (list_map (parse_expression3 source_reference20 scope8) expressions38)) (fun expressions39 -> (parser_return (FunctionApplication (expressions39, range77))))));;

let rec parse_function_definition source_reference21 context rest17 range78 public7 = 
    (match rest17 with
         | (Cons (name28, (Cons ((List (arguments12, x348)), (Cons (expression46, Empty)))))) -> 
            (parser_bind context (fun context2 -> (match context2 with
                 | (Pair (scope9, definitions3)) -> 
                    (parser_bind (sequence (new_identifier source_reference21 malformed_function_definition VariableDefinition) arguments12) (fun arguments13 -> (parser_bind (new_identifier source_reference21 malformed_function_definition (match public7 with
                         | True -> 
                            PublicFunctionDefinition
                         | False -> 
                            PrivateFunctionDefinition) name28) (fun name29 -> (parser_bind (parse_expression3 source_reference21 (scope_with (Cons (name29, arguments13)) scope9) expression46) (fun expression47 -> (parser_return (Pair ((scope_with (Cons (name29,Empty)) scope9), (list_cons (FunctionDefinition (name29, public7, arguments13, expression47, range78)) definitions3)))))))))))))
         | Empty -> 
            (parser_error (FunctionDefinitionMissingName (source_reference21, range78)))
         | (Cons ((List (x349, x350)), Empty)) -> 
            (parser_error (FunctionDefinitionMissingName (source_reference21, range78)))
         | x351 -> 
            (parser_error (MalformedFunctionDefinitionError (source_reference21, range78))));;

let rec parse_type source_reference22 scope10 type4 = 
    (match type4 with
         | (Symbol (x352, text13, x353)) -> 
            (parser_bind (lookup_identifier source_reference22 (not_defined (Some (text13))) scope10 TypeUniverse type4) (fun name30 -> (parser_return (SimpleType (name30)))))
         | (List ((Cons ((Symbol (-3l, x354, x355)), (Cons ((List (argument_types, x356)), (Cons (return_type2, Empty)))))), range79)) -> 
            (parser_bind (sequence (parse_type source_reference22 scope10) argument_types) (fun argument_types2 -> (parser_bind (parse_type source_reference22 scope10 return_type2) (fun return_type3 -> (parser_return (FunctionType (argument_types2, return_type3, range79)))))))
         | (List ((Cons (name31, parameters4)), range80)) -> 
            (parser_bind (sequence (parse_type source_reference22 scope10) parameters4) (fun parameters5 -> (parser_bind (lookup_identifier source_reference22 (not_defined (sexp_symbol_text name31)) scope10 TypeUniverse name31) (fun name32 -> (parser_return (ComplexType (name32, parameters5, range80)))))))
         | (List (x357, range81)) -> 
            (parser_error (malformed_type source_reference22 range81))
         | (Integer (x358, range82)) -> 
            (parser_error (malformed_type source_reference22 range82)));;

let rec parse_constructor source_reference23 public8 scope11 constructor10 = 
    (match constructor10 with
         | (Symbol (x359, name33, range83)) -> 
            (parser_bind (new_identifier source_reference23 malformed_type_definition (match public8 with
                 | True -> 
                    PublicConstructorDefinition
                 | False -> 
                    PrivateConstructorDefinition) constructor10) (fun id14 -> (parser_return (SimpleConstructor (id14)))))
         | (List ((Cons (name34, types10)), range84)) -> 
            (parser_bind (new_identifier source_reference23 malformed_type_definition (match public8 with
                 | True -> 
                    PublicConstructorDefinition
                 | False -> 
                    PrivateConstructorDefinition) name34) (fun id15 -> (parser_bind (sequence (parse_type source_reference23 scope11) types10) (fun types11 -> (parser_return (ComplexConstructor (id15, types11, range84)))))))
         | (Integer (x360, range85)) -> 
            (parser_error (malformed_type_definition source_reference23 range85))
         | (List (x361, range86)) -> 
            (parser_error (malformed_type_definition source_reference23 range86)));;

let rec parse_type_parameter source_reference24 scope12 parameter3 = 
    (match parameter3 with
         | (Symbol (x362, x363, x364)) -> 
            (parser_bind (new_identifier source_reference24 malformed_type_definition TypeVariableDefinition parameter3) (fun name35 -> (parser_return (UniversalParameter (name35)))))
         | (List ((Cons ((Symbol (-5l, x365, x366)), (Cons (parameter4, Empty)))), range87)) -> 
            (parser_bind (new_identifier source_reference24 malformed_type_definition TypeVariableDefinition parameter4) (fun name36 -> (parser_return (ExistentialParameter (name36)))))
         | (Integer (x367, range88)) -> 
            (parser_error (malformed_type_definition source_reference24 range88))
         | (List (x368, range89)) -> 
            (parser_error (malformed_type_definition source_reference24 range89)));;

let rec parse_type_definition source_reference25 context3 name37 parameters6 constructors5 range90 public9 = 
    (parser_bind context3 (fun context4 -> (match context4 with
         | (Pair (scope13, definitions4)) -> 
            (parser_bind (sequence (parse_type_parameter source_reference25 scope13) parameters6) (fun parameters7 -> (let_bind (list_map type_parameter_identifier parameters7) (fun parameter_names -> (parser_bind (new_identifier source_reference25 malformed_type_definition (match public9 with
                 | True -> 
                    PublicTypeDefinition
                 | False -> 
                    PrivateTypeDefinition) name37) (fun name38 -> (parser_bind (sequence (parse_constructor source_reference25 public9 (scope_with (Cons (name38, parameter_names)) scope13)) constructors5) (fun constructors6 -> (let_bind (list_map constructor_identifier constructors6) (fun constructor_names -> (parser_return (Pair ((scope_with (Cons (name38, constructor_names)) scope13), (list_cons (TypeDefinition (name38, public9, parameters7, constructors6, range90)) definitions4)))))))))))))))));;

let rec parse_type_definition2 source_reference26 context5 rest18 range91 public10 = 
    (match rest18 with
         | (Cons (x369, Empty)) -> 
            (parser_error (TypeDefinitionMissingConstructors (source_reference26, range91)))
         | (Cons ((List ((Cons (name39, parameters8)), x370)), constructors7)) -> 
            (parse_type_definition source_reference26 context5 name39 parameters8 constructors7 range91 public10)
         | (Cons (name40, constructors8)) -> 
            (parse_type_definition source_reference26 context5 name40 Empty constructors8 range91 public10)
         | Empty -> 
            (parser_error (TypeDefinitionMissingName (source_reference26, range91))));;

let rec parse_definitions source_reference27 scope14 sexps = 
    (list_foldl (fun sexp5 context6 -> (match sexp5 with
         | (List ((Cons ((Symbol (-1l, x371, x372)), rest19)), range92)) -> 
            (parse_function_definition source_reference27 context6 rest19 range92 False)
         | (List ((Cons ((Symbol (-6l, x373, x374)), (Cons ((Symbol (-1l, x375, x376)), rest20)))), range93)) -> 
            (parse_function_definition source_reference27 context6 rest20 range93 True)
         | (List ((Cons ((Symbol (-2l, x377, x378)), rest21)), range94)) -> 
            (parse_type_definition2 source_reference27 context6 rest21 range94 False)
         | (List ((Cons ((Symbol (-6l, x379, x380)), (Cons ((Symbol (-2l, x381, x382)), rest22)))), range95)) -> 
            (parse_type_definition2 source_reference27 context6 rest22 range95 True)
         | (List (x383, range96)) -> 
            (parser_error (MalformedDefinitionError (source_reference27, range96)))
         | (Symbol (x384, x385, range97)) -> 
            (parser_error (MalformedDefinitionError (source_reference27, range97)))
         | (Integer (x386, range98)) -> 
            (parser_error (MalformedDefinitionError (source_reference27, range98))))) (parser_return (Pair (scope14, (list_empty ())))) sexps);;

let rec parse_reuse_file file11 = 
    (match (parse_sexps (predefined_symbols ()) (source_file_content file11)) with
         | (Result ((Pair (x387, sexps2)))) -> 
            (parser_bind (parse_definitions (source_reference_from file11) (scope_with (predefined_identifiers ()) (scope_empty ())) sexps2) (fun definitions5 -> (parser_return (pair_bimap id list_reverse definitions5))))
         | (Error (error14)) -> 
            (parser_error (sexp_error_to_ast_error error14)));;

let rec transform_strings path3 content3 = 
    (match (string_gen content3) with
         | (Result (string36)) -> 
            (string_to_slice string36)
         | (Error (error15)) -> 
            (slice_empty ()));;

let rec parse_strings_file file12 = 
    (match file12 with
         | (SourceFile (reference5, content4)) -> 
            (parse_reuse_file (SourceFile (reference5, (transform_strings (source_reference_file_path reference5) content4)))));;

let rec parse_source_file file13 = 
    (match (source_file_type2 file13) with
         | SourceFileTypeStrings -> 
            (parse_strings_file file13)
         | SourceFileTypeReuse -> 
            (parse_reuse_file file13)
         | SourceFileTypeTargetLanguage -> 
            (parser_return (Pair ((scope_empty ()), (Cons ((TargetDefinition ((source_file_reference file13), (source_file_content file13))),Empty))))));;

let rec identifier_is_accessible identifier51 source_reference28 = 
    (or2 (module_equal (identifier_module identifier51) (source_reference_module source_reference28)) (identifier_public identifier51));;

let rec resolve_variable scope15 identifier52 = 
    (match identifier52 with
         | (Identifier (None, universe6, text14, source_reference29, range99)) -> 
            (match (scope_resolve text14 universe6 scope15) with
                 | (Some (identifier53)) -> 
                    (match (identifier_is_accessible identifier53 source_reference29) with
                         | True -> 
                            (result_return (identifier_resolved identifier53 source_reference29 range99))
                         | False -> 
                            (result_error (ErrorNotAccessible (text14, source_reference29, range99))))
                 | None -> 
                    (result_error (not_defined (Some (text14)) source_reference29 range99)))
         | x388 -> 
            (result_return identifier52));;

let rec resolve_definition scope16 definition9 = 
    (match definition9 with
         | (FunctionDefinition (identifier54, public11, arguments14, expression48, range100)) -> 
            (result_bind (over_identifiers (resolve_variable scope16) expression48) (fun expression49 -> (result_return (FunctionDefinition (identifier54, public11, arguments14, expression49, range100)))))
         | (TypeDefinition (identifier55, public12, parameters9, constructors9, range101)) -> 
            (result_bind (result_concat (list_map (over_identifiers_in_constructor (resolve_variable scope16)) constructors9)) (fun constructors10 -> (result_return (TypeDefinition (identifier55, public12, parameters9, constructors10, range101)))))
         | x389 -> 
            (result_return definition9));;

let rec resolve_identifiers parsed_files = 
    (list_foldl (fun parsed_file state11 -> (match parsed_file with
         | (Pair (file_scope, file_definitions)) -> 
            (result_bind state11 (fun state12 -> (result_bind (result_concat (list_map (resolve_definition (pair_left state12)) file_definitions)) (fun new_definitions -> (result_return (Pair ((scope_merge (pair_left state12) file_scope), (list_concat (pair_right state12) new_definitions)))))))))) (Result ((Pair ((scope_empty ()), Empty)))) parsed_files);;

let rec resolve_files files = 
    (match (result_partition (parser_run files)) with
         | (Pair (parsed_files2, Empty)) -> 
            (resolve_identifiers parsed_files2)
         | (Pair (x390, (Cons (error16, x391)))) -> 
            (Error (error16)));;

let rec parse_source_files files2 = 
    (resolve_files (list_map parse_source_file files2));;

let rec data_double_dash () = 
    (string_from_list (Cons ((45l),Cons ((45l),Empty))));;

let rec data_single_dash () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_true () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))));;

type cli_arguments  = 
     | CliArguments : ((string,string) pair) list * (string) list -> cli_arguments
     | CliErrorMissingValue : string -> cli_arguments;;

let rec is_key argument = 
    (string_equal (data_double_dash ()) (string_take (2l) argument));;

let rec is_flag argument2 = 
    (string_equal (data_single_dash ()) (string_take (1l) argument2));;

let rec parse_arguments2 arguments15 kv_args inputs = 
    (match arguments15 with
         | (Cons (first9, (Cons (second2, rest23)))) -> 
            (match (is_key first9) with
                 | True -> 
                    (parse_arguments2 (list_rest (list_rest arguments15)) (Cons ((Pair ((string_skip (2l) first9), second2)), kv_args)) inputs)
                 | False -> 
                    (match (is_flag first9) with
                         | True -> 
                            (parse_arguments2 (list_rest arguments15) (Cons ((Pair ((string_skip (1l) first9), (data_true ()))), kv_args)) inputs)
                         | False -> 
                            (parse_arguments2 (list_rest arguments15) kv_args (Cons (first9, inputs)))))
         | (Cons (first10, Empty)) -> 
            (match (is_key first10) with
                 | True -> 
                    (CliErrorMissingValue (first10))
                 | False -> 
                    (match (is_flag first10) with
                         | True -> 
                            (CliArguments ((list_reverse (Cons ((Pair ((string_skip (1l) first10), (data_true ()))), kv_args))), (list_reverse inputs)))
                         | False -> 
                            (CliArguments ((list_reverse kv_args), (list_reverse (Cons (first10, inputs)))))))
         | Empty -> 
            (CliArguments ((list_reverse kv_args), (list_reverse inputs))));;

let rec parse_arguments arguments16 = 
    (parse_arguments2 arguments16 Empty Empty);;

let rec data_parseerrortoofewclosingbrackets () = 
    (string_from_list (Cons ((84l),Cons ((111l),Cons ((111l),Cons ((32l),Cons ((102l),Cons ((101l),Cons ((119l),Cons ((32l),Cons ((99l),Cons ((108l),Cons ((111l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((98l),Cons ((114l),Cons ((97l),Cons ((99l),Cons ((107l),Cons ((101l),Cons ((116l),Cons ((115l),Empty))))))))))))))))))))))))));;

let rec data_parseerrortoomanyclosingbrackets () = 
    (string_from_list (Cons ((84l),Cons ((111l),Cons ((111l),Cons ((32l),Cons ((109l),Cons ((97l),Cons ((110l),Cons ((121l),Cons ((32l),Cons ((99l),Cons ((108l),Cons ((111l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((98l),Cons ((114l),Cons ((97l),Cons ((99l),Cons ((107l),Cons ((101l),Cons ((116l),Cons ((115l),Empty)))))))))))))))))))))))))));;

let rec data_success () = 
    (string_from_list (Cons ((115l),Cons ((117l),Cons ((99l),Cons ((99l),Cons ((101l),Cons ((115l),Cons ((115l),Empty)))))))));;

let rec data_fn2 () = 
    (string_from_list (Cons ((102l),Cons ((110l),Empty))));;

let rec data_pub2 () = 
    (string_from_list (Cons ((112l),Cons ((117l),Cons ((98l),Empty)))));;

let rec data_def2 () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Empty)))));;

let rec data_typ2 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Empty)))));;

let rec data_exists2 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((115l),Empty))))))));;

let rec data_match2 () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_list3 () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_pipe3 () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_open_bracket () = 
    (string_from_list (Cons ((40l),Empty)));;

let rec data_close_bracket () = 
    (string_from_list (Cons ((41l),Empty)));;

let rec data_bind () = 
    (string_from_list (Cons ((98l),Cons ((105l),Cons ((110l),Cons ((100l),Empty))))));;

let rec stringify_error error17 = 
    (match error17 with
         | ParseErrorTooFewClosingBrackets -> 
            (data_parseerrortoofewclosingbrackets ())
         | ParseErrorTooManyClosingBrackets -> 
            (data_parseerrortoomanyclosingbrackets ()));;

let rec language_identifiers () = 
    (Cons ((Pair ((string_empty ()), (Pair ((-100l), (string_empty ()))))),Cons ((Pair ((data_def2 ()), (Pair ((-1l), (data_def2 ()))))),Cons ((Pair ((data_typ2 ()), (Pair ((-2l), (data_typ2 ()))))),Cons ((Pair ((data_fn2 ()), (Pair ((-3l), (data_fn2 ()))))),Cons ((Pair ((data_match2 ()), (Pair ((-4l), (data_match2 ()))))),Cons ((Pair ((data_exists2 ()), (Pair ((-5l), (data_exists2 ()))))),Cons ((Pair ((data_pub2 ()), (Pair ((-6l), (data_pub2 ()))))),Cons ((Pair ((data_list3 ()), (Pair ((-7l), (data_list3 ()))))),Cons ((Pair ((data_pipe3 ()), (Pair ((-8l), (data_pipe3 ()))))),Empty))))))))));;

let rec space () = 
    (string_of_char (32l));;

let rec newline2 () = 
    (string_of_char (10l));;

let rec indent2 n8 = 
    (string_concat (newline2 ()) (string_repeat (space ()) n8));;

let rec list_with_space items2 = 
    (wrap_in_brackets (string_join (space ()) items2));;

let rec list_without_space items3 = 
    (wrap_in_brackets (string_join (string_empty ()) items3));;

let rec add_modifiers public13 rest24 = 
    (match public13 with
         | True -> 
            (Cons ((data_pub2 ()), (Cons ((space ()), rest24))))
         | False -> 
            rest24);;

let rec format_pattern pattern16 = 
    (match pattern16 with
         | (List (patterns8, x392)) -> 
            (list_with_space (list_map format_pattern patterns8))
         | x393 -> 
            (stringify_sexp x393));;

let rec format_match_rule format_expression depth3 rule4 = 
    (match rule4 with
         | (Pair (pattern17, expression50)) -> 
            (string_join (string_empty ()) (Cons ((format_pattern pattern17),Cons ((indent2 (Int32.add depth3 (4l))),Cons ((format_expression (Int32.add depth3 (4l)) expression50),Empty))))));;

let rec format_match_rules format_expression2 depth4 rules7 = 
    (string_join (indent2 depth4) (list_map (format_match_rule format_expression2 depth4) rules7));;

let rec rule_pairs rules8 = 
    (match (Int32.rem (list_size rules8) (2l)) with
         | 0l -> 
            (list_pairs rules8)
         | x394 -> 
            (list_pairs (list_reverse (Cons ((Symbol ((-100l), (string_empty ()), (Range ((0l), (0l))))), (list_reverse rules8))))));;

let rec monadic_function_call expressions40 = 
    (match (Pair ((list_first expressions40), (list_last expressions40))) with
         | (Pair ((Some ((Symbol (x395, name41, x396)))), (Some ((List ((Cons ((Symbol (-3l, x397, x398)), x399)), x400)))))) -> 
            (match (list_last (string_split (45l) name41)) with
                 | (Some (last_part)) -> 
                    (string_equal last_part (data_bind ()))
                 | None -> 
                    False)
         | x401 -> 
            False);;

let rec format_long_list_expression format_expression3 stringified depth5 expressions41 = 
    (match (x6 (string_size stringified) (78l)) with
         | True -> 
            (string_join (indent2 (Int32.add depth5 (4l))) (list_map (format_expression3 (Int32.add depth5 (4l))) expressions41))
         | False -> 
            stringified);;

let rec format_list_expression format_expression4 depth6 expressions42 = 
    (match (monadic_function_call expressions42) with
         | True -> 
            (string_join (space ()) (list_flatten (Cons ((list_map stringify_sexp (list_reverse (list_skip (1l) (list_reverse expressions42)))),Cons ((Cons ((maybe_or_else (string_empty ()) (maybe_map (format_expression4 (Int32.sub depth6 (4l))) (list_last expressions42))),Empty)),Empty)))))
         | False -> 
            (match (string_join (space ()) (list_map (format_expression4 depth6) expressions42)) with
                 | stringified2 -> 
                    (match (x5 (list_size expressions42) (2l)) with
                         | False -> 
                            (format_long_list_expression format_expression4 stringified2 depth6 expressions42)
                         | True -> 
                            stringified2)));;

let rec format_expression5 depth7 expression51 = 
    (match expression51 with
         | (List ((Cons ((Symbol (-3l, x402, x403)), (Cons (arguments17, (Cons (expression52, Empty)))))), x404)) -> 
            (list_without_space (Cons ((data_fn2 ()),Cons ((space ()),Cons ((stringify_sexp arguments17),Cons ((indent2 (Int32.add depth7 (4l))),Cons ((format_expression5 (Int32.add depth7 (4l)) expression52),Empty)))))))
         | (List ((Cons ((Symbol (-4l, x405, x406)), (Cons (expression53, rules9)))), range102)) -> 
            (list_without_space (Cons ((data_match2 ()),Cons ((space ()),Cons ((format_expression5 depth7 expression53),Cons ((indent2 (Int32.add depth7 (7l))),Cons ((format_match_rules format_expression5 (Int32.add depth7 (7l)) (rule_pairs rules9)),Empty)))))))
         | (List (expressions43, range103)) -> 
            (wrap_in_brackets (format_list_expression format_expression5 depth7 expressions43))
         | x407 -> 
            (stringify_sexp x407));;

let rec format_type type5 = 
    (match type5 with
         | (List ((Cons ((Symbol (-3l, x408, x409)), (Cons ((List (argument_types3, x410)), (Cons (return_type4, Empty)))))), x411)) -> 
            (list_with_space (Cons ((data_fn2 ()),Cons ((list_with_space (list_map format_type argument_types3)),Cons ((format_type return_type4),Empty)))))
         | (List ((Cons (identifier56, parameters10)), x412)) -> 
            (list_with_space (Cons ((stringify_sexp identifier56), (list_map format_type parameters10))))
         | x413 -> 
            (stringify_sexp x413));;

let rec format_type_constructor constructor11 = 
    (match constructor11 with
         | (List ((Cons (identifier57, types12)), x414)) -> 
            (list_with_space (Cons ((stringify_sexp identifier57), (list_map format_type types12))))
         | x415 -> 
            (stringify_sexp x415));;

let rec format_type_constructor_split constructor12 = 
    (match constructor12 with
         | (List ((Cons (identifier58, (Cons (first11, rest25)))), x416)) -> 
            (wrap_in_brackets (string_join (space ()) (Cons ((stringify_sexp identifier58),Cons ((string_join (indent2 (Int32.add (string_size (stringify_sexp identifier58)) (7l))) (Cons ((format_type first11), (list_map format_type rest25)))),Empty)))))
         | x417 -> 
            (stringify_sexp x417));;

let rec format_type_parameter parameter5 = 
    (match parameter5 with
         | (List ((Cons ((Symbol (-5l, x418, x419)), (Cons (identifier59, Empty)))), x420)) -> 
            (list_with_space (Cons ((data_exists2 ()),Cons ((stringify_sexp identifier59),Empty))))
         | x421 -> 
            (stringify_sexp parameter5));;

let rec format_type_definition_name name42 parameters11 = 
    (match parameters11 with
         | Empty -> 
            (stringify_sexp name42)
         | x422 -> 
            (list_with_space (Cons ((stringify_sexp name42), (list_map format_type_parameter parameters11)))));;

let rec format_type_definition_constructors constructors11 = 
    (match constructors11 with
         | (Cons (constructor13, Empty)) -> 
            (match (x6 (string_size (stringify_sexps constructors11)) (80l)) with
                 | True -> 
                    (string_concat (indent2 (5l)) (format_type_constructor_split constructor13))
                 | False -> 
                    (string_concat (space ()) (format_type_constructor constructor13)))
         | x423 -> 
            (string_concat (indent2 (5l)) (string_join (indent2 (5l)) (list_map format_type_constructor constructors11))));;

let rec format_type_definition public14 name43 parameters12 constructors12 = 
    (list_without_space (add_modifiers public14 (Cons ((data_typ2 ()),Cons ((space ()),Cons ((format_type_definition_name name43 parameters12),Cons ((format_type_definition_constructors constructors12),Empty)))))));;

let rec format_function_definition public15 name44 arguments18 expression54 = 
    (list_without_space (add_modifiers public15 (list_flatten (Cons ((Cons ((data_def2 ()),Cons ((space ()),Cons ((stringify_sexp name44),Cons ((space ()),Cons ((wrap_in_brackets (string_join (space ()) (list_map stringify_sexp arguments18))),Empty)))))),Cons ((match expression54 with
         | (Integer (x424, x425)) -> 
            (Cons ((space ()),Empty))
         | x426 -> 
            (Cons ((indent2 (5l)),Empty))),Cons ((Cons ((format_expression5 (5l) expression54),Empty)),Empty)))))));;

let rec format_definition definition10 = 
    (match definition10 with
         | (List ((Cons ((Symbol (-6l, x427, x428)), (Cons ((Symbol (-2l, x429, x430)), (Cons ((List ((Cons (name45, parameters13)), x431)), constructors13)))))), range104)) -> 
            (format_type_definition True name45 parameters13 constructors13)
         | (List ((Cons ((Symbol (-6l, x432, x433)), (Cons ((Symbol (-2l, x434, x435)), (Cons (name46, constructors14)))))), range105)) -> 
            (format_type_definition True name46 Empty constructors14)
         | (List ((Cons ((Symbol (-2l, x436, x437)), (Cons ((List ((Cons (name47, parameters14)), x438)), constructors15)))), range106)) -> 
            (format_type_definition False name47 parameters14 constructors15)
         | (List ((Cons ((Symbol (-2l, x439, x440)), (Cons (name48, constructors16)))), range107)) -> 
            (format_type_definition False name48 Empty constructors16)
         | (List ((Cons ((Symbol (-6l, x441, x442)), (Cons ((Symbol (-1l, x443, x444)), (Cons (name49, (Cons ((List (arguments19, x445)), (Cons (expression55, Empty)))))))))), range108)) -> 
            (format_function_definition True name49 arguments19 expression55)
         | (List ((Cons ((Symbol (-1l, x446, x447)), (Cons (name50, (Cons ((List (arguments20, x448)), (Cons (expression56, Empty)))))))), range109)) -> 
            (format_function_definition False name50 arguments20 expression56)
         | x449 -> 
            (stringify_sexp definition10));;

let rec format_file definitions6 = 
    (match (list_is_empty definitions6) with
         | True -> 
            (string_empty ())
         | False -> 
            (definitions6 |> (list_map format_definition) |> (string_join (string_repeat (newline2 ()) (2l))) |> ((flip string_concat) (newline2 ())) |> (string_concat (newline2 ()))));;

let rec format_source_file file14 = 
    (file14 |> source_file_content |> (parse_sexps (Pair ((0l), (dictionary_of (language_identifiers ()))))) |> (result_bimap (fun x' -> x' |> pair_right |> format_file |> string_to_slice) stringify_error));;

let rec result_from_pair pair12 = 
    (result_map (pair_cons (pair_left pair12)) (pair_right pair12));;

let rec format_source_files files3 = 
    (result_concat (list_map (fun x' -> x' |> pair_dup |> (pair_bimap source_file_path format_source_file) |> result_from_pair) files3));;

type identifier_transformation  = 
     | IdentifierTransformationNone
     | IdentifierTransformationLowercase
     | IdentifierTransformationCapitalize;;

type source_string  = 
     | SourceStringEmpty
     | SourceStringChar : int32 -> source_string
     | SourceString : string -> source_string
     | SourceStringIdentifier : identifier * identifier_transformation -> source_string
     | SourceStringConcat : source_string * source_string -> source_string;;

let rec source_string_string string37 = 
    (SourceString (string37));;

let rec source_string_empty () = 
    SourceStringEmpty;;

let rec source_string_concat a72 b67 = 
    (SourceStringConcat (a72, b67));;

let rec source_string_join separator4 strings2 = 
    (match strings2 with
         | (Cons (first12, rest26)) -> 
            (list_foldl (fun string38 joined2 -> (source_string_concat joined2 (source_string_concat (SourceString (separator4)) string38))) first12 rest26)
         | Empty -> 
            (source_string_empty ()));;

let rec data_space () = 
    (string_from_list (Cons ((32l),Empty)));;

let rec data_fun () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Empty)))));;

let rec data_type () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_if () = 
    (string_from_list (Cons ((105l),Cons ((102l),Empty))));;

let rec data_then () = 
    (string_from_list (Cons ((116l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_else () = 
    (string_from_list (Cons ((101l),Cons ((108l),Cons ((115l),Cons ((101l),Empty))))));;

let rec data_with () = 
    (string_from_list (Cons ((119l),Cons ((105l),Cons ((116l),Cons ((104l),Empty))))));;

let rec data_of () = 
    (string_from_list (Cons ((111l),Cons ((102l),Empty))));;

let rec data_class () = 
    (string_from_list (Cons ((99l),Cons ((108l),Cons ((97l),Cons ((115l),Cons ((115l),Empty)))))));;

let rec data_end () = 
    (string_from_list (Cons ((101l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_in () = 
    (string_from_list (Cons ((105l),Cons ((110l),Empty))));;

let rec data_let () = 
    (string_from_list (Cons ((108l),Cons ((101l),Cons ((116l),Empty)))));;

let rec data_open () = 
    (string_from_list (Cons ((111l),Cons ((112l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_and () = 
    (string_from_list (Cons ((97l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_or () = 
    (string_from_list (Cons ((111l),Cons ((114l),Empty))));;

let rec data_as () = 
    (string_from_list (Cons ((97l),Cons ((115l),Empty))));;

let rec data_less_than () = 
    (string_from_list (Cons ((60l),Empty)));;

let rec data_assert () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((115l),Cons ((101l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_asr () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_begin () = 
    (string_from_list (Cons ((98l),Cons ((101l),Cons ((103l),Cons ((105l),Cons ((110l),Empty)))))));;

let rec data_constraint () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((97l),Cons ((105l),Cons ((110l),Cons ((116l),Empty))))))))))));;

let rec data_do () = 
    (string_from_list (Cons ((100l),Cons ((111l),Empty))));;

let rec data_done () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((110l),Cons ((101l),Empty))))));;

let rec data_downto () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((119l),Cons ((110l),Cons ((116l),Cons ((111l),Empty))))))));;

let rec data_exception () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((99l),Cons ((101l),Cons ((112l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty)))))))))));;

let rec data_external () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((116l),Cons ((101l),Cons ((114l),Cons ((110l),Cons ((97l),Cons ((108l),Empty))))))))));;

let rec data_false () = 
    (string_from_list (Cons ((102l),Cons ((97l),Cons ((108l),Cons ((115l),Cons ((101l),Empty)))))));;

let rec data_true2 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))));;

let rec data_for () = 
    (string_from_list (Cons ((102l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_function () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty))))))))));;

let rec data_functor () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Empty)))))))));;

let rec data_include () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((99l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Empty)))))))));;

let rec data_inherit () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((105l),Cons ((116l),Empty)))))))));;

let rec data_initializer () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((97l),Cons ((108l),Cons ((105l),Cons ((122l),Cons ((101l),Cons ((114l),Empty)))))))))))));;

let rec data_land () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((110l),Cons ((100l),Empty))))));;

let rec data_lazy () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((122l),Cons ((121l),Empty))))));;

let rec data_lor () = 
    (string_from_list (Cons ((108l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_lsl () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((108l),Empty)))));;

let rec data_lsr () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_lxor () = 
    (string_from_list (Cons ((108l),Cons ((120l),Cons ((111l),Cons ((114l),Empty))))));;

let rec data_method () = 
    (string_from_list (Cons ((109l),Cons ((101l),Cons ((116l),Cons ((104l),Cons ((111l),Cons ((100l),Empty))))))));;

let rec data_mod () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Empty)))));;

let rec data_module () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec data_mutable () = 
    (string_from_list (Cons ((109l),Cons ((117l),Cons ((116l),Cons ((97l),Cons ((98l),Cons ((108l),Cons ((101l),Empty)))))))));;

let rec data_new () = 
    (string_from_list (Cons ((110l),Cons ((101l),Cons ((119l),Empty)))));;

let rec data_nonrec () = 
    (string_from_list (Cons ((110l),Cons ((111l),Cons ((110l),Cons ((114l),Cons ((101l),Cons ((99l),Empty))))))));;

let rec data_object () = 
    (string_from_list (Cons ((111l),Cons ((98l),Cons ((106l),Cons ((101l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_private () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((105l),Cons ((118l),Cons ((97l),Cons ((116l),Cons ((101l),Empty)))))))));;

let rec data_rec () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((99l),Empty)))));;

let rec data_sig () = 
    (string_from_list (Cons ((115l),Cons ((105l),Cons ((103l),Empty)))));;

let rec data_struct () = 
    (string_from_list (Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_try () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((121l),Empty)))));;

let rec data_val () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Empty)))));;

let rec data_virtual () = 
    (string_from_list (Cons ((118l),Cons ((105l),Cons ((114l),Cons ((116l),Cons ((117l),Cons ((97l),Cons ((108l),Empty)))))))));;

let rec data_when () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_while () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((105l),Cons ((108l),Cons ((101l),Empty)))))));;

let rec data_parser () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((101l),Cons ((114l),Empty))))))));;

let rec data_value () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Cons ((117l),Cons ((101l),Empty)))))));;

let rec data_to () = 
    (string_from_list (Cons ((116l),Cons ((111l),Empty))));;

let rec data_def3 () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Empty)))));;

let rec data_typ3 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Empty)))));;

let rec data_fn3 () = 
    (string_from_list (Cons ((102l),Cons ((110l),Empty))));;

let rec data_match3 () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_exists3 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((115l),Empty))))))));;

let rec data_pub3 () = 
    (string_from_list (Cons ((112l),Cons ((117l),Cons ((98l),Empty)))));;

let rec data_11 () = 
    (string_from_list (Cons ((43l),Empty)));;

let rec data__3 () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_12 () = 
    (string_from_list (Cons ((42l),Empty)));;

let rec data_13 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec data_14 () = 
    (string_from_list (Cons ((37l),Empty)));;

let rec data_15 () = 
    (string_from_list (Cons ((38l),Empty)));;

let rec data_int32_less_than3 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((45l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((45l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((110l),Empty)))))))))))))))));;

let rec data_pipe4 () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_dot3 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_list4 () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_slice_empty3 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))))))))));;

let rec data_slice_of_u83 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((117l),Cons ((56l),Empty)))))))))))));;

let rec data_slice_size3 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Empty))))))))))));;

let rec data_slice_get3 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((103l),Cons ((101l),Cons ((116l),Empty)))))))))));;

let rec data_slice_concat3 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((99l),Cons ((97l),Cons ((116l),Empty))))))))))))));;

let rec data_slice_foldl3 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((100l),Cons ((108l),Empty)))))))))))));;

let rec data_slice_subslice3 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((117l),Cons ((98l),Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty))))))))))))))));;

let rec data_slice3 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_int323 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec join strings3 = 
    (source_string_join (string_empty ()) strings3);;

let rec wrap_in_brackets2 string39 = 
    (source_string_concat (SourceStringChar ((40l))) (source_string_concat string39 (SourceStringChar ((41l)))));;

let rec indent n9 = 
    (string_repeat (string_of_char (32l)) (Int32.mul n9 (4l)));;

let rec line n10 parts10 = 
    (source_string_concat (SourceString ((indent n10))) (source_string_join (string_empty ()) parts10));;

let rec newline () = 
    (string_of_char (10l));;

let rec join_lines lines = 
    (source_string_concat (SourceString ((newline ()))) (source_string_join (newline ()) lines));;

let rec source_space () = 
    (SourceString ((data_space ())));;

let rec data_sparkle () = 
    (string_from_list (Cons ((226l),Cons ((156l),Cons ((168l),Empty)))));;

let rec data_16 () = 
    (string_from_list Empty);;

let rec identifier_is_reserved identifier60 = 
    (string_equal (string_substring (0l) (3l) (identifier_name identifier60)) (data_sparkle ()));;

let rec invalid_identifier_error identifier61 = 
    (ErrorReservedIdentifier ((identifier_name identifier61), (identifier_source_reference identifier61), (identifier_range identifier61)));;

let rec validate_identifier identifier62 = 
    (match (identifier_is_reserved identifier62) with
         | True -> 
            (result_error (invalid_identifier_error identifier62))
         | False -> 
            (result_lift identifier62));;

let rec validate_identifiers_in_definition definition11 = 
    (over_definition_expressions (over_identifiers validate_identifier) definition11);;

let rec validate_reserved_identifiers definitions7 = 
    (result_flatmap (fun x' -> x' |> (list_map validate_identifiers_in_definition) |> result_concat) definitions7);;

type ('Tcompilation_result,'Ttransform_error) compiler_backend  = 
     | Backend : string * (string) list * (string) list * (string -> (definition) list -> 'Tcompilation_result) * (( unit  -> string)) list * (((definition) list,'Ttransform_error) result -> ((definition) list,'Ttransform_error) result) -> ('Tcompilation_result,'Ttransform_error) compiler_backend;;

let rec compiler_backend_name backend = 
    (match backend with
         | (Backend (name51, x450, x451, x452, x453, x454)) -> 
            name51);;

let rec compiler_backend_preamble_files backend2 = 
    (match backend2 with
         | (Backend (x455, files4, x456, x457, x458, x459)) -> 
            files4);;

let rec compiler_backend_pervasives_files backend3 = 
    (match backend3 with
         | (Backend (x460, x461, files5, x462, x463, x464)) -> 
            files5);;

let rec compiler_backend_generate_source backend4 module_name definitions8 = 
    (match backend4 with
         | (Backend (x465, x466, x467, generate2, x468, x469)) -> 
            (generate2 module_name definitions8));;

let rec compiler_backend_reserved_identifiers backend5 = 
    (match backend5 with
         | (Backend (x470, x471, x472, x473, identifiers2, x474)) -> 
            identifiers2);;

let rec compiler_backend_transform_definitions backend6 definitions9 = 
    (match backend6 with
         | (Backend (x475, x476, x477, x478, x479, transform)) -> 
            (transform definitions9));;

let rec data_internal_error () = 
    (string_from_list (Cons ((69l),Cons ((110l),Cons ((99l),Cons ((111l),Cons ((117l),Cons ((110l),Cons ((116l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((101l),Cons ((114l),Cons ((114l),Cons ((111l),Cons ((114l),Cons ((32l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((98l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((105l),Cons ((116l),Cons ((32l),Cons ((119l),Cons ((97l),Cons ((115l),Cons ((32l),Cons ((117l),Cons ((110l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((101l),Cons ((100l),Cons ((46l),Cons ((32l),Cons ((84l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((109l),Cons ((105l),Cons ((103l),Cons ((104l),Cons ((116l),Cons ((32l),Cons ((98l),Cons ((101l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((114l),Cons ((32l),Cons ((98l),Cons ((117l),Cons ((103l),Cons ((58l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_reserved_identifier_error () = 
    (string_from_list (Cons ((83l),Cons ((121l),Cons ((109l),Cons ((98l),Cons ((111l),Cons ((108l),Cons ((115l),Cons ((32l),Cons ((112l),Cons ((114l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((120l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((119l),Cons ((105l),Cons ((116l),Cons ((104l),Cons ((32l),Cons ((226l),Cons ((156l),Cons ((168l),Cons ((32l),Cons ((97l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((114l),Cons ((101l),Cons ((115l),Cons ((101l),Cons ((114l),Cons ((118l),Cons ((101l),Cons ((100l),Cons ((58l),Empty)))))))))))))))))))))))))))))))))))))))));;

let rec data_not_defined_error () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((108l),Cons ((111l),Cons ((119l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((105l),Cons ((100l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((102l),Cons ((105l),Cons ((101l),Cons ((114l),Cons ((32l),Cons ((119l),Cons ((97l),Cons ((115l),Cons ((32l),Cons ((110l),Cons ((111l),Cons ((116l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((101l),Cons ((100l),Cons ((58l),Cons ((32l),Empty))))))))))))))))))))))))))))))))))))))))))));;

let rec data_not_accessible_error () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((108l),Cons ((111l),Cons ((119l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((105l),Cons ((100l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((102l),Cons ((105l),Cons ((101l),Cons ((114l),Cons ((32l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((110l),Cons ((111l),Cons ((116l),Cons ((32l),Cons ((97l),Cons ((99l),Cons ((99l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((98l),Cons ((108l),Cons ((101l),Cons ((32l),Cons ((102l),Cons ((114l),Cons ((111l),Cons ((109l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Cons ((58l),Cons ((32l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_already_defined_error () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((108l),Cons ((111l),Cons ((119l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((105l),Cons ((100l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((102l),Cons ((105l),Cons ((101l),Cons ((114l),Cons ((32l),Cons ((119l),Cons ((97l),Cons ((115l),Cons ((32l),Cons ((97l),Cons ((108l),Cons ((114l),Cons ((101l),Cons ((97l),Cons ((100l),Cons ((121l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((101l),Cons ((100l),Cons ((58l),Cons ((32l),Empty))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_expression () = 
    (string_from_list (Cons ((73l),Cons ((32l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((114l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((98l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((105l),Cons ((116l),Cons ((32l),Cons ((100l),Cons ((111l),Cons ((101l),Cons ((115l),Cons ((110l),Cons ((39l),Cons ((116l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((116l),Cons ((97l),Cons ((105l),Cons ((110l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((121l),Cons ((116l),Cons ((104l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((58l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_function_definition () = 
    (string_from_list (Cons ((77l),Cons ((97l),Cons ((108l),Cons ((102l),Cons ((111l),Cons ((114l),Cons ((109l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((102l),Cons ((111l),Cons ((117l),Cons ((110l),Cons ((100l),Cons ((58l),Empty))))))))))))))))))))))))))))))))))))));;

let rec data_function_definition_missing_name () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((109l),Cons ((105l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((105l),Cons ((116l),Cons ((115l),Cons ((32l),Cons ((110l),Cons ((97l),Cons ((109l),Cons ((101l),Cons ((44l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((97l),Cons ((114l),Cons ((103l),Cons ((117l),Cons ((109l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((32l),Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((100l),Cons ((32l),Cons ((105l),Cons ((116l),Cons ((115l),Cons ((32l),Cons ((98l),Cons ((111l),Cons ((100l),Cons ((121l),Cons ((46l),Cons ((32l),Cons ((65l),Cons ((32l),Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((110l),Cons ((101l),Cons ((101l),Cons ((100l),Cons ((115l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((110l),Cons ((97l),Cons ((109l),Cons ((101l),Cons ((44l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((97l),Cons ((114l),Cons ((103l),Cons ((117l),Cons ((109l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((32l),Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((32l),Cons ((40l),Cons ((119l),Cons ((104l),Cons ((105l),Cons ((99l),Cons ((104l),Cons ((32l),Cons ((99l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((98l),Cons ((101l),Cons ((32l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Cons ((41l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((98l),Cons ((111l),Cons ((100l),Cons ((121l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((102l),Cons ((111l),Cons ((114l),Cons ((109l),Cons ((32l),Cons ((111l),Cons ((102l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((114l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((46l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_definition () = 
    (string_from_list (Cons ((79l),Cons ((110l),Cons ((108l),Cons ((121l),Cons ((32l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((45l),Cons ((32l),Cons ((111l),Cons ((114l),Cons ((32l),Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((32l),Cons ((99l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((98l),Cons ((101l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((112l),Cons ((32l),Cons ((108l),Cons ((101l),Cons ((118l),Cons ((101l),Cons ((108l),Cons ((32l),Cons ((111l),Cons ((102l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((46l),Cons ((32l),Cons ((89l),Cons ((111l),Cons ((117l),Cons ((32l),Cons ((110l),Cons ((101l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((32l),Cons ((119l),Cons ((114l),Cons ((97l),Cons ((112l),Cons ((32l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((114l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((46l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_type_definition () = 
    (string_from_list (Cons ((73l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((105l),Cons ((110l),Cons ((107l),Cons ((32l),Cons ((121l),Cons ((111l),Cons ((117l),Cons ((32l),Cons ((119l),Cons ((97l),Cons ((110l),Cons ((116l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((32l),Cons ((119l),Cons ((114l),Cons ((105l),Cons ((116l),Cons ((101l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((44l),Cons ((32l),Cons ((98l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((105l),Cons ((116l),Cons ((32l),Cons ((100l),Cons ((111l),Cons ((101l),Cons ((115l),Cons ((110l),Cons ((39l),Cons ((116l),Cons ((32l),Cons ((104l),Cons ((97l),Cons ((118l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((114l),Cons ((105l),Cons ((103l),Cons ((104l),Cons ((116l),Cons ((32l),Cons ((115l),Cons ((104l),Cons ((97l),Cons ((112l),Cons ((101l),Cons ((46l),Cons ((32l),Cons ((73l),Cons ((116l),Cons ((32l),Cons ((115l),Cons ((104l),Cons ((111l),Cons ((117l),Cons ((108l),Cons ((100l),Cons ((32l),Cons ((108l),Cons ((111l),Cons ((111l),Cons ((107l),Cons ((32l),Cons ((108l),Cons ((105l),Cons ((107l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((58l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_type_definition_ex () = 
    (string_from_list (Cons ((40l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((110l),Cons ((97l),Cons ((109l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((78l),Cons ((97l),Cons ((109l),Cons ((101l),Cons ((79l),Cons ((102l),Cons ((67l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Cons ((32l),Cons ((46l),Cons ((46l),Cons ((46l),Cons ((41l),Empty)))))))))))))))))))))))))))))))))))))))))));;

let rec data_type_definition_missing_name () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((109l),Cons ((105l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((105l),Cons ((116l),Cons ((115l),Cons ((32l),Cons ((110l),Cons ((97l),Cons ((109l),Cons ((101l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Cons ((46l),Cons ((32l),Cons ((65l),Cons ((32l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((110l),Cons ((101l),Cons ((101l),Cons ((100l),Cons ((115l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((110l),Cons ((97l),Cons ((109l),Cons ((101l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((116l),Cons ((32l),Cons ((108l),Cons ((101l),Cons ((97l),Cons ((115l),Cons ((116l),Cons ((32l),Cons ((111l),Cons ((110l),Cons ((101l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Cons ((46l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_type_definition_missing_constructors () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((109l),Cons ((105l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((32l),Cons ((111l),Cons ((102l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Cons ((115l),Cons ((46l),Cons ((32l),Cons ((65l),Cons ((32l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((110l),Cons ((101l),Cons ((101l),Cons ((100l),Cons ((115l),Cons ((32l),Cons ((97l),Cons ((116l),Cons ((32l),Cons ((108l),Cons ((101l),Cons ((97l),Cons ((115l),Cons ((116l),Cons ((32l),Cons ((111l),Cons ((110l),Cons ((101l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Cons ((46l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_pattern () = 
    (string_from_list (Cons ((73l),Cons ((32l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((112l),Cons ((97l),Cons ((116l),Cons ((116l),Cons ((101l),Cons ((114l),Cons ((110l),Cons ((32l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((98l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((100l),Cons ((111l),Cons ((101l),Cons ((115l),Cons ((110l),Cons ((39l),Cons ((116l),Cons ((32l),Cons ((108l),Cons ((111l),Cons ((111l),Cons ((107l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((114l),Cons ((114l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((46l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_match_expression () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Cons ((32l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((114l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((105l),Cons ((115l),Cons ((32l),Cons ((110l),Cons ((111l),Cons ((116l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((114l),Cons ((114l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((44l),Cons ((32l),Cons ((109l),Cons ((97l),Cons ((107l),Cons ((101l),Cons ((32l),Cons ((115l),Cons ((117l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((121l),Cons ((111l),Cons ((117l),Cons ((32l),Cons ((104l),Cons ((97l),Cons ((118l),Cons ((101l),Cons ((32l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((112l),Cons ((97l),Cons ((114l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((115l),Cons ((101l),Cons ((115l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((114l),Cons ((114l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((108l),Cons ((121l),Cons ((32l),Cons ((115l),Cons ((111l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((116l),Cons ((32l),Cons ((97l),Cons ((108l),Cons ((108l),Cons ((32l),Cons ((121l),Cons ((111l),Cons ((117l),Cons ((114l),Cons ((32l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Cons ((32l),Cons ((114l),Cons ((117l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((101l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((32l),Cons ((112l),Cons ((97l),Cons ((105l),Cons ((114l),Cons ((115l),Cons ((58l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_symbol () = 
    (string_from_list (Cons ((69l),Cons ((120l),Cons ((112l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((110l),Cons ((32l),Cons ((105l),Cons ((100l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((102l),Cons ((105l),Cons ((101l),Cons ((114l),Cons ((32l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((58l),Empty))))))))))))))))))))))))))))));;

let rec data_malformed_constructor () = 
    (string_from_list (Cons ((69l),Cons ((120l),Cons ((112l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Cons ((32l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((58l),Empty))))))))))))))))))))))))))))));;

let rec data_malformed_type () = 
    (string_from_list (Cons ((69l),Cons ((120l),Cons ((112l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((101l),Cons ((100l),Cons ((32l),Cons ((97l),Cons ((32l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((32l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((58l),Empty)))))))))))))))))))))));;

let rec data_too_few_closing_brackets () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((97l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((111l),Cons ((32l),Cons ((102l),Cons ((101l),Cons ((119l),Cons ((32l),Cons ((99l),Cons ((108l),Cons ((111l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((112l),Cons ((97l),Cons ((114l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((115l),Cons ((101l),Cons ((115l),Cons ((46l),Empty))))))))))))))))))))))))))))))))))))))));;

let rec data_too_many_closing_brackets () = 
    (string_from_list (Cons ((84l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((97l),Cons ((114l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((111l),Cons ((32l),Cons ((109l),Cons ((97l),Cons ((110l),Cons ((121l),Cons ((32l),Cons ((99l),Cons ((108l),Cons ((111l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((112l),Cons ((97l),Cons ((114l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((115l),Cons ((101l),Cons ((115l),Cons ((46l),Empty)))))))))))))))))))))))))))))))))))))))));;

let rec data_no_location_information () = 
    (string_from_list (Cons ((40l),Cons ((78l),Cons ((111l),Cons ((32l),Cons ((108l),Cons ((111l),Cons ((99l),Cons ((97l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((102l),Cons ((111l),Cons ((114l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((97l),Cons ((118l),Cons ((97l),Cons ((105l),Cons ((108l),Cons ((97l),Cons ((98l),Cons ((108l),Cons ((101l),Cons ((41l),Empty)))))))))))))))))))))))))))))))))))));;

let rec data_line () = 
    (string_from_list (Cons ((76l),Cons ((105l),Cons ((110l),Cons ((101l),Cons ((58l),Cons ((32l),Empty))))))));;

let rec data_column () = 
    (string_from_list (Cons ((67l),Cons ((111l),Cons ((108l),Cons ((117l),Cons ((109l),Cons ((110l),Cons ((58l),Cons ((32l),Empty))))))))));;

let rec data_file () = 
    (string_from_list (Cons ((70l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((58l),Cons ((32l),Empty))))))));;

let rec data_range () = 
    (string_from_list (Cons ((82l),Cons ((97l),Cons ((110l),Cons ((103l),Cons ((101l),Cons ((58l),Cons ((32l),Empty)))))))));;

let rec string_format list30 = 
    (string_join (string_of_char (10l)) (list_map (string_join (string_empty ())) list30));;

let rec file_matches_reference source_reference30 file15 = 
    (file15 |> source_file_path |> (string_equal (source_reference_file_path source_reference30)));;

let rec find_file_matching files6 source_reference31 = 
    (list_find_first (file_matches_reference source_reference31) files6);;

let rec range_information range110 = 
    (match range110 with
         | (Range (start2, end2)) -> 
            (string_join (string_of_char (45l)) (Cons ((string_from_int32 start2),Cons ((string_from_int32 end2),Empty)))));;

let rec count_lines index19 lines2 source = 
    (match (string_index_of index19 (string_of_char (10l)) source) with
         | (Some (index20)) -> 
            (count_lines (Int32.add index20 (1l)) (Int32.add lines2 (1l)) source)
         | None -> 
            (Pair (lines2, (Int32.add (Int32.sub (string_size source) index19) (1l)))));;

let rec line_information file16 range111 = 
    (match range111 with
         | (Range (start3, x480)) -> 
            (match (string_from_slice (source_file_content file16)) with
                 | content5 -> 
                    (count_lines (0l) (1l) (string_substring (0l) start3 content5))));;

let rec next_newline content6 index21 = 
    (match (string_index_of index21 (string_of_char (10l)) content6) with
         | (Some (index22)) -> 
            (Int32.add index22 (1l))
         | None -> 
            index21);;

let rec source_paragraph file17 range112 = 
    (match range112 with
         | (Range (start4, end3)) -> 
            (match (string_from_slice (source_file_content file17)) with
                 | content7 -> 
                    (match (next_newline content7 (Int32.sub start4 (100l))) with
                         | paragraph_start -> 
                            (match (Int32.sub (next_newline content7 (Int32.add end3 (50l))) paragraph_start) with
                                 | paragraph_size -> 
                                    (string_substring paragraph_start paragraph_size content7)))));;

let rec location_information files7 source_reference32 range113 = 
    (match (find_file_matching files7 source_reference32) with
         | (Some (file18)) -> 
            (match (line_information file18 range113) with
                 | (Pair (lines3, column)) -> 
                    (string_format (Cons (Empty,Cons ((Cons ((source_paragraph file18 range113),Empty)),Cons (Empty,Cons ((Cons ((data_line ()),Cons ((string_from_int32 lines3),Empty))),Cons ((Cons ((data_column ()),Cons ((string_from_int32 column),Empty))),Cons ((Cons ((data_range ()),Cons ((range_information range113),Empty))),Cons ((Cons ((data_file ()),Cons ((source_file_path file18),Empty))),Empty))))))))))
         | None -> 
            (data_no_location_information ()));;

let rec error_to_string files8 error18 = 
    (match error18 with
         | (InternalParserError (source_reference33, range114)) -> 
            (string_format (Cons ((Cons ((data_internal_error ()),Empty)),Cons ((Cons ((location_information files8 source_reference33 range114),Empty)),Empty))))
         | (MalformedExpressionError (source_reference34, range115)) -> 
            (string_format (Cons ((Cons ((data_malformed_expression ()),Empty)),Cons ((Cons ((location_information files8 source_reference34 range115),Empty)),Empty))))
         | (MalformedDefinitionError (source_reference35, range116)) -> 
            (string_format (Cons ((Cons ((data_malformed_definition ()),Empty)),Cons ((Cons ((location_information files8 source_reference35 range116),Empty)),Empty))))
         | (MalformedFunctionDefinitionError (source_reference36, range117)) -> 
            (string_format (Cons ((Cons ((data_malformed_function_definition ()),Empty)),Cons ((Cons ((location_information files8 source_reference36 range117),Empty)),Empty))))
         | (FunctionDefinitionMissingName (source_reference37, range118)) -> 
            (string_format (Cons ((Cons ((data_function_definition_missing_name ()),Empty)),Cons ((Cons ((location_information files8 source_reference37 range118),Empty)),Empty))))
         | (MalformedTypeDefinitionError (source_reference38, range119)) -> 
            (string_format (Cons ((Cons ((data_malformed_type_definition ()),Empty)),Cons (Empty,Cons ((Cons ((data_malformed_type_definition_ex ()),Empty)),Cons ((Cons ((location_information files8 source_reference38 range119),Empty)),Empty))))))
         | (TypeDefinitionMissingName (source_reference39, range120)) -> 
            (string_format (Cons ((Cons ((data_type_definition_missing_name ()),Empty)),Cons ((Cons ((location_information files8 source_reference39 range120),Empty)),Empty))))
         | (TypeDefinitionMissingConstructors (source_reference40, range121)) -> 
            (string_format (Cons ((Cons ((data_type_definition_missing_constructors ()),Empty)),Cons ((Cons ((location_information files8 source_reference40 range121),Empty)),Empty))))
         | (MalformedPatternError (source_reference41, range122)) -> 
            (string_format (Cons ((Cons ((data_malformed_pattern ()),Empty)),Cons ((Cons ((location_information files8 source_reference41 range122),Empty)),Empty))))
         | (MalformedMatchExpressionError (source_reference42, range123)) -> 
            (string_format (Cons ((Cons ((data_malformed_match_expression ()),Empty)),Cons ((Cons ((location_information files8 source_reference42 range123),Empty)),Empty))))
         | (MalformedSymbolError (source_reference43, range124)) -> 
            (string_format (Cons ((Cons ((data_malformed_symbol ()),Empty)),Cons ((Cons ((location_information files8 source_reference43 range124),Empty)),Empty))))
         | (MalformedConstructorError (source_reference44, range125)) -> 
            (string_format (Cons ((Cons ((data_malformed_constructor ()),Empty)),Cons ((Cons ((location_information files8 source_reference44 range125),Empty)),Empty))))
         | (MalformedTypeError (source_reference45, range126)) -> 
            (string_format (Cons ((Cons ((data_malformed_type ()),Empty)),Cons ((Cons ((location_information files8 source_reference45 range126),Empty)),Empty))))
         | (ErrorNotDefined (name52, source_reference46, range127)) -> 
            (string_format (Cons ((Cons ((string_concat (data_not_defined_error ()) name52),Empty)),Cons ((Cons ((location_information files8 source_reference46 range127),Empty)),Empty))))
         | (ErrorNotAccessible (name53, source_reference47, range128)) -> 
            (string_format (Cons ((Cons ((string_concat (data_not_accessible_error ()) name53),Empty)),Cons ((Cons ((location_information files8 source_reference47 range128),Empty)),Empty))))
         | (ErrorAlreadyDefined (name54, source_reference48, range129)) -> 
            (string_format (Cons ((Cons ((string_concat (data_already_defined_error ()) name54),Empty)),Cons ((Cons ((location_information files8 source_reference48 range129),Empty)),Empty))))
         | (ErrorReservedIdentifier (name55, source_reference49, range130)) -> 
            (string_format (Cons ((Cons ((string_concat (data_reserved_identifier_error ()) name55),Empty)),Cons ((Cons ((location_information files8 source_reference49 range130),Empty)),Empty))))
         | MalformedSexpTooFewClosingBrackets -> 
            (string_format (Cons ((Cons ((data_too_few_closing_brackets ()),Empty)),Empty)))
         | MalformedSexpTooManyClosingBrackets -> 
            (string_format (Cons ((Cons ((data_too_many_closing_brackets ()),Empty)),Empty))));;

let rec data_17 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec path_filename path4 = 
    (match (list_last (string_split (47l) path4)) with
         | (Some (filename)) -> 
            filename
         | None -> 
            path4);;

let rec path_filename_without_extension path5 = 
    (match (list_first (string_split (46l) (path_filename path5))) with
         | (Some (name56)) -> 
            name56
         | None -> 
            (path_filename path5));;

let rec path_filename_extension path6 = 
    (match (list_last (string_split (46l) (path_filename path6))) with
         | (Some (name57)) -> 
            name57
         | None -> 
            (string_empty ()));;

let rec path_join paths = 
    (string_join (data_17 ()) paths);;

let rec data_standard_library_filename () = 
    (string_from_list (Cons ((115l),Cons ((116l),Cons ((97l),Cons ((110l),Cons ((100l),Cons ((97l),Cons ((114l),Cons ((100l),Cons ((45l),Cons ((108l),Cons ((105l),Cons ((98l),Cons ((114l),Cons ((97l),Cons ((114l),Cons ((121l),Cons ((46l),Cons ((114l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Empty))))))))))))))))))))))));;

let rec data_parser_filename () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((101l),Cons ((114l),Cons ((46l),Cons ((114l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Empty))))))))))))));;

let rec data_18 () = 
    (string_from_list Empty);;

let rec generate backend7 module_name2 definitions10 = 
    (result_map (compiler_backend_generate_source backend7 module_name2) definitions10);;

let rec module_name_and_path open2 path7 = 
    (Pair ((ModulePath ((path_filename_without_extension path7), open2)), path7));;

let rec standard_library_files backend8 data_path = 
    (Cons ((path_join (Cons (data_path,Cons ((data_standard_library_filename ()),Empty)))), (list_map (fun filename2 -> (path_join (Cons (data_path,Cons (filename2,Empty))))) (compiler_backend_pervasives_files backend8))));;

let rec standard_library_module backend9 data_path2 = 
    (list_map (module_name_and_path True) (standard_library_files backend9 data_path2));;

let rec parser_module backend10 data_path3 = 
    (module_name_and_path True (path_join (Cons (data_path3,Cons ((data_parser_filename ()),Empty)))));;

let rec preamble_files backend11 data_path4 = 
    (list_map (fun filename3 -> (Pair (ModuleSelf, (string_concat data_path4 filename3)))) (compiler_backend_preamble_files backend11));;

let rec data_space2 () = 
    (string_from_list (Cons ((32l),Empty)));;

let rec data_fun2 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Empty)))));;

let rec data_type2 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_if2 () = 
    (string_from_list (Cons ((105l),Cons ((102l),Empty))));;

let rec data_then2 () = 
    (string_from_list (Cons ((116l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_else2 () = 
    (string_from_list (Cons ((101l),Cons ((108l),Cons ((115l),Cons ((101l),Empty))))));;

let rec data_with2 () = 
    (string_from_list (Cons ((119l),Cons ((105l),Cons ((116l),Cons ((104l),Empty))))));;

let rec data_of2 () = 
    (string_from_list (Cons ((111l),Cons ((102l),Empty))));;

let rec data_class2 () = 
    (string_from_list (Cons ((99l),Cons ((108l),Cons ((97l),Cons ((115l),Cons ((115l),Empty)))))));;

let rec data_end2 () = 
    (string_from_list (Cons ((101l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_in2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Empty))));;

let rec data_let2 () = 
    (string_from_list (Cons ((108l),Cons ((101l),Cons ((116l),Empty)))));;

let rec data_open2 () = 
    (string_from_list (Cons ((111l),Cons ((112l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_and2 () = 
    (string_from_list (Cons ((97l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_or2 () = 
    (string_from_list (Cons ((111l),Cons ((114l),Empty))));;

let rec data_as2 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Empty))));;

let rec data_less_than2 () = 
    (string_from_list (Cons ((60l),Empty)));;

let rec data_assert2 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((115l),Cons ((101l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_asr2 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_begin2 () = 
    (string_from_list (Cons ((98l),Cons ((101l),Cons ((103l),Cons ((105l),Cons ((110l),Empty)))))));;

let rec data_constraint2 () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((97l),Cons ((105l),Cons ((110l),Cons ((116l),Empty))))))))))));;

let rec data_do2 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Empty))));;

let rec data_done2 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((110l),Cons ((101l),Empty))))));;

let rec data_downto2 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((119l),Cons ((110l),Cons ((116l),Cons ((111l),Empty))))))));;

let rec data_exception2 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((99l),Cons ((101l),Cons ((112l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty)))))))))));;

let rec data_external2 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((116l),Cons ((101l),Cons ((114l),Cons ((110l),Cons ((97l),Cons ((108l),Empty))))))))));;

let rec data_false2 () = 
    (string_from_list (Cons ((102l),Cons ((97l),Cons ((108l),Cons ((115l),Cons ((101l),Empty)))))));;

let rec data_true3 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))));;

let rec data_for2 () = 
    (string_from_list (Cons ((102l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_function2 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty))))))))));;

let rec data_functor2 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Empty)))))))));;

let rec data_include2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((99l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Empty)))))))));;

let rec data_inherit2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((105l),Cons ((116l),Empty)))))))));;

let rec data_initializer2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((97l),Cons ((108l),Cons ((105l),Cons ((122l),Cons ((101l),Cons ((114l),Empty)))))))))))));;

let rec data_land2 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((110l),Cons ((100l),Empty))))));;

let rec data_lazy2 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((122l),Cons ((121l),Empty))))));;

let rec data_lor2 () = 
    (string_from_list (Cons ((108l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_lsl2 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((108l),Empty)))));;

let rec data_lsr2 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_lxor2 () = 
    (string_from_list (Cons ((108l),Cons ((120l),Cons ((111l),Cons ((114l),Empty))))));;

let rec data_method2 () = 
    (string_from_list (Cons ((109l),Cons ((101l),Cons ((116l),Cons ((104l),Cons ((111l),Cons ((100l),Empty))))))));;

let rec data_mod2 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Empty)))));;

let rec data_module2 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec data_mutable2 () = 
    (string_from_list (Cons ((109l),Cons ((117l),Cons ((116l),Cons ((97l),Cons ((98l),Cons ((108l),Cons ((101l),Empty)))))))));;

let rec data_new2 () = 
    (string_from_list (Cons ((110l),Cons ((101l),Cons ((119l),Empty)))));;

let rec data_nonrec2 () = 
    (string_from_list (Cons ((110l),Cons ((111l),Cons ((110l),Cons ((114l),Cons ((101l),Cons ((99l),Empty))))))));;

let rec data_object2 () = 
    (string_from_list (Cons ((111l),Cons ((98l),Cons ((106l),Cons ((101l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_private2 () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((105l),Cons ((118l),Cons ((97l),Cons ((116l),Cons ((101l),Empty)))))))));;

let rec data_rec2 () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((99l),Empty)))));;

let rec data_sig2 () = 
    (string_from_list (Cons ((115l),Cons ((105l),Cons ((103l),Empty)))));;

let rec data_struct2 () = 
    (string_from_list (Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_try2 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((121l),Empty)))));;

let rec data_val2 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Empty)))));;

let rec data_virtual2 () = 
    (string_from_list (Cons ((118l),Cons ((105l),Cons ((114l),Cons ((116l),Cons ((117l),Cons ((97l),Cons ((108l),Empty)))))))));;

let rec data_when2 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_while2 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((105l),Cons ((108l),Cons ((101l),Empty)))))));;

let rec data_parser2 () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((101l),Cons ((114l),Empty))))))));;

let rec data_value2 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Cons ((117l),Cons ((101l),Empty)))))));;

let rec data_to2 () = 
    (string_from_list (Cons ((116l),Cons ((111l),Empty))));;

let rec data_def4 () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Empty)))));;

let rec data_typ4 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Empty)))));;

let rec data_fn4 () = 
    (string_from_list (Cons ((102l),Cons ((110l),Empty))));;

let rec data_match4 () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_exists4 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((115l),Empty))))))));;

let rec data_pub4 () = 
    (string_from_list (Cons ((112l),Cons ((117l),Cons ((98l),Empty)))));;

let rec data_19 () = 
    (string_from_list (Cons ((43l),Empty)));;

let rec data__4 () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_20 () = 
    (string_from_list (Cons ((42l),Empty)));;

let rec data_21 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec data_22 () = 
    (string_from_list (Cons ((37l),Empty)));;

let rec data_23 () = 
    (string_from_list (Cons ((38l),Empty)));;

let rec data_int32_less_than4 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((45l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((45l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((110l),Empty)))))))))))))))));;

let rec data_pipe5 () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_dot4 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_list5 () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_slice_empty4 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))))))))));;

let rec data_slice_of_u84 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((117l),Cons ((56l),Empty)))))))))))));;

let rec data_slice_size4 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Empty))))))))))));;

let rec data_slice_get4 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((103l),Cons ((101l),Cons ((116l),Empty)))))))))));;

let rec data_slice_concat4 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((99l),Cons ((97l),Cons ((116l),Empty))))))))))))));;

let rec data_slice_foldl4 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((100l),Cons ((108l),Empty)))))))))))));;

let rec data_slice_subslice4 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((117l),Cons ((98l),Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty))))))))))))))));;

let rec data_slice4 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_int324 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec data_compile_error () = 
    (string_from_list (Cons ((42l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((32l),Cons ((101l),Cons ((114l),Cons ((114l),Cons ((111l),Cons ((114l),Cons ((42l),Empty)))))))))))))))));;

let rec data_backslash () = 
    (string_from_list (Cons ((92l),Empty)));;

let rec data_arrow () = 
    (string_from_list (Cons ((32l),Cons ((45l),Cons ((62l),Cons ((32l),Empty))))));;

let rec data_equals () = 
    (string_from_list (Cons ((32l),Cons ((61l),Cons ((32l),Empty)))));;

let rec data_vertical_bar () = 
    (string_from_list (Cons ((32l),Cons ((124l),Cons ((32l),Empty)))));;

let rec data_dollar_operator () = 
    (string_from_list (Cons ((32l),Cons ((36l),Cons ((32l),Empty)))));;

let rec data_colon () = 
    (string_from_list (Cons ((32l),Cons ((58l),Cons ((32l),Empty)))));;

let rec data_semicolon () = 
    (string_from_list (Cons ((32l),Cons ((59l),Cons ((32l),Empty)))));;

let rec data_star () = 
    (string_from_list (Cons ((32l),Cons ((42l),Cons ((32l),Empty)))));;

let rec data_dot_operator () = 
    (string_from_list (Cons ((32l),Cons ((46l),Cons ((32l),Empty)))));;

let rec data_int325 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec data_int32_plus () = 
    (string_from_list (Cons ((95l),Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((97l),Cons ((100l),Cons ((100l),Empty))))))))))));;

let rec data_int32_multiply () = 
    (string_from_list (Cons ((95l),Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((109l),Cons ((117l),Cons ((108l),Empty))))))))))));;

let rec data_int32_minus () = 
    (string_from_list (Cons ((95l),Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((115l),Cons ((117l),Cons ((98l),Empty))))))))))));;

let rec data_int32_divide () = 
    (string_from_list (Cons ((80l),Cons ((114l),Cons ((101l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Cons ((46l),Cons ((113l),Cons ((117l),Cons ((111l),Cons ((116l),Empty))))))))))))));;

let rec data_int32_modulus () = 
    (string_from_list (Cons ((80l),Cons ((114l),Cons ((101l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Cons ((46l),Cons ((114l),Cons ((101l),Cons ((109l),Empty)))))))))))));;

let rec data_int32_and () = 
    (string_from_list (Cons ((95l),Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((97l),Cons ((110l),Cons ((100l),Empty))))))))))));;

let rec data_slice_type () = 
    (string_from_list (Cons ((66l),Cons ((121l),Cons ((116l),Cons ((101l),Cons ((115l),Empty)))))));;

let rec data_cempty () = 
    (string_from_list (Cons ((67l),Cons ((69l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty))))))));;

let rec data_ccons () = 
    (string_from_list (Cons ((67l),Cons ((67l),Cons ((111l),Cons ((110l),Cons ((115l),Empty)))))));;

let rec data_comma () = 
    (string_from_list (Cons ((44l),Empty)));;

let rec data_constant () = 
    (string_from_list (Cons ((95l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((97l),Cons ((110l),Cons ((116l),Cons ((95l),Empty))))))))))));;

let rec data_data () = 
    (string_from_list (Cons ((100l),Cons ((97l),Cons ((116l),Cons ((97l),Empty))))));;

let rec data_case () = 
    (string_from_list (Cons ((99l),Cons ((97l),Cons ((115l),Cons ((101l),Empty))))));;

let rec data_deriving () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((114l),Cons ((105l),Cons ((118l),Cons ((105l),Cons ((110l),Cons ((103l),Empty))))))))));;

let rec data_family () = 
    (string_from_list (Cons ((102l),Cons ((97l),Cons ((109l),Cons ((105l),Cons ((108l),Cons ((121l),Empty))))))));;

let rec data_default () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Cons ((97l),Cons ((117l),Cons ((108l),Cons ((116l),Empty)))))))));;

let rec data_forall () = 
    (string_from_list (Cons ((102l),Cons ((111l),Cons ((114l),Cons ((97l),Cons ((108l),Cons ((108l),Empty))))))));;

let rec data_foreign () = 
    (string_from_list (Cons ((102l),Cons ((111l),Cons ((114l),Cons ((101l),Cons ((105l),Cons ((103l),Cons ((110l),Empty)))))))));;

let rec data_import () = 
    (string_from_list (Cons ((105l),Cons ((109l),Cons ((112l),Cons ((111l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_instance () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((97l),Cons ((110l),Cons ((99l),Cons ((101l),Empty))))))))));;

let rec data_infix () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((102l),Cons ((105l),Cons ((120l),Empty)))))));;

let rec data_infixl () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((102l),Cons ((105l),Cons ((120l),Cons ((108l),Empty))))))));;

let rec data_infixr () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((102l),Cons ((105l),Cons ((120l),Cons ((114l),Empty))))))));;

let rec data_newtype () = 
    (string_from_list (Cons ((110l),Cons ((101l),Cons ((119l),Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Empty)))))))));;

let rec data_where () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((101l),Empty)))))));;

let rec data_24 () = 
    (string_from_list (Cons ((58l),Cons ((58l),Empty))));;

let rec data_open_bracket2 () = 
    (string_from_list (Cons ((40l),Empty)));;

let rec data_close_bracket2 () = 
    (string_from_list (Cons ((41l),Empty)));;

let rec data_dot5 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_language_exts () = 
    (string_from_list (Cons ((123l),Cons ((45l),Cons ((35l),Cons ((32l),Cons ((76l),Cons ((65l),Cons ((78l),Cons ((71l),Cons ((85l),Cons ((65l),Cons ((71l),Cons ((69l),Cons ((32l),Cons ((69l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((97l),Cons ((108l),Cons ((81l),Cons ((117l),Cons ((97l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((102l),Cons ((105l),Cons ((99l),Cons ((97l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((35l),Cons ((45l),Cons ((125l),Empty))))))))))))))))))))))))))))))))))))))))))));;

let rec data_pervasives_filename () = 
    (string_from_list (Cons ((80l),Cons ((101l),Cons ((114l),Cons ((118l),Cons ((97l),Cons ((115l),Cons ((105l),Cons ((118l),Cons ((101l),Cons ((115l),Cons ((46l),Cons ((104l),Cons ((115l),Empty)))))))))))))));;

let rec data_preamble_filename () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((101l),Cons ((97l),Cons ((109l),Cons ((98l),Cons ((108l),Cons ((101l),Cons ((46l),Cons ((104l),Cons ((115l),Empty)))))))))))));;

let rec data_haskell_language () = 
    (string_from_list (Cons ((104l),Cons ((97l),Cons ((115l),Cons ((107l),Cons ((101l),Cons ((108l),Cons ((108l),Empty)))))))));;

let rec data_x () = 
    (string_from_list (Cons ((120l),Cons ((39l),Empty))));;

let rec data_empty () = 
    (string_from_list (Cons ((69l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))));;

let rec data_cons () = 
    (string_from_list (Cons ((67l),Cons ((111l),Cons ((110l),Cons ((115l),Empty))))));;

let rec reserved_identifiers () = 
    (list_flatten (Cons ((Cons (data_if2,Cons (data_then2,Cons (data_else2,Cons (data_with2,Cons (data_of2,Cons (data_end2,Cons (data_in2,Empty)))))))),Cons ((Cons (data_type2,Cons (data_let2,Cons (data_class2,Cons (data_do2,Cons (data_module2,Cons (data_data,Empty))))))),Cons ((Cons (data_case,Cons (data_deriving,Cons (data_family,Cons (data_default,Cons (data_forall,Empty)))))),Cons ((Cons (data_foreign,Cons (data_import,Cons (data_instance,Cons (data_infix,Cons (data_infixl,Empty)))))),Cons ((Cons (data_infixr,Cons (data_newtype,Cons (data_where,Empty)))),Empty)))))));;

let rec escape_identifier identifier63 = 
    (SourceStringIdentifier (identifier63, IdentifierTransformationLowercase));;

let rec translate_constructor_identifier constructor14 = 
    (SourceStringIdentifier (constructor14, IdentifierTransformationCapitalize));;

let rec operator_translation_map () = 
    (dictionary_of (Cons ((Pair ((data_19 ()), (SourceString ((data_int32_plus ()))))),Cons ((Pair ((data__4 ()), (SourceString ((data_int32_minus ()))))),Cons ((Pair ((data_20 ()), (SourceString ((data_int32_multiply ()))))),Cons ((Pair ((data_21 ()), (SourceString ((data_int32_divide ()))))),Cons ((Pair ((data_22 ()), (SourceString ((data_int32_modulus ()))))),Cons ((Pair ((data_23 ()), (SourceString ((data_int32_and ()))))),Empty))))))));;

let rec translate_identifier identifier64 = 
    (match (identifier_is_operator identifier64) with
         | True -> 
            (match (dictionary_get (identifier_name identifier64) (operator_translation_map ())) with
                 | (Some (translation)) -> 
                    translation
                 | None -> 
                    (escape_identifier identifier64))
         | False -> 
            (escape_identifier identifier64));;

let rec prefix_type_variable identifier65 = 
    (SourceStringIdentifier (identifier65, IdentifierTransformationLowercase));;

let rec prefix_type identifier66 = 
    (match (identifier_is (identifier_slice ()) identifier66) with
         | True -> 
            (SourceString ((data_slice_type ())))
         | False -> 
            (match (identifier_is (identifier_int32 ()) identifier66) with
                 | True -> 
                    (SourceString ((data_int325 ())))
                 | False -> 
                    (SourceStringIdentifier (identifier66, IdentifierTransformationCapitalize))));;

let rec translate_less_than translate_expression expressions44 = 
    (match expressions44 with
         | (Cons (a73, (Cons (b68, (Cons (then_case, (Cons (else_case, Empty)))))))) -> 
            (join (Cons ((SourceString ((data_if2 ()))),Cons ((source_space ()),Cons ((SourceString ((data_open_bracket2 ()))),Cons ((translate_expression a73),Cons ((SourceString ((data_24 ()))),Cons ((SourceString ((data_int325 ()))),Cons ((SourceString ((data_close_bracket2 ()))),Cons ((SourceString ((data_less_than2 ()))),Cons ((SourceString ((data_open_bracket2 ()))),Cons ((translate_expression b68),Cons ((SourceString ((data_24 ()))),Cons ((SourceString ((data_int325 ()))),Cons ((SourceString ((data_close_bracket2 ()))),Cons ((source_space ()),Cons ((SourceString ((data_then2 ()))),Cons ((source_space ()),Cons ((translate_expression then_case),Cons ((source_space ()),Cons ((SourceString ((data_else2 ()))),Cons ((source_space ()),Cons ((translate_expression else_case),Empty)))))))))))))))))))))))
         | x481 -> 
            (SourceString ((data_compile_error ()))));;

let rec translate_constructor translator name58 constructor15 = 
    (constructor15 |> (list_map translator) |> (source_string_join (data_space2 ())) |> (fun parameters15 -> (Cons ((translate_constructor_identifier name58),Cons ((source_space ()),Cons (parameters15,Empty))))) |> join |> wrap_in_brackets2);;

let rec translate_pattern pattern18 = 
    (match pattern18 with
         | (Capture (identifier67)) -> 
            (escape_identifier identifier67)
         | (IntegerPattern (integer7, x482)) -> 
            (match (x2 integer7 (0l)) with
                 | True -> 
                    (SourceString ((wrap_in_brackets (string_from_int32 integer7))))
                 | False -> 
                    (SourceString ((string_from_int32 integer7))))
         | (ConstructorPattern (identifier68, Empty, x483)) -> 
            (translate_constructor_identifier identifier68)
         | (ConstructorPattern (identifier69, patterns9, x484)) -> 
            ((translate_constructor translate_pattern identifier69) patterns9));;

let rec translate_rule translate_expression2 n11 rule5 = 
    (match rule5 with
         | (Pair (pattern19, expression57)) -> 
            (join_lines (Cons ((line n11 (Cons ((translate_pattern pattern19),Cons ((SourceString ((data_arrow ()))),Empty)))),Cons ((line (Int32.add n11 (1l)) (Cons ((translate_expression2 (Int32.add n11 (1l)) expression57),Empty))),Empty)))));;

let rec translate_match_expression translate_expression3 n12 expression58 rules10 = 
    (rules10 |> (list_map (translate_rule translate_expression3 n12)) |> (source_string_join (string_empty ())) |> (fun rules11 -> (Cons ((SourceString ((data_case ()))),Cons ((source_space ()),Cons ((translate_expression3 n12 expression58),Cons ((source_space ()),Cons ((SourceString ((data_of2 ()))),Cons (rules11,Empty)))))))) |> (source_string_join (string_empty ())));;

let rec translate_function_application translate_expression4 expressions45 = 
    (match expressions45 with
         | (Cons (no_args_function, Empty)) -> 
            (translate_expression4 no_args_function)
         | x485 -> 
            (source_string_join (data_space2 ()) (list_map translate_expression4 expressions45)));;

let rec translate_function_application2 translate_expression5 expressions46 = 
    (match expressions46 with
         | (Cons ((Variable (identifier70)), rest27)) -> 
            (match (identifier_is (identifier_int32_less_than ()) identifier70) with
                 | True -> 
                    (translate_less_than translate_expression5 rest27)
                 | False -> 
                    (translate_function_application translate_expression5 expressions46))
         | x486 -> 
            (translate_function_application translate_expression5 expressions46));;

let rec translate_argument_list arguments21 = 
    (source_string_join (data_space2 ()) (list_map escape_identifier arguments21));;

let rec translate_lambda translate_expression6 arguments22 expression59 = 
    (match (list_is_empty arguments22) with
         | True -> 
            (translate_expression6 expression59)
         | False -> 
            (join (Cons ((SourceString ((data_backslash ()))),Cons ((source_space ()),Cons ((translate_argument_list arguments22),Cons ((SourceString ((data_arrow ()))),Cons ((translate_expression6 expression59),Empty))))))));;

let rec translate_list_expression translate_expression7 expressions47 = 
    (list_foldr (fun expression60 source2 -> (wrap_in_brackets2 (join (Cons ((SourceString ((data_cons ()))),Cons ((SourceString ((data_space2 ()))),Cons ((translate_expression7 expression60),Cons ((SourceString ((data_space2 ()))),Cons (source2,Empty))))))))) (SourceString ((data_empty ()))) expressions47);;

let rec translate_expression8 n13 expression61 = 
    (match expression61 with
         | (Lambda (arguments23, expression62, x487)) -> 
            (wrap_in_brackets2 (translate_lambda (translate_expression8 n13) arguments23 expression62))
         | (Constructor (identifier71, Empty, x488)) -> 
            (translate_constructor_identifier identifier71)
         | (Constructor (identifier72, expressions48, x489)) -> 
            ((translate_constructor (translate_expression8 n13) identifier72) expressions48)
         | (FunctionApplication (expressions49, x490)) -> 
            (wrap_in_brackets2 (translate_function_application2 (translate_expression8 n13) expressions49))
         | (IntegerConstant (integer8, x491)) -> 
            (match (x2 integer8 (0l)) with
                 | True -> 
                    (SourceString ((wrap_in_brackets (string_from_int32 integer8))))
                 | False -> 
                    (SourceString ((string_from_int32 integer8))))
         | (Variable (identifier73)) -> 
            (translate_identifier identifier73)
         | (Match (expression63, rules12, x492)) -> 
            (wrap_in_brackets2 (translate_match_expression translate_expression8 (Int32.add n13 (1l)) expression63 rules12))
         | (ListExpression (expressions50, x493)) -> 
            (wrap_in_brackets2 (translate_list_expression (translate_expression8 n13) expressions50))
         | (Pipe (expressions51, x494)) -> 
            (wrap_in_brackets2 (source_string_join (data_dollar_operator ()) (list_reverse (list_map (translate_expression8 n13) expressions51))))
         | (Compose (expressions52, x495)) -> 
            (wrap_in_brackets2 (source_string_join (data_dot_operator ()) (list_map (translate_expression8 n13) expressions52))));;

let rec translate_function_definition name59 arguments24 expression64 = 
    (match (list_is_empty arguments24) with
         | True -> 
            ((line (0l)) (Cons (name59,Cons ((source_space ()),Cons ((SourceString ((data_equals ()))),Cons ((source_space ()),Cons ((translate_expression8 (0l) expression64),Empty)))))))
         | False -> 
            (join_lines (Cons (((line (0l)) (Cons (name59,Cons ((source_space ()),Cons ((translate_argument_list arguments24),Cons ((SourceString ((data_equals ()))),Empty)))))),Cons (((line (1l)) (Cons ((translate_expression8 (1l) expression64),Empty))),Empty)))));;

let rec type_parameter_equals identifier74 parameter6 = 
    (identifier_equal identifier74 (type_parameter_identifier parameter6));;

let rec translate_simple_type identifier75 parameters16 = 
    (match (list_any (type_parameter_equals identifier75) parameters16) with
         | False -> 
            (prefix_type identifier75)
         | True -> 
            (prefix_type_variable identifier75));;

let rec translate_complex_types translate_types name60 types13 = 
    (types13 |> (translate_types (data_space2 ())) |> (source_string_concat (source_string_concat (prefix_type name60) (source_space ()))) |> wrap_in_brackets2);;

let rec translate_function_type translate_types2 return_type5 argument_types4 = 
    (argument_types4 |> (fun argument_types5 -> (list_concat argument_types5 (Cons (return_type5,Empty)))) |> (translate_types2 (data_arrow ())) |> wrap_in_brackets2);;

let rec translate_type translate_types3 parameters17 type6 = 
    (match type6 with
         | (SimpleType (identifier76)) -> 
            (translate_simple_type identifier76 parameters17)
         | (ComplexType (identifier77, types14, x496)) -> 
            (translate_complex_types translate_types3 identifier77 types14)
         | (FunctionType (argument_types6, return_type6, x497)) -> 
            (translate_function_type translate_types3 return_type6 argument_types6));;

let rec translate_types4 parameters18 separator5 types15 = 
    (types15 |> (list_map (translate_type (translate_types4 parameters18) parameters18)) |> (source_string_join separator5));;

let rec translate_type_parameter parameter7 = 
    (match parameter7 with
         | (UniversalParameter (identifier78)) -> 
            (SourceString ((identifier_name identifier78)))
         | (ExistentialParameter (identifier79)) -> 
            (SourceString ((identifier_name identifier79))));;

let rec translate_complex_constructor_definition name61 types16 parameters19 = 
    (join (Cons ((translate_constructor_identifier name61),Cons ((source_space ()),Cons ((translate_types4 parameters19 (data_space2 ()) types16),Empty)))));;

let rec translate_constructor_definition parameters20 constructor16 = 
    (match constructor16 with
         | (SimpleConstructor (identifier80)) -> 
            (translate_constructor_identifier identifier80)
         | (ComplexConstructor (identifier81, types17, x498)) -> 
            (translate_complex_constructor_definition identifier81 types17 parameters20));;

let rec translate_constructor_definitions n14 parameters21 constructors17 = 
    (constructors17 |> (list_map (translate_constructor_definition parameters21)) |> (source_string_join (string_concat (newline ()) (string_concat (indent n14) (data_vertical_bar ())))));;

let rec append_universal_parameter parameter8 s3 = 
    (match parameter8 with
         | (UniversalParameter (identifier82)) -> 
            (join (Cons (s3,Cons ((source_space ()),Cons ((prefix_type_variable identifier82),Empty)))))
         | (ExistentialParameter (x499)) -> 
            s3);;

let rec append_existential_parameter parameter9 s4 = 
    (match parameter9 with
         | (UniversalParameter (x500)) -> 
            s4
         | (ExistentialParameter (identifier83)) -> 
            (join (Cons (s4,Cons ((SourceString ((data_forall ()))),Cons ((source_space ()),Cons ((prefix_type_variable identifier83),Cons ((SourceString ((data_dot5 ()))),Cons ((source_space ()),Empty)))))))));;

let rec translate_type_definition name62 parameters22 constructors18 = 
    (join_lines (Cons (((line (0l)) (Cons ((SourceString ((data_data ()))),Cons ((source_space ()),Cons ((prefix_type name62),Cons ((list_foldl append_universal_parameter (source_string_empty ()) parameters22),Cons ((SourceString ((data_equals ()))),Cons ((list_foldl append_existential_parameter (source_string_empty ()) parameters22),Empty)))))))),Cons (((line (1l)) (Cons ((SourceString ((string_repeat (data_space2 ()) (3l)))),Cons ((translate_constructor_definitions (1l) parameters22 constructors18),Empty)))),Empty))));;

let rec translate_definition definition12 = 
    (match definition12 with
         | (FunctionDefinition (name63, x501, arguments25, expression65, x502)) -> 
            (translate_function_definition (escape_identifier name63) arguments25 expression65)
         | (TypeDefinition (name64, x503, parameters23, constructors19, x504)) -> 
            (translate_type_definition name64 parameters23 constructors19)
         | (TargetDefinition (x505, data2)) -> 
            (SourceString ((string_from_slice data2))));;

let rec translate_module_declaration module_name3 = 
    (join (Cons ((SourceString ((data_module2 ()))),Cons ((source_space ()),Cons ((SourceString (module_name3)),Cons ((source_space ()),Cons ((SourceString ((data_where ()))),Empty)))))));;

let rec definition_to_public_identifier definition13 = 
    (match definition13 with
         | (FunctionDefinition (name65, True, x506, x507, x508)) -> 
            (Some ((Pair (IdentifierTransformationLowercase, name65))))
         | (TypeDefinition (name66, True, x509, x510, x511)) -> 
            (Some ((Pair (IdentifierTransformationCapitalize, name66))))
         | x512 -> 
            None);;

let rec public_identifiers_with_transformations definitions11 = 
    (list_flatmap (fun x' -> x' |> definition_to_public_identifier |> list_from_maybe) definitions11);;

let rec generate_source module_name4 definitions12 = 
    (definitions12 |> (list_map translate_definition) |> (list_cons (translate_module_declaration module_name4)) |> (list_cons (SourceString ((data_language_exts ())))) |> (source_string_join (string_of_char (10l))) |> (pair_cons (public_identifiers_with_transformations definitions12)));;

let rec compiler_backend_haskell () = 
    (Backend ((data_haskell_language ()), (Cons ((data_preamble_filename ()),Empty)), (Cons ((data_pervasives_filename ()),Empty)), generate_source, (reserved_identifiers ()), validate_reserved_identifiers));;

let rec data_space3 () = 
    (string_from_list (Cons ((32l),Empty)));;

let rec data_fun3 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Empty)))));;

let rec data_type3 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_if3 () = 
    (string_from_list (Cons ((105l),Cons ((102l),Empty))));;

let rec data_then3 () = 
    (string_from_list (Cons ((116l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_else3 () = 
    (string_from_list (Cons ((101l),Cons ((108l),Cons ((115l),Cons ((101l),Empty))))));;

let rec data_with3 () = 
    (string_from_list (Cons ((119l),Cons ((105l),Cons ((116l),Cons ((104l),Empty))))));;

let rec data_of3 () = 
    (string_from_list (Cons ((111l),Cons ((102l),Empty))));;

let rec data_class3 () = 
    (string_from_list (Cons ((99l),Cons ((108l),Cons ((97l),Cons ((115l),Cons ((115l),Empty)))))));;

let rec data_end3 () = 
    (string_from_list (Cons ((101l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_in3 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Empty))));;

let rec data_let3 () = 
    (string_from_list (Cons ((108l),Cons ((101l),Cons ((116l),Empty)))));;

let rec data_open3 () = 
    (string_from_list (Cons ((111l),Cons ((112l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_and3 () = 
    (string_from_list (Cons ((97l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_or3 () = 
    (string_from_list (Cons ((111l),Cons ((114l),Empty))));;

let rec data_as3 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Empty))));;

let rec data_less_than3 () = 
    (string_from_list (Cons ((60l),Empty)));;

let rec data_assert3 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((115l),Cons ((101l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_asr3 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_begin3 () = 
    (string_from_list (Cons ((98l),Cons ((101l),Cons ((103l),Cons ((105l),Cons ((110l),Empty)))))));;

let rec data_constraint3 () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((97l),Cons ((105l),Cons ((110l),Cons ((116l),Empty))))))))))));;

let rec data_do3 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Empty))));;

let rec data_done3 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((110l),Cons ((101l),Empty))))));;

let rec data_downto3 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((119l),Cons ((110l),Cons ((116l),Cons ((111l),Empty))))))));;

let rec data_exception3 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((99l),Cons ((101l),Cons ((112l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty)))))))))));;

let rec data_external3 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((116l),Cons ((101l),Cons ((114l),Cons ((110l),Cons ((97l),Cons ((108l),Empty))))))))));;

let rec data_false3 () = 
    (string_from_list (Cons ((102l),Cons ((97l),Cons ((108l),Cons ((115l),Cons ((101l),Empty)))))));;

let rec data_true4 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))));;

let rec data_for3 () = 
    (string_from_list (Cons ((102l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_function3 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty))))))))));;

let rec data_functor3 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Empty)))))))));;

let rec data_include3 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((99l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Empty)))))))));;

let rec data_inherit3 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((105l),Cons ((116l),Empty)))))))));;

let rec data_initializer3 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((97l),Cons ((108l),Cons ((105l),Cons ((122l),Cons ((101l),Cons ((114l),Empty)))))))))))));;

let rec data_land3 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((110l),Cons ((100l),Empty))))));;

let rec data_lazy3 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((122l),Cons ((121l),Empty))))));;

let rec data_lor3 () = 
    (string_from_list (Cons ((108l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_lsl3 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((108l),Empty)))));;

let rec data_lsr3 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_lxor3 () = 
    (string_from_list (Cons ((108l),Cons ((120l),Cons ((111l),Cons ((114l),Empty))))));;

let rec data_method3 () = 
    (string_from_list (Cons ((109l),Cons ((101l),Cons ((116l),Cons ((104l),Cons ((111l),Cons ((100l),Empty))))))));;

let rec data_mod3 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Empty)))));;

let rec data_module3 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec data_mutable3 () = 
    (string_from_list (Cons ((109l),Cons ((117l),Cons ((116l),Cons ((97l),Cons ((98l),Cons ((108l),Cons ((101l),Empty)))))))));;

let rec data_new3 () = 
    (string_from_list (Cons ((110l),Cons ((101l),Cons ((119l),Empty)))));;

let rec data_nonrec3 () = 
    (string_from_list (Cons ((110l),Cons ((111l),Cons ((110l),Cons ((114l),Cons ((101l),Cons ((99l),Empty))))))));;

let rec data_object3 () = 
    (string_from_list (Cons ((111l),Cons ((98l),Cons ((106l),Cons ((101l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_private3 () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((105l),Cons ((118l),Cons ((97l),Cons ((116l),Cons ((101l),Empty)))))))));;

let rec data_rec3 () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((99l),Empty)))));;

let rec data_sig3 () = 
    (string_from_list (Cons ((115l),Cons ((105l),Cons ((103l),Empty)))));;

let rec data_struct3 () = 
    (string_from_list (Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_try3 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((121l),Empty)))));;

let rec data_val3 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Empty)))));;

let rec data_virtual3 () = 
    (string_from_list (Cons ((118l),Cons ((105l),Cons ((114l),Cons ((116l),Cons ((117l),Cons ((97l),Cons ((108l),Empty)))))))));;

let rec data_when3 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_while3 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((105l),Cons ((108l),Cons ((101l),Empty)))))));;

let rec data_parser3 () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((101l),Cons ((114l),Empty))))))));;

let rec data_value3 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Cons ((117l),Cons ((101l),Empty)))))));;

let rec data_to3 () = 
    (string_from_list (Cons ((116l),Cons ((111l),Empty))));;

let rec data_def5 () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Empty)))));;

let rec data_typ5 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Empty)))));;

let rec data_fn5 () = 
    (string_from_list (Cons ((102l),Cons ((110l),Empty))));;

let rec data_match5 () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_exists5 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((115l),Empty))))))));;

let rec data_pub5 () = 
    (string_from_list (Cons ((112l),Cons ((117l),Cons ((98l),Empty)))));;

let rec data_25 () = 
    (string_from_list (Cons ((43l),Empty)));;

let rec data__5 () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_26 () = 
    (string_from_list (Cons ((42l),Empty)));;

let rec data_27 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec data_28 () = 
    (string_from_list (Cons ((37l),Empty)));;

let rec data_29 () = 
    (string_from_list (Cons ((38l),Empty)));;

let rec data_int32_less_than5 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((45l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((45l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((110l),Empty)))))))))))))))));;

let rec data_pipe6 () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_dot6 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_list6 () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_slice_empty5 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))))))))));;

let rec data_slice_of_u85 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((117l),Cons ((56l),Empty)))))))))))));;

let rec data_slice_size5 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Empty))))))))))));;

let rec data_slice_get5 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((103l),Cons ((101l),Cons ((116l),Empty)))))))))));;

let rec data_slice_concat5 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((99l),Cons ((97l),Cons ((116l),Empty))))))))))))));;

let rec data_slice_foldl5 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((100l),Cons ((108l),Empty)))))))))))));;

let rec data_slice_subslice5 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((117l),Cons ((98l),Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty))))))))))))))));;

let rec data_slice5 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_int326 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec data_compile_error2 () = 
    (string_from_list (Cons ((42l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((32l),Cons ((101l),Cons ((114l),Cons ((114l),Cons ((111l),Cons ((114l),Cons ((42l),Empty)))))))))))))))));;

let rec data_javascript_language () = 
    (string_from_list (Cons ((106l),Cons ((97l),Cons ((118l),Cons ((97l),Cons ((115l),Cons ((99l),Cons ((114l),Cons ((105l),Cons ((112l),Cons ((116l),Empty))))))))))));;

let rec data_preamble_filename2 () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((101l),Cons ((97l),Cons ((109l),Cons ((98l),Cons ((108l),Cons ((101l),Cons ((46l),Cons ((106l),Cons ((115l),Empty)))))))))))));;

let rec data_pervasives_filename2 () = 
    (string_from_list (Cons ((112l),Cons ((101l),Cons ((114l),Cons ((118l),Cons ((97l),Cons ((115l),Cons ((105l),Cons ((118l),Cons ((101l),Cons ((115l),Cons ((46l),Cons ((106l),Cons ((115l),Empty)))))))))))))));;

let rec data_int32_plus2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((97l),Cons ((100l),Cons ((100l),Empty)))))))))));;

let rec data_int32_multiply2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((109l),Cons ((117l),Cons ((108l),Empty)))))))))));;

let rec data_int32_minus2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((115l),Cons ((117l),Cons ((98l),Empty)))))))))));;

let rec data_int32_divide2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((100l),Cons ((105l),Cons ((118l),Empty)))))))))));;

let rec data_int32_modulus2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((109l),Cons ((111l),Cons ((100l),Empty)))))))))));;

let rec data_int32_and2 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((95l),Cons ((97l),Cons ((110l),Cons ((100l),Empty)))))))))));;

let rec data_slice6 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_trampoline () = 
    (string_from_list (Cons ((36l),Cons ((116l),Cons ((114l),Cons ((97l),Cons ((109l),Cons ((112l),Cons ((111l),Cons ((108l),Cons ((105l),Cons ((110l),Cons ((101l),Empty)))))))))))));;

let rec data_return_value_marker () = 
    (string_from_list (Cons ((36l),Cons ((107l),Cons ((58l),Empty)))));;

let rec data_tailcall () = 
    (string_from_list (Cons ((36l),Cons ((116l),Cons ((97l),Cons ((105l),Cons ((108l),Cons ((99l),Cons ((97l),Cons ((108l),Cons ((108l),Empty)))))))))));;

let rec data_var () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((114l),Empty)))));;

let rec data_return () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((116l),Cons ((117l),Cons ((114l),Cons ((110l),Empty))))))));;

let rec data_function4 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty))))))))));;

let rec data_import2 () = 
    (string_from_list (Cons ((105l),Cons ((109l),Cons ((112l),Cons ((111l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_default2 () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Cons ((97l),Cons ((117l),Cons ((108l),Cons ((116l),Empty)))))))));;

let rec data_case2 () = 
    (string_from_list (Cons ((99l),Cons ((97l),Cons ((115l),Cons ((101l),Empty))))));;

let rec data_break () = 
    (string_from_list (Cons ((98l),Cons ((114l),Cons ((101l),Cons ((97l),Cons ((107l),Empty)))))));;

let rec data_const () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Empty)))))));;

let rec data_continue () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((110l),Cons ((117l),Cons ((101l),Empty))))))))));;

let rec data_catch () = 
    (string_from_list (Cons ((99l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_debugger () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((98l),Cons ((117l),Cons ((103l),Cons ((103l),Cons ((101l),Cons ((114l),Empty))))))))));;

let rec data_delete () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((108l),Cons ((101l),Cons ((116l),Cons ((101l),Empty))))))));;

let rec data_export () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((112l),Cons ((111l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_extends () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((116l),Cons ((101l),Cons ((110l),Cons ((100l),Cons ((115l),Empty)))))))));;

let rec data_enum () = 
    (string_from_list (Cons ((101l),Cons ((110l),Cons ((117l),Cons ((109l),Empty))))));;

let rec data_finally () = 
    (string_from_list (Cons ((102l),Cons ((105l),Cons ((110l),Cons ((97l),Cons ((108l),Cons ((108l),Cons ((121l),Empty)))))))));;

let rec data_instanceof () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((97l),Cons ((110l),Cons ((99l),Cons ((101l),Cons ((111l),Cons ((102l),Empty))))))))))));;

let rec data_null () = 
    (string_from_list (Cons ((110l),Cons ((117l),Cons ((108l),Cons ((108l),Empty))))));;

let rec data_super () = 
    (string_from_list (Cons ((115l),Cons ((117l),Cons ((112l),Cons ((101l),Cons ((114l),Empty)))))));;

let rec data_switch () = 
    (string_from_list (Cons ((115l),Cons ((119l),Cons ((105l),Cons ((116l),Cons ((99l),Cons ((104l),Empty))))))));;

let rec data_this () = 
    (string_from_list (Cons ((116l),Cons ((104l),Cons ((105l),Cons ((115l),Empty))))));;

let rec data_throw () = 
    (string_from_list (Cons ((116l),Cons ((104l),Cons ((114l),Cons ((111l),Cons ((119l),Empty)))))));;

let rec data_typeof () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Cons ((111l),Cons ((102l),Empty))))))));;

let rec data_void () = 
    (string_from_list (Cons ((118l),Cons ((111l),Cons ((105l),Cons ((100l),Empty))))));;

let rec data_await () = 
    (string_from_list (Cons ((97l),Cons ((119l),Cons ((97l),Cons ((105l),Cons ((116l),Empty)))))));;

let rec data_module4 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec data_end_statement () = 
    (string_from_list (Cons ((59l),Empty)));;

let rec data_equals2 () = 
    (string_from_list (Cons ((61l),Empty)));;

let rec data_empty_object () = 
    (string_from_list (Cons ((123l),Cons ((125l),Empty))));;

let rec data_open_bracket3 () = 
    (string_from_list (Cons ((40l),Empty)));;

let rec data_close_bracket3 () = 
    (string_from_list (Cons ((41l),Empty)));;

let rec data_open_block () = 
    (string_from_list (Cons ((123l),Empty)));;

let rec data_close_block () = 
    (string_from_list (Cons ((125l),Empty)));;

let rec data_open_array () = 
    (string_from_list (Cons ((91l),Empty)));;

let rec data_close_array () = 
    (string_from_list (Cons ((93l),Empty)));;

let rec data_comma2 () = 
    (string_from_list (Cons ((44l),Empty)));;

let rec data_match_func () = 
    (string_from_list (Cons ((36l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty))))))));;

let rec data_capture () = 
    (string_from_list (Cons ((36l),Empty)));;

let rec data_question_mark () = 
    (string_from_list (Cons ((63l),Empty)));;

let rec data_colon2 () = 
    (string_from_list (Cons ((58l),Empty)));;

let rec data_lambda_arrow () = 
    (string_from_list (Cons ((32l),Cons ((61l),Cons ((62l),Cons ((32l),Empty))))));;

let rec data_single_quote () = 
    (string_from_list (Cons ((39l),Empty)));;

let rec data_dot7 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_exports () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((112l),Cons ((111l),Cons ((114l),Cons ((116l),Cons ((115l),Empty)))))))));;

let rec data_moduleexports () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Cons ((46l),Cons ((101l),Cons ((120l),Cons ((112l),Cons ((111l),Cons ((114l),Cons ((116l),Cons ((115l),Cons ((46l),Empty)))))))))))))))));;

let rec data_30 () = 
    (string_from_list (Cons ((125l),Cons ((59l),Empty))));;

let rec data_cons2 () = 
    (string_from_list (Cons ((67l),Cons ((111l),Cons ((110l),Cons ((115l),Empty))))));;

let rec data_empty2 () = 
    (string_from_list (Cons ((69l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))));;

let rec data_compose () = 
    (string_from_list (Cons ((36l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((111l),Cons ((115l),Cons ((101l),Empty))))))))));;

let rec data_pipe7 () = 
    (string_from_list (Cons ((36l),Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty)))))));;

let rec reserved_identifiers2 () = 
    (list_flatten (Cons ((Cons (data_var,Cons (data_import2,Cons (data_default2,Cons (data_case2,Cons (data_class3,Cons (data_do3,Empty))))))),Cons ((Cons (data_else3,Cons (data_false3,Cons (data_for3,Cons (data_function4,Cons (data_if3,Cons (data_in3,Empty))))))),Cons ((Cons (data_new3,Cons (data_true4,Cons (data_try3,Cons (data_with3,Cons (data_while3,Cons (data_break,Empty))))))),Cons ((Cons (data_const,Cons (data_continue,Cons (data_catch,Cons (data_debugger,Cons (data_delete,Empty)))))),Cons ((Cons (data_export,Cons (data_extends,Cons (data_enum,Cons (data_finally,Cons (data_instanceof,Empty)))))),Cons ((Cons (data_null,Cons (data_return,Cons (data_super,Cons (data_switch,Cons (data_this,Cons (data_throw,Empty))))))),Cons ((Cons (data_typeof,Cons (data_void,Cons (data_await,Cons (data_module4,Empty))))),Empty)))))))));;

let rec escape_identifier2 identifier84 = 
    (SourceStringIdentifier (identifier84, IdentifierTransformationNone));;

let rec translate_constructor_identifier2 identifier85 = 
    (escape_identifier2 identifier85);;

let rec operator_translation_map2 () = 
    (dictionary_of (Cons ((Pair ((data_25 ()), (SourceString ((data_int32_plus2 ()))))),Cons ((Pair ((data__5 ()), (SourceString ((data_int32_minus2 ()))))),Cons ((Pair ((data_26 ()), (SourceString ((data_int32_multiply2 ()))))),Cons ((Pair ((data_27 ()), (SourceString ((data_int32_divide2 ()))))),Cons ((Pair ((data_28 ()), (SourceString ((data_int32_modulus2 ()))))),Cons ((Pair ((data_29 ()), (SourceString ((data_int32_and2 ()))))),Empty))))))));;

let rec translate_identifier2 identifier86 = 
    (match (identifier_is_operator identifier86) with
         | True -> 
            (match (dictionary_get (identifier_name identifier86) (operator_translation_map2 ())) with
                 | (Some (translation2)) -> 
                    translation2
                 | None -> 
                    (escape_identifier2 identifier86))
         | False -> 
            (escape_identifier2 identifier86));;

let rec translate_less_than2 translate_expression9 expressions53 = 
    (match expressions53 with
         | (Cons (a74, (Cons (b69, (Cons (then_case2, (Cons (else_case2, Empty)))))))) -> 
            (wrap_in_brackets2 (join (Cons ((translate_expression9 a74),Cons ((SourceString ((data_less_than3 ()))),Cons ((translate_expression9 b69),Cons ((SourceString ((data_space3 ()))),Cons ((SourceString ((data_question_mark ()))),Cons ((SourceString ((data_space3 ()))),Cons ((translate_expression9 then_case2),Cons ((SourceString ((data_space3 ()))),Cons ((SourceString ((data_colon2 ()))),Cons ((SourceString ((data_space3 ()))),Cons ((translate_expression9 else_case2),Empty))))))))))))))
         | x513 -> 
            (SourceString ((data_compile_error2 ()))));;

let rec wrap_in_angle_brackets s5 = 
    (join (Cons ((SourceString ((data_open_array ()))),Cons (s5,Cons ((SourceString ((data_close_array ()))),Empty)))));;

let rec translate_constructor2 translator2 identifier87 constructor17 = 
    (constructor17 |> (list_map translator2) |> (list_cons (translate_constructor_identifier2 identifier87)) |> (source_string_join (string_concat (data_comma2 ()) (string_of_char (32l)))) |> wrap_in_angle_brackets);;

let rec translate_pattern2 pattern20 = 
    (match pattern20 with
         | (Capture (x514)) -> 
            (SourceString ((data_capture ())))
         | (IntegerPattern (integer9, x515)) -> 
            (SourceString ((string_from_int32 integer9)))
         | (ConstructorPattern (identifier88, Empty, x516)) -> 
            (translate_constructor_identifier2 identifier88)
         | (ConstructorPattern (identifier89, patterns10, x517)) -> 
            (translate_constructor2 translate_pattern2 identifier89 patterns10));;

let rec translate_captures pattern21 = 
    (match pattern21 with
         | (Capture (identifier90)) -> 
            (Cons ((escape_identifier2 identifier90),Empty))
         | (IntegerPattern (x518, x519)) -> 
            (list_empty ())
         | (ConstructorPattern (x520, patterns11, x521)) -> 
            (list_flatmap translate_captures patterns11));;

let rec translate_rule2 n15 translate_expression10 rule6 = 
    (match rule6 with
         | (Pair (pattern22, expression66)) -> 
            (join_lines (Cons (((line n15) (Cons ((translate_pattern2 pattern22),Cons ((SourceString ((data_comma2 ()))),Cons ((source_space ()),Cons ((wrap_in_brackets2 (source_string_join (string_concat (data_comma2 ()) (string_of_char (32l))) (translate_captures pattern22))),Cons ((SourceString ((data_lambda_arrow ()))),Empty))))))),Cons (((line (Int32.add n15 (1l))) (Cons ((translate_expression10 (Int32.add n15 (1l)) expression66),Empty))),Empty)))));;

let rec translate_match_expression2 n16 translate_expression11 translate_rule3 expression67 rules13 = 
    ((source_string_join (string_empty ())) (Cons ((SourceString ((data_match_func ()))),Cons ((SourceString ((data_open_bracket3 ()))),Cons ((translate_expression11 n16 expression67),Cons ((SourceString ((data_comma2 ()))),Cons ((source_space ()),Cons ((SourceString ((data_open_array ()))),Cons ((source_string_join (data_comma2 ()) (list_map (translate_rule3 (Int32.add n16 (1l)) translate_expression11) rules13)),Cons ((SourceString ((data_close_array ()))),Cons ((SourceString ((data_close_bracket3 ()))),Empty)))))))))));;

let rec translate_function_application3 translate_expression12 expressions54 = 
    (match expressions54 with
         | (Cons (function2, Empty)) -> 
            (join (Cons ((translate_expression12 function2),Cons ((wrap_in_brackets2 (source_string_empty ())),Empty))))
         | (Cons (function3, args)) -> 
            (join (Cons ((translate_expression12 function3),Cons ((join (list_map (fun x' -> x' |> translate_expression12 |> wrap_in_brackets2) args)),Empty))))
         | Empty -> 
            (SourceString ((data_compile_error2 ()))));;

let rec translate_function_application4 translate_expression13 expressions55 = 
    (match expressions55 with
         | (Cons ((Variable (identifier91)), rest28)) -> 
            (match (identifier_is (identifier_int32_less_than ()) identifier91) with
                 | True -> 
                    (translate_less_than2 translate_expression13 rest28)
                 | False -> 
                    (translate_function_application3 translate_expression13 expressions55))
         | x522 -> 
            (translate_function_application3 translate_expression13 expressions55));;

let rec translate_argument_list2 arguments26 = 
    (match (list_is_empty arguments26) with
         | True -> 
            (wrap_in_brackets2 (source_string_empty ()))
         | False -> 
            (source_string_join (data_lambda_arrow ()) (list_map escape_identifier2 arguments26)));;

let rec translate_lambda2 translate_expression14 arguments27 expression68 = 
    (join (Cons ((translate_argument_list2 arguments27),Cons ((SourceString ((data_lambda_arrow ()))),Cons ((translate_expression14 expression68),Empty)))));;

let rec translate_list_expression2 translate_expression15 expressions56 = 
    (list_foldr (fun expression69 source3 -> (join (Cons ((SourceString ((data_open_array ()))),Cons ((SourceString ((data_cons2 ()))),Cons ((SourceString ((data_comma2 ()))),Cons ((translate_expression15 expression69),Cons ((SourceString ((data_comma2 ()))),Cons (source3,Cons ((SourceString ((data_close_array ()))),Empty)))))))))) (SourceString ((data_empty2 ()))) expressions56);;

let rec translate_special_form identifier92 translate_expression16 expressions57 = 
    (source_string_concat (SourceString (identifier92)) (wrap_in_brackets2 (source_string_join (data_comma2 ()) (list_map translate_expression16 expressions57))));;

let rec translate_expression17 n17 expression70 = 
    (match expression70 with
         | (Lambda (arguments28, expression71, x523)) -> 
            (wrap_in_brackets2 (translate_lambda2 (translate_expression17 n17) arguments28 expression71))
         | (Constructor (identifier93, Empty, x524)) -> 
            (translate_constructor_identifier2 identifier93)
         | (Constructor (identifier94, expressions58, x525)) -> 
            ((translate_constructor2 (translate_expression17 n17) identifier94) expressions58)
         | (FunctionApplication (expressions59, x526)) -> 
            (translate_function_application4 (translate_expression17 n17) expressions59)
         | (IntegerConstant (integer10, x527)) -> 
            (SourceString ((string_from_int32 integer10)))
         | (Variable (identifier95)) -> 
            (translate_identifier2 identifier95)
         | (Match (expression72, rules14, x528)) -> 
            (translate_match_expression2 n17 translate_expression17 translate_rule2 expression72 rules14)
         | (ListExpression (expressions60, x529)) -> 
            (translate_list_expression2 (translate_expression17 n17) expressions60)
         | (Pipe (expressions61, x530)) -> 
            (translate_special_form (data_pipe7 ()) (translate_expression17 n17) expressions61)
         | (Compose (expressions62, x531)) -> 
            (translate_special_form (data_compose ()) (translate_expression17 n17) expressions62));;

let rec mark_as_return_value source4 = 
    (join (Cons ((SourceString ((data_open_bracket3 ()))),Cons ((SourceString ((data_open_block ()))),Cons ((SourceString ((data_return_value_marker ()))),Cons (source4,Cons ((SourceString ((data_close_block ()))),Cons ((SourceString ((data_close_bracket3 ()))),Empty))))))));;

let rec identifier_in_captures identifier96 rule7 = 
    (list_any (identifier_equal identifier96) (captured_identifiers_from_pattern (pair_left rule7)));;

let rec translate_tail_recursive_match_rule name67 translate_tail_recursive_function n18 translate_expression18 rule8 = 
    (match (identifier_in_captures name67 rule8) with
         | True -> 
            (translate_rule2 n18 translate_expression18 rule8)
         | False -> 
            (translate_rule2 n18 (translate_tail_recursive_function name67) rule8));;

let rec translate_tail_recursive_function2 name68 n19 expression73 = 
    (match expression73 with
         | (FunctionApplication ((Cons ((Variable (applied_name2)), arguments29)), range131)) -> 
            (match (identifier_equal name68 applied_name2) with
                 | True -> 
                    (mark_as_return_value ((source_string_join (string_empty ())) (Cons ((SourceString ((data_open_bracket3 ()))),Cons ((SourceString ((data_close_bracket3 ()))),Cons ((SourceString ((data_lambda_arrow ()))),Cons ((SourceString ((data_tailcall ()))),Cons ((source_space ()),Cons ((join (list_map (fun x' -> x' |> (translate_expression17 n19) |> wrap_in_brackets2) arguments29)),Empty)))))))))
                 | False -> 
                    (translate_expression17 n19 expression73))
         | (Match (expression74, rules15, range132)) -> 
            (translate_match_expression2 n19 translate_expression17 (translate_tail_recursive_match_rule name68 translate_tail_recursive_function2) expression74 rules15)
         | x532 -> 
            (translate_expression17 n19 expression73));;

let rec tail_recursive_function identifier97 arguments30 expression75 = 
    (and2 (list_every (fun x' -> x' |> (identifier_equal identifier97) |> not) arguments30) (expression_calls_function_in_tail_position identifier97 expression75));;

let rec translate_main_function_definition identifier98 arguments31 expression76 = 
    (match (tail_recursive_function identifier98 arguments31 expression76) with
         | True -> 
            ((source_string_join (newline ())) (Cons (((line (0l)) (Cons ((SourceString ((data_var ()))),Cons ((source_space ()),Cons ((escape_identifier2 identifier98),Cons ((source_space ()),Cons ((SourceString ((data_equals2 ()))),Cons ((source_space ()),Cons ((translate_argument_list2 arguments31),Cons ((SourceString ((data_lambda_arrow ()))),Cons ((SourceString ((data_open_block ()))),Empty))))))))))),Cons (((line (1l)) (Cons ((SourceString ((data_var ()))),Cons ((source_space ()),Cons ((SourceString ((data_tailcall ()))),Cons ((source_space ()),Cons ((SourceString ((data_equals2 ()))),Cons ((source_space ()),Cons ((translate_argument_list2 arguments31),Cons ((SourceString ((data_lambda_arrow ()))),Empty)))))))))),Cons (((line (2l)) (Cons ((source_string_concat (translate_tail_recursive_function2 identifier98 (2l) expression76) (SourceString ((data_end_statement ())))),Empty))),Cons (((line (1l)) (Cons ((SourceString ((data_return ()))),Cons ((source_space ()),Cons ((SourceString ((data_trampoline ()))),Cons ((SourceString ((data_open_bracket3 ()))),Cons ((SourceString ((data_tailcall ()))),Cons ((source_string_join (string_empty ()) (list_map (fun x' -> x' |> escape_identifier2 |> wrap_in_brackets2) arguments31)),Cons ((SourceString ((data_close_bracket3 ()))),Cons ((SourceString ((data_end_statement ()))),Empty)))))))))),Cons (((line (0l)) (Cons ((SourceString ((data_30 ()))),Empty))),Empty)))))))
         | False -> 
            ((source_string_join (newline ())) (Cons (((line (0l)) (Cons ((SourceString ((data_var ()))),Cons ((source_space ()),Cons ((escape_identifier2 identifier98),Cons ((source_space ()),Cons ((SourceString ((data_equals2 ()))),Cons ((source_space ()),Cons ((translate_argument_list2 arguments31),Cons ((SourceString ((data_lambda_arrow ()))),Empty)))))))))),Cons (((line (1l)) (Cons ((translate_expression17 (1l) expression76),Cons ((SourceString ((data_end_statement ()))),Empty)))),Empty)))));;

let rec translate_export_statement identifier99 arguments32 = 
    ((line (0l)) (Cons ((SourceString ((data_moduleexports ()))),Cons ((escape_identifier2 identifier99),Cons ((source_space ()),Cons ((SourceString ((data_equals2 ()))),Cons ((source_space ()),Cons ((SourceString ((data_open_bracket3 ()))),Cons ((source_string_join (data_comma2 ()) (list_map escape_identifier2 arguments32)),Cons ((SourceString ((data_close_bracket3 ()))),Cons ((SourceString ((data_lambda_arrow ()))),Cons ((escape_identifier2 identifier99),Cons ((match (list_is_empty arguments32) with
         | True -> 
            (wrap_in_brackets2 SourceStringEmpty)
         | False -> 
            (source_string_join (string_empty ()) (list_map (fun x' -> x' |> escape_identifier2 |> wrap_in_brackets2) arguments32))),Cons ((SourceString ((data_end_statement ()))),Empty))))))))))))));;

let rec translate_function_definition2 identifier100 public16 arguments33 expression77 = 
    ((source_string_join (newline ())) (list_flatten (Cons ((Cons ((translate_main_function_definition identifier100 arguments33 expression77),Empty)),Cons ((match public16 with
         | True -> 
            (Cons ((translate_export_statement identifier100 arguments33),Empty))
         | False -> 
            Empty),Empty)))));;

let rec constructor_identifier2 constructor18 = 
    (match constructor18 with
         | (SimpleConstructor (identifier101)) -> 
            identifier101
         | (ComplexConstructor (identifier102, x533, x534)) -> 
            identifier102);;

let rec translate_constructor_definition2 public17 constructor19 = 
    (match (translate_constructor_identifier2 (constructor_identifier2 constructor19)) with
         | identifier103 -> 
            ((line (0l)) (list_concat (Cons ((SourceString ((data_var ()))),Cons ((source_space ()),Cons (identifier103,Cons ((source_space ()),Cons ((SourceString ((data_equals2 ()))),Cons ((source_space ()),Cons ((SourceString ((data_open_block ()))),Cons ((source_space ()),Cons (identifier103,Cons ((SourceString ((data_colon2 ()))),Cons ((source_space ()),Cons ((SourceString ((data_true4 ()))),Cons ((source_space ()),Cons ((SourceString ((data_close_block ()))),Cons ((SourceString ((data_end_statement ()))),Empty)))))))))))))))) (match public17 with
                 | True -> 
                    (Cons ((SourceString ((newline ()))),Cons ((SourceString ((data_moduleexports ()))),Cons (identifier103,Cons ((source_space ()),Cons ((SourceString ((data_equals2 ()))),Cons ((source_space ()),Cons (identifier103,Cons ((SourceString ((data_end_statement ()))),Empty)))))))))
                 | False -> 
                    Empty))));;

let rec translate_type_definition2 name69 public18 parameters24 constructors20 = 
    (source_string_join (string_of_char (10l)) (list_map (translate_constructor_definition2 public18) constructors20));;

let rec translate_definition2 definition14 = 
    (match definition14 with
         | (FunctionDefinition (identifier104, public19, arguments34, expression78, x535)) -> 
            (translate_function_definition2 identifier104 public19 arguments34 expression78)
         | (TypeDefinition (name70, public20, parameters25, constructors21, x536)) -> 
            (translate_type_definition2 name70 public20 parameters25 constructors21)
         | (TargetDefinition (x537, data3)) -> 
            (SourceString ((string_from_slice data3))));;

let rec generate_source2 module_name5 definitions13 = 
    (definitions13 |> (list_map translate_definition2) |> (source_string_join (string_repeat (string_of_char (10l)) (2l))) |> (pair_cons (list_map (pair_cons IdentifierTransformationNone) (public_identifiers definitions13))));;

let rec compiler_backend_javascript () = 
    (Backend ((data_javascript_language ()), (Cons ((data_preamble_filename2 ()),Empty)), (Cons ((data_pervasives_filename2 ()),Empty)), generate_source2, (reserved_identifiers2 ()), validate_reserved_identifiers));;

let rec data_space4 () = 
    (string_from_list (Cons ((32l),Empty)));;

let rec data_fun4 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Empty)))));;

let rec data_type4 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_if4 () = 
    (string_from_list (Cons ((105l),Cons ((102l),Empty))));;

let rec data_then4 () = 
    (string_from_list (Cons ((116l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_else4 () = 
    (string_from_list (Cons ((101l),Cons ((108l),Cons ((115l),Cons ((101l),Empty))))));;

let rec data_with4 () = 
    (string_from_list (Cons ((119l),Cons ((105l),Cons ((116l),Cons ((104l),Empty))))));;

let rec data_of4 () = 
    (string_from_list (Cons ((111l),Cons ((102l),Empty))));;

let rec data_class4 () = 
    (string_from_list (Cons ((99l),Cons ((108l),Cons ((97l),Cons ((115l),Cons ((115l),Empty)))))));;

let rec data_end4 () = 
    (string_from_list (Cons ((101l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_in4 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Empty))));;

let rec data_let4 () = 
    (string_from_list (Cons ((108l),Cons ((101l),Cons ((116l),Empty)))));;

let rec data_open4 () = 
    (string_from_list (Cons ((111l),Cons ((112l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_and4 () = 
    (string_from_list (Cons ((97l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_or4 () = 
    (string_from_list (Cons ((111l),Cons ((114l),Empty))));;

let rec data_as4 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Empty))));;

let rec data_less_than4 () = 
    (string_from_list (Cons ((60l),Empty)));;

let rec data_assert4 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((115l),Cons ((101l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_asr4 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_begin4 () = 
    (string_from_list (Cons ((98l),Cons ((101l),Cons ((103l),Cons ((105l),Cons ((110l),Empty)))))));;

let rec data_constraint4 () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((97l),Cons ((105l),Cons ((110l),Cons ((116l),Empty))))))))))));;

let rec data_do4 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Empty))));;

let rec data_done4 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((110l),Cons ((101l),Empty))))));;

let rec data_downto4 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((119l),Cons ((110l),Cons ((116l),Cons ((111l),Empty))))))));;

let rec data_exception4 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((99l),Cons ((101l),Cons ((112l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty)))))))))));;

let rec data_external4 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((116l),Cons ((101l),Cons ((114l),Cons ((110l),Cons ((97l),Cons ((108l),Empty))))))))));;

let rec data_false4 () = 
    (string_from_list (Cons ((102l),Cons ((97l),Cons ((108l),Cons ((115l),Cons ((101l),Empty)))))));;

let rec data_true5 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))));;

let rec data_for4 () = 
    (string_from_list (Cons ((102l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_function5 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty))))))))));;

let rec data_functor4 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Empty)))))))));;

let rec data_include4 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((99l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Empty)))))))));;

let rec data_inherit4 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((105l),Cons ((116l),Empty)))))))));;

let rec data_initializer4 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((97l),Cons ((108l),Cons ((105l),Cons ((122l),Cons ((101l),Cons ((114l),Empty)))))))))))));;

let rec data_land4 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((110l),Cons ((100l),Empty))))));;

let rec data_lazy4 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((122l),Cons ((121l),Empty))))));;

let rec data_lor4 () = 
    (string_from_list (Cons ((108l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_lsl4 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((108l),Empty)))));;

let rec data_lsr4 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_lxor4 () = 
    (string_from_list (Cons ((108l),Cons ((120l),Cons ((111l),Cons ((114l),Empty))))));;

let rec data_method4 () = 
    (string_from_list (Cons ((109l),Cons ((101l),Cons ((116l),Cons ((104l),Cons ((111l),Cons ((100l),Empty))))))));;

let rec data_mod4 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Empty)))));;

let rec data_module5 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec data_mutable4 () = 
    (string_from_list (Cons ((109l),Cons ((117l),Cons ((116l),Cons ((97l),Cons ((98l),Cons ((108l),Cons ((101l),Empty)))))))));;

let rec data_new4 () = 
    (string_from_list (Cons ((110l),Cons ((101l),Cons ((119l),Empty)))));;

let rec data_nonrec4 () = 
    (string_from_list (Cons ((110l),Cons ((111l),Cons ((110l),Cons ((114l),Cons ((101l),Cons ((99l),Empty))))))));;

let rec data_object4 () = 
    (string_from_list (Cons ((111l),Cons ((98l),Cons ((106l),Cons ((101l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_private4 () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((105l),Cons ((118l),Cons ((97l),Cons ((116l),Cons ((101l),Empty)))))))));;

let rec data_rec4 () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((99l),Empty)))));;

let rec data_sig4 () = 
    (string_from_list (Cons ((115l),Cons ((105l),Cons ((103l),Empty)))));;

let rec data_struct4 () = 
    (string_from_list (Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_try4 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((121l),Empty)))));;

let rec data_val4 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Empty)))));;

let rec data_virtual4 () = 
    (string_from_list (Cons ((118l),Cons ((105l),Cons ((114l),Cons ((116l),Cons ((117l),Cons ((97l),Cons ((108l),Empty)))))))));;

let rec data_when4 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_while4 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((105l),Cons ((108l),Cons ((101l),Empty)))))));;

let rec data_parser4 () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((101l),Cons ((114l),Empty))))))));;

let rec data_value4 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Cons ((117l),Cons ((101l),Empty)))))));;

let rec data_to4 () = 
    (string_from_list (Cons ((116l),Cons ((111l),Empty))));;

let rec data_def6 () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Empty)))));;

let rec data_typ6 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Empty)))));;

let rec data_fn6 () = 
    (string_from_list (Cons ((102l),Cons ((110l),Empty))));;

let rec data_match6 () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_exists6 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((115l),Empty))))))));;

let rec data_pub6 () = 
    (string_from_list (Cons ((112l),Cons ((117l),Cons ((98l),Empty)))));;

let rec data_31 () = 
    (string_from_list (Cons ((43l),Empty)));;

let rec data__6 () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_32 () = 
    (string_from_list (Cons ((42l),Empty)));;

let rec data_33 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec data_34 () = 
    (string_from_list (Cons ((37l),Empty)));;

let rec data_35 () = 
    (string_from_list (Cons ((38l),Empty)));;

let rec data_int32_less_than6 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((45l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((45l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((110l),Empty)))))))))))))))));;

let rec data_pipe8 () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_dot8 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_list7 () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_slice_empty6 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))))))))));;

let rec data_slice_of_u86 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((117l),Cons ((56l),Empty)))))))))))));;

let rec data_slice_size6 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Empty))))))))))));;

let rec data_slice_get6 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((103l),Cons ((101l),Cons ((116l),Empty)))))))))));;

let rec data_slice_concat6 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((99l),Cons ((97l),Cons ((116l),Empty))))))))))))));;

let rec data_slice_foldl6 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((100l),Cons ((108l),Empty)))))))))))));;

let rec data_slice_subslice6 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((117l),Cons ((98l),Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty))))))))))))))));;

let rec data_slice7 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_int327 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec data_preamble_filename3 () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((101l),Cons ((97l),Cons ((109l),Cons ((98l),Cons ((108l),Cons ((101l),Cons ((46l),Cons ((114l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Empty))))))))))))))));;

let rec data_pervasives_filename3 () = 
    (string_from_list (Cons ((112l),Cons ((101l),Cons ((114l),Cons ((118l),Cons ((97l),Cons ((115l),Cons ((105l),Cons ((118l),Cons ((101l),Cons ((115l),Cons ((46l),Cons ((114l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Empty))))))))))))))))));;

let rec data_module_language () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec generate_source3 module_name6 definitions14 = 
    (definitions14 |> (list_filter (fun x' -> x' |> definition_module |> (module_equal ModuleSelf))) |> (list_map (fun x' -> x' |> definition_to_sexp |> stringify_sexp)) |> (string_join (string_of_char (10l))) |> source_string_string |> (pair_cons (list_empty ())));;

let rec compiler_backend_module () = 
    (Backend ((data_module_language ()), Empty, Empty, generate_source3, Empty, (result_map id)));;

let rec data_space5 () = 
    (string_from_list (Cons ((32l),Empty)));;

let rec data_fun5 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Empty)))));;

let rec data_type5 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_if5 () = 
    (string_from_list (Cons ((105l),Cons ((102l),Empty))));;

let rec data_then5 () = 
    (string_from_list (Cons ((116l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_else5 () = 
    (string_from_list (Cons ((101l),Cons ((108l),Cons ((115l),Cons ((101l),Empty))))));;

let rec data_with5 () = 
    (string_from_list (Cons ((119l),Cons ((105l),Cons ((116l),Cons ((104l),Empty))))));;

let rec data_of5 () = 
    (string_from_list (Cons ((111l),Cons ((102l),Empty))));;

let rec data_class5 () = 
    (string_from_list (Cons ((99l),Cons ((108l),Cons ((97l),Cons ((115l),Cons ((115l),Empty)))))));;

let rec data_end5 () = 
    (string_from_list (Cons ((101l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_in5 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Empty))));;

let rec data_let5 () = 
    (string_from_list (Cons ((108l),Cons ((101l),Cons ((116l),Empty)))));;

let rec data_open5 () = 
    (string_from_list (Cons ((111l),Cons ((112l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_and5 () = 
    (string_from_list (Cons ((97l),Cons ((110l),Cons ((100l),Empty)))));;

let rec data_or5 () = 
    (string_from_list (Cons ((111l),Cons ((114l),Empty))));;

let rec data_as5 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Empty))));;

let rec data_less_than5 () = 
    (string_from_list (Cons ((60l),Empty)));;

let rec data_assert5 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((115l),Cons ((101l),Cons ((114l),Cons ((116l),Empty))))))));;

let rec data_asr5 () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_begin5 () = 
    (string_from_list (Cons ((98l),Cons ((101l),Cons ((103l),Cons ((105l),Cons ((110l),Empty)))))));;

let rec data_constraint5 () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((114l),Cons ((97l),Cons ((105l),Cons ((110l),Cons ((116l),Empty))))))))))));;

let rec data_do5 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Empty))));;

let rec data_done5 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((110l),Cons ((101l),Empty))))));;

let rec data_downto5 () = 
    (string_from_list (Cons ((100l),Cons ((111l),Cons ((119l),Cons ((110l),Cons ((116l),Cons ((111l),Empty))))))));;

let rec data_exception5 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((99l),Cons ((101l),Cons ((112l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty)))))))))));;

let rec data_external5 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((116l),Cons ((101l),Cons ((114l),Cons ((110l),Cons ((97l),Cons ((108l),Empty))))))))));;

let rec data_false5 () = 
    (string_from_list (Cons ((102l),Cons ((97l),Cons ((108l),Cons ((115l),Cons ((101l),Empty)))))));;

let rec data_true6 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))));;

let rec data_for5 () = 
    (string_from_list (Cons ((102l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_function6 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty))))))))));;

let rec data_functor5 () = 
    (string_from_list (Cons ((102l),Cons ((117l),Cons ((110l),Cons ((99l),Cons ((116l),Cons ((111l),Cons ((114l),Empty)))))))));;

let rec data_include5 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((99l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Empty)))))))));;

let rec data_inherit5 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((104l),Cons ((101l),Cons ((114l),Cons ((105l),Cons ((116l),Empty)))))))));;

let rec data_initializer5 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((97l),Cons ((108l),Cons ((105l),Cons ((122l),Cons ((101l),Cons ((114l),Empty)))))))))))));;

let rec data_land5 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((110l),Cons ((100l),Empty))))));;

let rec data_lazy5 () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((122l),Cons ((121l),Empty))))));;

let rec data_lor5 () = 
    (string_from_list (Cons ((108l),Cons ((111l),Cons ((114l),Empty)))));;

let rec data_lsl5 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((108l),Empty)))));;

let rec data_lsr5 () = 
    (string_from_list (Cons ((108l),Cons ((115l),Cons ((114l),Empty)))));;

let rec data_lxor5 () = 
    (string_from_list (Cons ((108l),Cons ((120l),Cons ((111l),Cons ((114l),Empty))))));;

let rec data_method5 () = 
    (string_from_list (Cons ((109l),Cons ((101l),Cons ((116l),Cons ((104l),Cons ((111l),Cons ((100l),Empty))))))));;

let rec data_mod5 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Empty)))));;

let rec data_module6 () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec data_mutable5 () = 
    (string_from_list (Cons ((109l),Cons ((117l),Cons ((116l),Cons ((97l),Cons ((98l),Cons ((108l),Cons ((101l),Empty)))))))));;

let rec data_new5 () = 
    (string_from_list (Cons ((110l),Cons ((101l),Cons ((119l),Empty)))));;

let rec data_nonrec5 () = 
    (string_from_list (Cons ((110l),Cons ((111l),Cons ((110l),Cons ((114l),Cons ((101l),Cons ((99l),Empty))))))));;

let rec data_object5 () = 
    (string_from_list (Cons ((111l),Cons ((98l),Cons ((106l),Cons ((101l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_private5 () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((105l),Cons ((118l),Cons ((97l),Cons ((116l),Cons ((101l),Empty)))))))));;

let rec data_rec5 () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((99l),Empty)))));;

let rec data_sig5 () = 
    (string_from_list (Cons ((115l),Cons ((105l),Cons ((103l),Empty)))));;

let rec data_struct5 () = 
    (string_from_list (Cons ((115l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((99l),Cons ((116l),Empty))))))));;

let rec data_try5 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((121l),Empty)))));;

let rec data_val5 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Empty)))));;

let rec data_virtual5 () = 
    (string_from_list (Cons ((118l),Cons ((105l),Cons ((114l),Cons ((116l),Cons ((117l),Cons ((97l),Cons ((108l),Empty)))))))));;

let rec data_when5 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((101l),Cons ((110l),Empty))))));;

let rec data_while5 () = 
    (string_from_list (Cons ((119l),Cons ((104l),Cons ((105l),Cons ((108l),Cons ((101l),Empty)))))));;

let rec data_parser5 () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((101l),Cons ((114l),Empty))))))));;

let rec data_value5 () = 
    (string_from_list (Cons ((118l),Cons ((97l),Cons ((108l),Cons ((117l),Cons ((101l),Empty)))))));;

let rec data_to5 () = 
    (string_from_list (Cons ((116l),Cons ((111l),Empty))));;

let rec data_def7 () = 
    (string_from_list (Cons ((100l),Cons ((101l),Cons ((102l),Empty)))));;

let rec data_typ7 () = 
    (string_from_list (Cons ((116l),Cons ((121l),Cons ((112l),Empty)))));;

let rec data_fn7 () = 
    (string_from_list (Cons ((102l),Cons ((110l),Empty))));;

let rec data_match7 () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((116l),Cons ((99l),Cons ((104l),Empty)))))));;

let rec data_exists7 () = 
    (string_from_list (Cons ((101l),Cons ((120l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((115l),Empty))))))));;

let rec data_pub7 () = 
    (string_from_list (Cons ((112l),Cons ((117l),Cons ((98l),Empty)))));;

let rec data_36 () = 
    (string_from_list (Cons ((43l),Empty)));;

let rec data__7 () = 
    (string_from_list (Cons ((45l),Empty)));;

let rec data_37 () = 
    (string_from_list (Cons ((42l),Empty)));;

let rec data_38 () = 
    (string_from_list (Cons ((47l),Empty)));;

let rec data_39 () = 
    (string_from_list (Cons ((37l),Empty)));;

let rec data_40 () = 
    (string_from_list (Cons ((38l),Empty)));;

let rec data_int32_less_than7 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((45l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((115l),Cons ((45l),Cons ((116l),Cons ((104l),Cons ((97l),Cons ((110l),Empty)))))))))))))))));;

let rec data_pipe9 () = 
    (string_from_list (Cons ((112l),Cons ((105l),Cons ((112l),Cons ((101l),Empty))))));;

let rec data_dot9 () = 
    (string_from_list (Cons ((46l),Empty)));;

let rec data_list8 () = 
    (string_from_list (Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Empty))))));;

let rec data_slice_empty7 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((101l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))))))))));;

let rec data_slice_of_u87 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((111l),Cons ((102l),Cons ((45l),Cons ((117l),Cons ((56l),Empty)))))))))))));;

let rec data_slice_size7 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Empty))))))))))));;

let rec data_slice_get7 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((103l),Cons ((101l),Cons ((116l),Empty)))))))))));;

let rec data_slice_concat7 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((99l),Cons ((97l),Cons ((116l),Empty))))))))))))));;

let rec data_slice_foldl7 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((102l),Cons ((111l),Cons ((108l),Cons ((100l),Cons ((108l),Empty)))))))))))));;

let rec data_slice_subslice7 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((45l),Cons ((115l),Cons ((117l),Cons ((98l),Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty))))))))))))))));;

let rec data_slice8 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_int328 () = 
    (string_from_list (Cons ((105l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Empty)))))));;

let rec data_compile_error3 () = 
    (string_from_list (Cons ((42l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((32l),Cons ((101l),Cons ((114l),Cons ((114l),Cons ((111l),Cons ((114l),Cons ((42l),Empty)))))))))))))))));;

let rec data_arrow2 () = 
    (string_from_list (Cons ((32l),Cons ((45l),Cons ((62l),Cons ((32l),Empty))))));;

let rec data_equals3 () = 
    (string_from_list (Cons ((32l),Cons ((61l),Cons ((32l),Empty)))));;

let rec data_vertical_bar2 () = 
    (string_from_list (Cons ((32l),Cons ((124l),Cons ((32l),Empty)))));;

let rec data_pipe_operator () = 
    (string_from_list (Cons ((32l),Cons ((124l),Cons ((62l),Cons ((32l),Empty))))));;

let rec data_colon3 () = 
    (string_from_list (Cons ((32l),Cons ((58l),Cons ((32l),Empty)))));;

let rec data_star2 () = 
    (string_from_list (Cons ((32l),Cons ((42l),Cons ((32l),Empty)))));;

let rec data_unit () = 
    (string_from_list (Cons ((32l),Cons ((117l),Cons ((110l),Cons ((105l),Cons ((116l),Cons ((32l),Empty))))))));;

let rec data_int32_plus3 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((46l),Cons ((97l),Cons ((100l),Cons ((100l),Empty)))))))))));;

let rec data_int32_multiply3 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((46l),Cons ((109l),Cons ((117l),Cons ((108l),Empty)))))))))));;

let rec data_int32_minus3 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((46l),Cons ((115l),Cons ((117l),Cons ((98l),Empty)))))))))));;

let rec data_int32_divide3 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((46l),Cons ((100l),Cons ((105l),Cons ((118l),Empty)))))))))));;

let rec data_int32_modulus3 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((46l),Cons ((114l),Cons ((101l),Cons ((109l),Empty)))))))))));;

let rec data_int32_and3 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((46l),Cons ((108l),Cons ((111l),Cons ((103l),Cons ((97l),Cons ((110l),Cons ((100l),Empty))))))))))))));;

let rec data_int329 () = 
    (string_from_list (Cons ((73l),Cons ((110l),Cons ((116l),Cons ((51l),Cons ((50l),Cons ((46l),Cons ((111l),Cons ((102l),Cons ((95l),Cons ((105l),Cons ((110l),Cons ((116l),Cons ((32l),Empty)))))))))))))));;

let rec data_comma3 () = 
    (string_from_list (Cons ((44l),Empty)));;

let rec data_list_open () = 
    (string_from_list (Cons ((91l),Empty)));;

let rec data_list_close () = 
    (string_from_list (Cons ((93l),Empty)));;

let rec data_with6 () = 
    (string_from_list (Cons ((119l),Cons ((105l),Cons ((116l),Cons ((104l),Empty))))));;

let rec data_slice9 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Empty)))))));;

let rec data_slice_type2 () = 
    (string_from_list (Cons ((115l),Cons ((108l),Cons ((105l),Cons ((99l),Cons ((101l),Cons ((39l),Empty))))))));;

let rec data_definition_end () = 
    (string_from_list (Cons ((59l),Cons ((59l),Empty))));;

let rec data_let_rec () = 
    (string_from_list (Cons ((108l),Cons ((101l),Cons ((116l),Cons ((32l),Cons ((114l),Cons ((101l),Cons ((99l),Cons ((32l),Empty))))))))));;

let rec data_constant2 () = 
    (string_from_list (Cons ((95l),Cons ((99l),Cons ((111l),Cons ((110l),Cons ((115l),Cons ((116l),Cons ((97l),Cons ((110l),Cons ((116l),Cons ((95l),Empty))))))))))));;

let rec data_preamble_filename4 () = 
    (string_from_list (Cons ((112l),Cons ((114l),Cons ((101l),Cons ((97l),Cons ((109l),Cons ((98l),Cons ((108l),Cons ((101l),Cons ((46l),Cons ((109l),Cons ((108l),Empty)))))))))))));;

let rec data_pervasives_filename4 () = 
    (string_from_list (Cons ((112l),Cons ((101l),Cons ((114l),Cons ((118l),Cons ((97l),Cons ((115l),Cons ((105l),Cons ((118l),Cons ((101l),Cons ((115l),Cons ((46l),Cons ((109l),Cons ((108l),Empty)))))))))))))));;

let rec data_ocaml_language () = 
    (string_from_list (Cons ((111l),Cons ((99l),Cons ((97l),Cons ((109l),Cons ((108l),Empty)))))));;

let rec data_ml_list_to_reuse () = 
    (string_from_list (Cons ((109l),Cons ((108l),Cons ((95l),Cons ((108l),Cons ((105l),Cons ((115l),Cons ((116l),Cons ((95l),Cons ((116l),Cons ((111l),Cons ((95l),Cons ((114l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Empty))))))))))))))))));;

let rec data_x2 () = 
    (string_from_list (Cons ((120l),Cons ((39l),Empty))));;

let rec data_empty3 () = 
    (string_from_list (Cons ((69l),Cons ((109l),Cons ((112l),Cons ((116l),Cons ((121l),Empty)))))));;

let rec data_cons3 () = 
    (string_from_list (Cons ((67l),Cons ((111l),Cons ((110l),Cons ((115l),Empty))))));;

let rec reserved_identifiers3 () = 
    (list_flatten (Cons ((Cons (data_assert5,Cons (data_asr5,Cons (data_begin5,Cons (data_constraint5,Cons (data_do5,Cons (data_done5,Empty))))))),Cons ((Cons (data_downto5,Cons (data_type5,Cons (data_if5,Cons (data_then5,Cons (data_else5,Cons (data_with6,Cons (data_of5,Empty)))))))),Cons ((Cons (data_end5,Cons (data_in5,Cons (data_fun5,Cons (data_let5,Cons (data_open5,Cons (data_and5,Cons (data_or5,Cons (data_as5,Empty))))))))),Cons ((Cons (data_class5,Cons (data_exception5,Cons (data_external5,Cons (data_false5,Cons (data_true6,Cons (data_for5,Empty))))))),Cons ((Cons (data_function6,Cons (data_functor5,Cons (data_if5,Cons (data_include5,Cons (data_inherit5,Empty)))))),Cons ((Cons (data_initializer5,Cons (data_land5,Cons (data_lazy5,Cons (data_lor5,Cons (data_lsl5,Cons (data_lsr5,Empty))))))),Cons ((Cons (data_lxor5,Cons (data_method5,Cons (data_mod5,Cons (data_module6,Cons (data_mutable5,Cons (data_new5,Empty))))))),Cons ((Cons (data_nonrec5,Cons (data_object5,Cons (data_private5,Cons (data_rec5,Cons (data_sig5,Cons (data_struct5,Empty))))))),Cons ((Cons (data_try5,Cons (data_val5,Cons (data_virtual5,Cons (data_when5,Cons (data_while5,Cons (data_parser5,Empty))))))),Cons ((Cons (data_value5,Cons (data_to5,Cons (data_slice9,Empty)))),Empty))))))))))));;

let rec operator_translation_map3 () = 
    (dictionary_of (Cons ((Pair ((data_36 ()), (SourceString ((data_int32_plus3 ()))))),Cons ((Pair ((data__7 ()), (SourceString ((data_int32_minus3 ()))))),Cons ((Pair ((data_37 ()), (SourceString ((data_int32_multiply3 ()))))),Cons ((Pair ((data_38 ()), (SourceString ((data_int32_divide3 ()))))),Cons ((Pair ((data_39 ()), (SourceString ((data_int32_modulus3 ()))))),Cons ((Pair ((data_40 ()), (SourceString ((data_int32_and3 ()))))),Empty))))))));;

let rec translate_type_variable identifier105 = 
    (source_string_concat (SourceStringChar ((39l))) (source_string_concat (SourceStringChar ((84l))) (SourceStringIdentifier (identifier105, IdentifierTransformationNone))));;

let rec escape_identifier3 identifier106 = 
    (SourceStringIdentifier (identifier106, IdentifierTransformationNone));;

let rec lowercase_identifier identifier107 = 
    (SourceStringIdentifier (identifier107, IdentifierTransformationLowercase));;

let rec translate_type_identifier identifier108 = 
    (match (identifier_is (identifier_slice ()) identifier108) with
         | True -> 
            (SourceString ((data_slice_type2 ())))
         | False -> 
            (escape_identifier3 identifier108));;

let rec translate_constructor_identifier3 identifier109 = 
    (SourceStringIdentifier (identifier109, IdentifierTransformationCapitalize));;

let rec translate_identifier3 identifier110 = 
    (match (identifier_is_operator identifier110) with
         | True -> 
            (match (dictionary_get (identifier_name identifier110) (operator_translation_map3 ())) with
                 | (Some (translation3)) -> 
                    translation3
                 | None -> 
                    (SourceStringIdentifier (identifier110, IdentifierTransformationNone)))
         | False -> 
            (SourceStringIdentifier (identifier110, IdentifierTransformationNone)));;

let rec translate_less_than3 translate_expression19 expressions63 = 
    (match expressions63 with
         | (Cons (a75, (Cons (b70, (Cons (then_case3, (Cons (else_case3, Empty)))))))) -> 
            (join (Cons ((SourceString ((data_if5 ()))),Cons ((SourceString ((data_space5 ()))),Cons ((translate_expression19 a75),Cons ((SourceString ((data_less_than5 ()))),Cons ((translate_expression19 b70),Cons ((SourceString ((data_space5 ()))),Cons ((SourceString ((data_then5 ()))),Cons ((SourceString ((data_space5 ()))),Cons ((translate_expression19 then_case3),Cons ((SourceString ((data_space5 ()))),Cons ((SourceString ((data_else5 ()))),Cons ((SourceString ((data_space5 ()))),Cons ((translate_expression19 else_case3),Empty)))))))))))))))
         | x538 -> 
            (SourceString ((data_compile_error3 ()))));;

let rec translate_constructor3 translator3 identifier111 argument_list = 
    (argument_list |> (list_map translator3) |> (source_string_join (string_concat (data_comma3 ()) (string_of_char (32l)))) |> wrap_in_brackets2 |> (fun parameters26 -> (Cons ((translate_constructor_identifier3 identifier111),Cons ((SourceString ((data_space5 ()))),Cons (parameters26,Empty))))) |> join |> wrap_in_brackets2);;

let rec translate_pattern3 pattern23 = 
    (match pattern23 with
         | (Capture (identifier112)) -> 
            (escape_identifier3 identifier112)
         | (IntegerPattern (integer11, x539)) -> 
            (join (Cons ((SourceString ((string_from_int32 integer11))),Cons ((SourceStringChar ((108l))),Empty))))
         | (ConstructorPattern (identifier113, Empty, x540)) -> 
            (translate_constructor_identifier3 identifier113)
         | (ConstructorPattern (identifier114, patterns12, x541)) -> 
            (translate_constructor3 translate_pattern3 identifier114 patterns12));;

let rec translate_rule4 translate_expression20 n20 rule9 = 
    (match rule9 with
         | (Pair (pattern24, expression79)) -> 
            (join_lines (Cons (((line n20) (Cons ((SourceString ((data_vertical_bar2 ()))),Cons ((translate_pattern3 pattern24),Cons ((SourceString ((data_arrow2 ()))),Empty))))),Cons (((line (Int32.add n20 (1l))) (Cons ((translate_expression20 (Int32.add n20 (1l)) expression79),Empty))),Empty)))));;

let rec translate_match_expression3 translate_expression21 n21 expression80 rules16 = 
    (rules16 |> (list_map (translate_rule4 translate_expression21 n21)) |> (source_string_join (string_empty ())) |> (fun rules17 -> (Cons ((SourceString ((data_match7 ()))),Cons ((source_space ()),Cons ((translate_expression21 n21 expression80),Cons ((source_space ()),Cons ((SourceString ((data_with6 ()))),Cons (rules17,Empty)))))))) |> (source_string_join (string_empty ())));;

let rec translate_function_application5 translate_expression22 expressions64 = 
    (match expressions64 with
         | (Cons (no_args_function2, Empty)) -> 
            (join (Cons ((translate_expression22 no_args_function2),Cons ((SourceString ((data_space5 ()))),Cons ((SourceString ((wrap_in_brackets (string_empty ())))),Empty)))))
         | x542 -> 
            (source_string_join (data_space5 ()) (list_map translate_expression22 expressions64)));;

let rec translate_function_application6 translate_expression23 expressions65 = 
    (match expressions65 with
         | (Cons ((Variable (identifier115)), rest29)) -> 
            (match (identifier_is (identifier_int32_less_than ()) identifier115) with
                 | True -> 
                    (translate_less_than3 translate_expression23 rest29)
                 | False -> 
                    (translate_function_application5 translate_expression23 expressions65))
         | x543 -> 
            (translate_function_application5 translate_expression23 expressions65));;

let rec translate_argument_list3 arguments35 = 
    (match (list_is_empty arguments35) with
         | True -> 
            (SourceString ((wrap_in_brackets (string_empty ()))))
         | False -> 
            (source_string_join (data_space5 ()) (list_map lowercase_identifier arguments35)));;

let rec translate_lambda3 translate_expression24 arguments36 expression81 = 
    (join (Cons ((SourceString ((data_fun5 ()))),Cons ((SourceString ((data_space5 ()))),Cons ((translate_argument_list3 arguments36),Cons ((SourceString ((data_arrow2 ()))),Cons ((translate_expression24 expression81),Empty)))))));;

let rec translate_list_expression3 translate_expression25 expressions66 = 
    (list_foldr (fun expression82 source5 -> (join (Cons ((SourceString ((data_cons3 ()))),Cons ((SourceString ((data_space5 ()))),Cons ((wrap_in_brackets2 (join (Cons ((translate_expression25 expression82),Cons ((SourceString ((data_comma3 ()))),Cons (source5,Empty)))))),Empty)))))) (SourceString ((data_empty3 ()))) expressions66);;

let rec translate_compose_expression translate_expression26 expressions67 = 
    (join (Cons ((SourceString ((data_fun5 ()))),Cons ((SourceString ((data_space5 ()))),Cons ((SourceString ((data_x2 ()))),Cons ((SourceString ((data_arrow2 ()))),Cons ((source_string_join (data_pipe_operator ()) (Cons ((SourceString ((data_x2 ()))), (list_map translate_expression26 (list_reverse expressions67))))),Empty)))))));;

let rec translate_expression27 n22 expression83 = 
    (match expression83 with
         | (Lambda (arguments37, expression84, x544)) -> 
            (wrap_in_brackets2 (translate_lambda3 (translate_expression27 n22) arguments37 expression84))
         | (Constructor (identifier116, Empty, x545)) -> 
            (translate_constructor_identifier3 identifier116)
         | (Constructor (identifier117, expressions68, x546)) -> 
            ((translate_constructor3 (translate_expression27 n22) identifier117) expressions68)
         | (FunctionApplication (expressions69, x547)) -> 
            (wrap_in_brackets2 (translate_function_application6 (translate_expression27 n22) expressions69))
         | (IntegerConstant (integer12, x548)) -> 
            (wrap_in_brackets2 (SourceString ((string_concat (string_from_int32 integer12) (string_of_char (108l))))))
         | (Variable (identifier118)) -> 
            (translate_identifier3 identifier118)
         | (Match (expression85, rules18, x549)) -> 
            (wrap_in_brackets2 (translate_match_expression3 translate_expression27 (Int32.add n22 (1l)) expression85 rules18))
         | (ListExpression (expressions70, x550)) -> 
            (wrap_in_brackets2 (translate_list_expression3 (translate_expression27 n22) expressions70))
         | (Pipe (expressions71, x551)) -> 
            (wrap_in_brackets2 (source_string_join (data_pipe_operator ()) (list_map (translate_expression27 n22) expressions71)))
         | (Compose (expressions72, x552)) -> 
            (wrap_in_brackets2 (translate_compose_expression (translate_expression27 n22) expressions72)));;

let rec translate_function_definition3 identifier119 arguments38 expression86 = 
    (join_lines (Cons (((line (0l)) (Cons ((SourceString ((data_let_rec ()))),Cons ((lowercase_identifier identifier119),Cons ((source_space ()),Cons ((translate_argument_list3 arguments38),Cons ((SourceString ((data_equals3 ()))),Empty))))))),Cons (((line (1l)) (Cons ((translate_expression27 (1l) expression86),Cons ((SourceString ((data_definition_end ()))),Empty)))),Empty))));;

let rec translate_simple_type2 identifier120 parameters27 = 
    (match (list_any (fun x' -> x' |> type_parameter_identifier |> (identifier_equal identifier120)) parameters27) with
         | False -> 
            (translate_type_identifier identifier120)
         | True -> 
            (translate_type_variable identifier120));;

let rec translate_complex_types2 translate_types5 name71 types18 = 
    (types18 |> (translate_types5 (data_comma3 ())) |> wrap_in_brackets2 |> (fun types19 -> (Cons (types19,Cons ((SourceString ((data_space5 ()))),Cons ((translate_type_identifier name71),Empty))))) |> join);;

let rec translate_function_type2 translate_types6 return_type7 argument_types7 = 
    (match (list_is_empty argument_types7) with
         | True -> 
            (wrap_in_brackets2 (join (Cons ((SourceString ((data_unit ()))),Cons ((SourceString ((data_arrow2 ()))),Cons ((translate_types6 (data_arrow2 ()) (Cons (return_type7,Empty))),Empty))))))
         | False -> 
            (wrap_in_brackets2 (translate_types6 (data_arrow2 ()) (list_concat argument_types7 (Cons (return_type7,Empty))))));;

let rec translate_type2 translate_types7 parameters28 type7 = 
    (match type7 with
         | (SimpleType (identifier121)) -> 
            (translate_simple_type2 identifier121 parameters28)
         | (ComplexType (identifier122, types20, x553)) -> 
            (translate_complex_types2 translate_types7 identifier122 types20)
         | (FunctionType (argument_types8, return_type8, x554)) -> 
            (translate_function_type2 translate_types7 return_type8 argument_types8));;

let rec translate_types8 parameters29 separator6 types21 = 
    (types21 |> (list_map (translate_type2 (translate_types8 parameters29) parameters29)) |> (source_string_join separator6));;

let rec translate_complex_constructor_definition2 name72 type8 types22 parameters30 = 
    (join (Cons ((translate_constructor_identifier3 name72),Cons ((SourceString ((data_colon3 ()))),Cons ((translate_types8 parameters30 (data_star2 ()) types22),Cons ((SourceString ((data_arrow2 ()))),Cons (type8,Empty)))))));;

let rec translate_constructor_definition3 type9 parameters31 constructor20 = 
    (match constructor20 with
         | (SimpleConstructor (identifier123)) -> 
            (translate_constructor_identifier3 identifier123)
         | (ComplexConstructor (identifier124, types23, x555)) -> 
            (translate_complex_constructor_definition2 identifier124 type9 types23 parameters31));;

let rec translate_constructor_definitions2 type10 parameters32 constructors22 = 
    (constructors22 |> (list_map (translate_constructor_definition3 type10 parameters32)) |> (source_string_join (string_concat (newline ()) (string_concat (indent (1l)) (data_vertical_bar2 ())))));;

let rec translate_type_parameter_for_definition parameter10 = 
    (match parameter10 with
         | (UniversalParameter (identifier125)) -> 
            (translate_type_variable identifier125)
         | (ExistentialParameter (x556)) -> 
            SourceStringEmpty);;

let rec translate_type_parameters parameters33 = 
    (parameters33 |> (list_map translate_type_parameter_for_definition) |> (list_filter (fun parameter11 -> (match parameter11 with
         | SourceStringEmpty -> 
            False
         | x557 -> 
            True))) |> (source_string_join (data_comma3 ())));;

let rec translate_type_name name73 parameters34 parameter_string = 
    (match (list_is_empty parameters34) with
         | True -> 
            (lowercase_identifier name73)
         | False -> 
            (join (Cons ((wrap_in_brackets2 parameter_string),Cons ((source_space ()),Cons ((lowercase_identifier name73),Empty))))));;

let rec translate_type_name2 name74 parameters35 = 
    (translate_type_name name74 parameters35 (translate_type_parameters parameters35));;

let rec translate_type_definition3 name75 parameters36 constructors23 = 
    (join_lines (Cons (((line (0l)) (Cons ((SourceString ((data_type5 ()))),Cons ((source_space ()),Cons ((translate_type_name2 name75 parameters36),Cons ((source_space ()),Cons ((SourceString ((data_equals3 ()))),Empty))))))),Cons (((line (1l)) (Cons ((SourceString ((data_vertical_bar2 ()))),Cons ((translate_constructor_definitions2 (translate_type_name2 name75 parameters36) parameters36 constructors23),Cons ((SourceString ((data_definition_end ()))),Empty))))),Empty))));;

let rec translate_definition3 definition15 = 
    (match definition15 with
         | (FunctionDefinition (identifier126, x558, arguments39, expression87, x559)) -> 
            (translate_function_definition3 identifier126 arguments39 expression87)
         | (TypeDefinition (name76, x560, parameters37, constructors24, x561)) -> 
            (translate_type_definition3 name76 parameters37 constructors24)
         | (TargetDefinition (x562, data4)) -> 
            (SourceString ((string_from_slice data4))));;

let rec generate_source4 module_name7 definitions15 = 
    (definitions15 |> (list_map translate_definition3) |> (source_string_join (string_of_char (10l))) |> (pair_cons (list_map (pair_cons IdentifierTransformationLowercase) (public_identifiers definitions15))));;

let rec compiler_backend_ocaml () = 
    (Backend ((data_ocaml_language ()), (Cons ((data_preamble_filename4 ()),Empty)), (Cons ((data_pervasives_filename4 ()),Empty)), generate_source4, (reserved_identifiers3 ()), validate_reserved_identifiers));;

let rec compiler_backends () = 
    (Cons ((compiler_backend_haskell ()),Cons ((compiler_backend_javascript ()),Cons ((compiler_backend_module ()),Cons ((compiler_backend_ocaml ()),Empty)))));;

let rec data_no_input_files () = 
    (string_from_list (Cons ((78l),Cons ((111l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((115l),Empty))))))))))))))));;

let rec data_no_output_path () = 
    (string_from_list (Cons ((78l),Cons ((111l),Cons ((32l),Cons ((111l),Cons ((117l),Cons ((116l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((32l),Cons ((115l),Cons ((112l),Cons ((101l),Cons ((99l),Cons ((105l),Cons ((102l),Cons ((105l),Cons ((101l),Cons ((100l),Cons ((44l),Cons ((32l),Cons ((112l),Cons ((108l),Cons ((101l),Cons ((97l),Cons ((115l),Cons ((101l),Cons ((32l),Cons ((117l),Cons ((115l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((45l),Cons ((45l),Cons ((111l),Cons ((117l),Cons ((116l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((91l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((93l),Cons ((32l),Cons ((102l),Cons ((108l),Cons ((97l),Cons ((103l),Cons ((46l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_output_key () = 
    (string_from_list (Cons ((111l),Cons ((117l),Cons ((116l),Cons ((112l),Cons ((117l),Cons ((116l),Empty))))))));;

let rec data_stdlib () = 
    (string_from_list (Cons ((115l),Cons ((116l),Cons ((100l),Cons ((108l),Cons ((105l),Cons ((98l),Empty))))))));;

let rec data_parser_flag () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((101l),Cons ((114l),Empty))))))));;

let rec data_module_flag () = 
    (string_from_list (Cons ((109l),Cons ((111l),Cons ((100l),Cons ((117l),Cons ((108l),Cons ((101l),Empty))))))));;

let rec data_language_flag () = 
    (string_from_list (Cons ((108l),Cons ((97l),Cons ((110l),Cons ((103l),Cons ((117l),Cons ((97l),Cons ((103l),Cons ((101l),Empty))))))))));;

let rec data_diagnostics_flag () = 
    (string_from_list (Cons ((100l),Cons ((105l),Cons ((97l),Cons ((103l),Cons ((110l),Cons ((111l),Cons ((115l),Cons ((116l),Cons ((105l),Cons ((99l),Cons ((115l),Empty)))))))))))));;

let rec data_read_files () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((97l),Cons ((100l),Cons ((32l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((32l),Cons ((40l),Cons ((206l),Cons ((188l),Cons ((115l),Cons ((41l),Empty))))))))))))))))));;

let rec data_write_files () = 
    (string_from_list (Cons ((119l),Cons ((114l),Cons ((105l),Cons ((116l),Cons ((101l),Cons ((32l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((32l),Cons ((40l),Cons ((206l),Cons ((188l),Cons ((115l),Cons ((41l),Empty)))))))))))))))))));;

let rec data_bytes_read () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((97l),Cons ((100l),Cons ((32l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((32l),Cons ((40l),Cons ((98l),Cons ((121l),Cons ((116l),Cons ((101l),Cons ((115l),Cons ((41l),Empty))))))))))))))))))));;

let rec data_max_heap_size () = 
    (string_from_list (Cons ((109l),Cons ((97l),Cons ((120l),Cons ((32l),Cons ((104l),Cons ((101l),Cons ((97l),Cons ((112l),Cons ((32l),Cons ((115l),Cons ((105l),Cons ((122l),Cons ((101l),Cons ((32l),Cons ((40l),Cons ((98l),Cons ((121l),Cons ((116l),Cons ((101l),Cons ((115l),Cons ((41l),Empty)))))))))))))))))))))));;

let rec data_parse_time () = 
    (string_from_list (Cons ((112l),Cons ((97l),Cons ((114l),Cons ((115l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((40l),Cons ((206l),Cons ((188l),Cons ((115l),Cons ((41l),Empty)))))))))))))));;

let rec data_resolve_time () = 
    (string_from_list (Cons ((114l),Cons ((101l),Cons ((115l),Cons ((111l),Cons ((108l),Cons ((118l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((105l),Cons ((100l),Cons ((101l),Cons ((110l),Cons ((116l),Cons ((105l),Cons ((102l),Cons ((105l),Cons ((101l),Cons ((114l),Cons ((115l),Cons ((32l),Cons ((40l),Cons ((206l),Cons ((188l),Cons ((115l),Cons ((41l),Empty)))))))))))))))))))))))))))));;

let rec data_transform_time () = 
    (string_from_list (Cons ((97l),Cons ((115l),Cons ((116l),Cons ((32l),Cons ((116l),Cons ((114l),Cons ((97l),Cons ((110l),Cons ((115l),Cons ((102l),Cons ((111l),Cons ((114l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((40l),Cons ((206l),Cons ((188l),Cons ((115l),Cons ((41l),Empty))))))))))))))))))))))))));;

let rec data_generate_time () = 
    (string_from_list (Cons ((99l),Cons ((111l),Cons ((100l),Cons ((101l),Cons ((32l),Cons ((103l),Cons ((101l),Cons ((110l),Cons ((101l),Cons ((114l),Cons ((97l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Cons ((32l),Cons ((40l),Cons ((206l),Cons ((188l),Cons ((115l),Cons ((41l),Empty)))))))))))))))))))))));;

let rec data_true7 () = 
    (string_from_list (Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty))))));;

let rec data_usage () = 
    (string_from_list (Cons ((117l),Cons ((115l),Cons ((97l),Cons ((103l),Cons ((101l),Empty)))))));;

let rec data_usage1 () = 
    (string_from_list (Cons ((85l),Cons ((115l),Cons ((97l),Cons ((103l),Cons ((101l),Cons ((58l),Cons ((32l),Cons ((114l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Cons ((99l),Cons ((32l),Cons ((91l),Cons ((102l),Cons ((108l),Cons ((97l),Cons ((103l),Cons ((115l),Cons ((93l),Cons ((32l),Cons ((45l),Cons ((45l),Cons ((111l),Cons ((117l),Cons ((116l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((91l),Cons ((79l),Cons ((85l),Cons ((84l),Cons ((80l),Cons ((85l),Cons ((84l),Cons ((32l),Cons ((70l),Cons ((73l),Cons ((76l),Cons ((69l),Cons ((93l),Cons ((32l),Cons ((91l),Cons ((70l),Cons ((73l),Cons ((76l),Cons ((69l),Cons ((93l),Cons ((46l),Cons ((46l),Cons ((46l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage2 () = 
    (string_from_list (Cons ((67l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((114l),Cons ((32l),Cons ((102l),Cons ((111l),Cons ((114l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((82l),Cons ((101l),Cons ((117l),Cons ((115l),Cons ((101l),Cons ((32l),Cons ((112l),Cons ((114l),Cons ((111l),Cons ((103l),Cons ((114l),Cons ((97l),Cons ((109l),Cons ((109l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((108l),Cons ((97l),Cons ((110l),Cons ((103l),Cons ((117l),Cons ((97l),Cons ((103l),Cons ((101l),Empty)))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage3 () = 
    (string_from_list (Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((45l),Cons ((45l),Cons ((115l),Cons ((116l),Cons ((100l),Cons ((108l),Cons ((105l),Cons ((98l),Cons ((32l),Cons ((91l),Cons ((66l),Cons ((79l),Cons ((79l),Cons ((76l),Cons ((93l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((73l),Cons ((110l),Cons ((99l),Cons ((108l),Cons ((117l),Cons ((100l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((32l),Cons ((115l),Cons ((116l),Cons ((97l),Cons ((110l),Cons ((100l),Cons ((97l),Cons ((114l),Cons ((100l),Cons ((32l),Cons ((108l),Cons ((105l),Cons ((98l),Cons ((114l),Cons ((97l),Cons ((114l),Cons ((121l),Cons ((44l),Cons ((32l),Cons ((100l),Cons ((101l),Cons ((102l),Cons ((97l),Cons ((117l),Cons ((108l),Cons ((116l),Cons ((58l),Cons ((32l),Cons ((116l),Cons ((114l),Cons ((117l),Cons ((101l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage4 () = 
    (string_from_list (Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((45l),Cons ((45l),Cons ((108l),Cons ((97l),Cons ((110l),Cons ((103l),Cons ((117l),Cons ((97l),Cons ((103l),Cons ((101l),Cons ((32l),Cons ((91l),Cons ((76l),Cons ((65l),Cons ((78l),Cons ((71l),Cons ((93l),Cons ((32l),Cons ((32l),Cons ((84l),Cons ((97l),Cons ((114l),Cons ((103l),Cons ((101l),Cons ((116l),Cons ((32l),Cons ((108l),Cons ((97l),Cons ((110l),Cons ((103l),Cons ((117l),Cons ((97l),Cons ((103l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((32l),Cons ((116l),Cons ((111l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage5 () = 
    (string_from_list (Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((45l),Cons ((45l),Cons ((111l),Cons ((117l),Cons ((116l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((91l),Cons ((70l),Cons ((73l),Cons ((76l),Cons ((69l),Cons ((93l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((87l),Cons ((114l),Cons ((105l),Cons ((116l),Cons ((101l),Cons ((32l),Cons ((111l),Cons ((117l),Cons ((116l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((32l),Cons ((70l),Cons ((73l),Cons ((76l),Cons ((69l),Empty))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage6 () = 
    (string_from_list (Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((45l),Cons ((104l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((80l),Cons ((114l),Cons ((105l),Cons ((110l),Cons ((116l),Cons ((32l),Cons ((117l),Cons ((115l),Cons ((97l),Cons ((103l),Cons ((101l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((102l),Cons ((111l),Cons ((114l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage7 () = 
    (string_from_list (Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((45l),Cons ((102l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((70l),Cons ((111l),Cons ((114l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((112l),Cons ((117l),Cons ((116l),Cons ((32l),Cons ((102l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((115l),Cons ((32l),Cons ((98l),Cons ((121l),Cons ((32l),Cons ((119l),Cons ((114l),Cons ((105l),Cons ((116l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((100l),Cons ((105l),Cons ((114l),Cons ((101l),Cons ((99l),Cons ((116l),Cons ((108l),Cons ((121l),Cons ((32l),Cons ((116l),Cons ((111l),Cons ((32l),Cons ((116l),Cons ((104l),Cons ((101l),Cons ((109l),Empty))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage8 () = 
    (string_from_list (Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((45l),Cons ((45l),Cons ((100l),Cons ((105l),Cons ((97l),Cons ((103l),Cons ((110l),Cons ((111l),Cons ((115l),Cons ((116l),Cons ((105l),Cons ((99l),Cons ((115l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((32l),Cons ((80l),Cons ((114l),Cons ((105l),Cons ((110l),Cons ((116l),Cons ((32l),Cons ((99l),Cons ((111l),Cons ((109l),Cons ((112l),Cons ((105l),Cons ((108l),Cons ((101l),Cons ((114l),Cons ((32l),Cons ((116l),Cons ((105l),Cons ((109l),Cons ((105l),Cons ((110l),Cons ((103l),Cons ((32l),Cons ((105l),Cons ((110l),Cons ((102l),Cons ((111l),Cons ((114l),Cons ((109l),Cons ((97l),Cons ((116l),Cons ((105l),Cons ((111l),Cons ((110l),Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage9 () = 
    (string_from_list (Cons ((76l),Cons ((97l),Cons ((110l),Cons ((103l),Cons ((117l),Cons ((97l),Cons ((103l),Cons ((101l),Cons ((115l),Cons ((58l),Cons ((32l),Empty)))))))))))));;

let rec data_h () = 
    (string_from_list (Cons ((104l),Empty)));;

let rec data_f () = 
    (string_from_list (Cons ((102l),Empty)));;

let rec usage modules = 
    (string_join (string_of_char (10l)) (Cons ((data_usage1 ()),Cons ((string_empty ()),Cons ((data_usage2 ()),Cons ((string_empty ()),Cons ((data_usage3 ()),Cons ((data_usage4 ()),Cons ((data_usage5 ()),Cons ((data_usage6 ()),Cons ((data_usage7 ()),Cons ((data_usage8 ()),Cons ((string_empty ()),Cons ((string_concat (data_usage9 ()) (string_join (string_of_char (32l)) (list_map compiler_backend_name modules))),Empty))))))))))))));;

type cli_program  = 
     | CliTime : (int32 -> cli_program) -> cli_program
     | CliMaxHeapSize : (int32 -> cli_program) -> cli_program
     | CliRenderSource : (((identifier_transformation,identifier) pair) list,source_string) pair * (( unit  -> string)) list * (slice' -> cli_program) -> cli_program
     | CliReadFiles : ((module_reference,string) pair) list * ((source_file) list -> cli_program) -> cli_program
     | CliWriteFiles : ((string,slice') pair) list * ( unit  -> cli_program) -> cli_program
     | CliOutput : string * ( unit  -> cli_program) -> cli_program
     | CliError : string * ( unit  -> cli_program) -> cli_program
     | CliExit : int32 -> cli_program;;

let rec time_bind f60 = 
    (CliTime (f60));;

let rec max_heap_size_bind f61 = 
    (CliMaxHeapSize (f61));;

let rec render_source_bind source6 reserved_identifiers4 f62 = 
    (CliRenderSource (source6, reserved_identifiers4, f62));;

let rec read_files_bind paths2 f63 = 
    (CliReadFiles (paths2, f63));;

let rec write_files_bind files9 f64 = 
    (CliWriteFiles (files9, f64));;

let rec error_bind message f65 = 
    (CliError (message, f65));;

let rec flag_is_true flag default4 arguments40 = 
    (match (dictionary_get flag arguments40) with
         | (Some (value31)) -> 
            (string_equal value31 (data_true7 ()))
         | None -> 
            default4);;

let rec find_backend arguments41 = 
    (maybe_or_else (compiler_backend_ocaml ()) (maybe_bind (dictionary_get (data_language_flag ()) arguments41) (fun language -> (list_find_first (fun x' -> x' |> compiler_backend_name |> (string_equal language)) (compiler_backends ())))));;

let rec modules_from_arguments backend12 data_path5 arguments42 = 
    (arguments42 |> (list_filter (fun x' -> x' |> pair_left |> (string_equal (data_module_flag ())))) |> (list_map (fun x' -> x' |> pair_right |> (module_name_and_path False))) |> (match (flag_is_true (data_parser_flag ()) False (dictionary_of arguments42)) with
         | True -> 
            (list_cons (parser_module backend12 data_path5))
         | False -> 
            id) |> (match (flag_is_true (data_stdlib ()) True (dictionary_of arguments42)) with
         | True -> 
            (list_concat (standard_library_module backend12 data_path5))
         | False -> 
            id));;

let rec table_to_string table = 
    (string_join (string_of_char (10l)) (list_map (string_join (string_of_char (32l))) table));;

let rec print_diagnostics arguments43 file_entries max_heap_size start_parse end_parse start_resolve end_resolve start_transform end_transform start_generate end_generate start_read_files end_read_files start_write_files end_write_files k = 
    (match (flag_is_true (data_diagnostics_flag ()) False arguments43) with
         | True -> 
            (CliError ((table_to_string (Cons ((Cons ((string_from_int32 (list_foldl (fun file19 bytes -> (Int32.add bytes (source_file_size file19))) (0l) file_entries)),Cons ((data_bytes_read ()),Empty))),Cons ((Cons ((string_from_int32 max_heap_size),Cons ((data_max_heap_size ()),Empty))),Cons ((Cons ((string_from_int32 (Int32.sub end_parse start_parse)),Cons ((data_parse_time ()),Empty))),Cons ((Cons ((string_from_int32 (Int32.sub end_resolve start_resolve)),Cons ((data_resolve_time ()),Empty))),Cons ((Cons ((string_from_int32 (Int32.sub end_transform start_transform)),Cons ((data_transform_time ()),Empty))),Cons ((Cons ((string_from_int32 (Int32.sub end_generate start_generate)),Cons ((data_generate_time ()),Empty))),Cons ((Cons ((string_from_int32 (Int32.sub end_read_files start_read_files)),Cons ((data_read_files ()),Empty))),Cons ((Cons ((string_from_int32 (Int32.sub end_write_files start_write_files)),Cons ((data_write_files ()),Empty))),Empty)))))))))), k))
         | False -> 
            (k ()));;

let rec format_input_files input_files = 
    (CliReadFiles ((list_map (pair_cons ModuleSelf) input_files), (fun source_files -> (match (format_source_files source_files) with
         | (Result (files_to_write)) -> 
            (CliWriteFiles (files_to_write, (fun () -> (CliExit ((0l))))))
         | (Error (error_message)) -> 
            (error_bind error_message (fun () -> (CliExit ((1l)))))))));;

let rec compile_input_files input_files2 data_path6 arguments44 argument_list2 = 
    (let_bind (find_backend arguments44) (fun backend13 -> (time_bind (fun start_read_files2 -> (read_files_bind (list_concat (preamble_files backend13 data_path6) (list_concat (modules_from_arguments backend13 data_path6 argument_list2) (list_map (pair_cons ModuleSelf) input_files2))) (fun file_entries2 -> (time_bind (fun end_read_files2 -> (match (dictionary_get (data_output_key ()) arguments44) with
         | (Some (output_path)) -> 
            (let_bind (path_filename_without_extension output_path) (fun module_name8 -> (time_bind (fun start_parse2 -> (let_bind (list_map parse_source_file file_entries2) (fun parsed_files3 -> (time_bind (fun end_parse2 -> (time_bind (fun start_resolve2 -> (let_bind (resolve_files parsed_files3) (fun definitions16 -> (time_bind (fun end_resolve2 -> (time_bind (fun start_transform2 -> (let_bind (compiler_backend_transform_definitions backend13 (result_map pair_right definitions16)) (fun definitions17 -> (time_bind (fun end_transform2 -> (time_bind (fun start_generate2 -> (match (generate backend13 module_name8 definitions17) with
                 | (Result (source7)) -> 
                    (time_bind (fun end_generate2 -> (time_bind (fun start_write_files2 -> (render_source_bind source7 (compiler_backend_reserved_identifiers backend13) (fun source8 -> (write_files_bind (Cons ((Pair (output_path, source8)),Empty)) (fun () -> (time_bind (fun end_write_files2 -> (CliMaxHeapSize ((fun max_heap_size2 -> (print_diagnostics arguments44 file_entries2 max_heap_size2 start_parse2 end_parse2 start_resolve2 end_resolve2 start_transform2 end_transform2 start_generate2 end_generate2 start_read_files2 end_read_files2 start_write_files2 end_write_files2 (fun () -> (CliExit ((0l))))))))))))))))))
                 | (Error (error19)) -> 
                    (error_bind (error_to_string file_entries2 error19) (fun () -> (CliExit ((1l))))))))))))))))))))))))))))
         | None -> 
            (error_bind (data_no_output_path ()) (fun () -> (CliExit ((1l))))))))))))));;

let rec cli_main data_path7 argv = 
    (match (parse_arguments argv) with
         | (CliArguments (Empty, Empty)) -> 
            (error_bind (usage (compiler_backends ())) (fun () -> (CliExit ((1l)))))
         | (CliErrorMissingValue (key9)) -> 
            (error_bind key9 (fun () -> (CliExit ((1l)))))
         | (CliArguments (argument_list3, input_files3)) -> 
            (let_bind (dictionary_of argument_list3) (fun arguments45 -> (match (dictionary_has (data_h ()) arguments45) with
                 | True -> 
                    (error_bind (usage (compiler_backends ())) (fun () -> (CliExit ((1l)))))
                 | False -> 
                    (match (list_is_empty input_files3) with
                         | True -> 
                            (error_bind (data_no_input_files ()) (fun () -> (CliExit ((1l)))))
                         | False -> 
                            (match (dictionary_has (data_f ()) arguments45) with
                                 | True -> 
                                    (format_input_files input_files3)
                                 | False -> 
                                    (compile_input_files input_files3 data_path7 arguments45 argument_list3)))))));;
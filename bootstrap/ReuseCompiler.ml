type _slice = bytes;;
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
            (Cons ((Cons (x45, Empty)), Empty))
         | (Cons (x46, (Cons (x47, rest6)))) -> 
            (match (f20 x46 x47) with
                 | True -> 
                    (list_partition_by2 x46 (list_partition_by f20 (Cons (x47, rest6))))
                 | False -> 
                    (Cons ((Cons (x46, Empty)), (list_partition_by f20 (Cons (x47, rest6)))))));;

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

let rec list_pairs xs15 = 
    (match xs15 with
         | (Cons (a20, (Cons (b16, rest7)))) -> 
            (Cons ((Pair (a20, b16)), (list_pairs rest7)))
         | x49 -> 
            Empty);;

let rec list_find_first predicate list18 = 
    (match list18 with
         | Empty -> 
            None
         | (Cons (x50, xs16)) -> 
            (match (predicate x50) with
                 | True -> 
                    (Some (x50))
                 | False -> 
                    (list_find_first predicate xs16)));;

let rec list_filter f21 list19 = 
    (list_foldr (fun head3 tail3 -> (match (f21 head3) with
         | True -> 
            (Cons (head3, tail3))
         | False -> 
            tail3)) Empty list19);;

let rec list_exclude f22 list20 = 
    (list_filter (fun x51 -> (not (f22 x51))) list20);;

let rec list_any f23 list21 = 
    (match (list_find_first f23 list21) with
         | (Some (x52)) -> 
            True
         | x53 -> 
            False);;

let rec list_every f24 list22 = 
    (match (list_find_first (fun x54 -> (not (f24 x54))) list22) with
         | (Some (x55)) -> 
            False
         | x56 -> 
            True);;

let rec list_from_maybe maybe8 = 
    (match maybe8 with
         | (Some (x57)) -> 
            (Cons (x57, Empty))
         | None -> 
            Empty);;

let rec list_collect_from_indexed_iterator2 predicate2 iterator3 initial5 = 
    (match (indexed_iterator_next iterator3) with
         | (Pair (None, x58)) -> 
            (Pair (iterator3, initial5))
         | (Pair ((Some (x59)), next2)) -> 
            (match (predicate2 x59) with
                 | True -> 
                    (list_collect_from_indexed_iterator2 predicate2 next2 (Cons (x59, initial5)))
                 | False -> 
                    (Pair (iterator3, initial5))));;

let rec list_collect_from_indexed_iterator predicate3 iterator4 = 
    (match (list_collect_from_indexed_iterator2 predicate3 iterator4 Empty) with
         | (Pair (iterator5, result2)) -> 
            (Pair (iterator5, (list_reverse result2))));;

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
         | (FTValue (x60)) -> 
            (1l)
         | (FTNode2 (size2, x61, x62)) -> 
            size2
         | (FTNode3 (size3, x63, x64, x65)) -> 
            size3);;

let rec string_node2 a21 b17 = 
    (FTNode2 ((Int32.add (string_node_size a21) (string_node_size b17)), a21, b17));;

let rec string_node3 a22 b18 c = 
    (FTNode3 ((Int32.add (string_node_size a22) (Int32.add (string_node_size b18) (string_node_size c))), a22, b18, c));;

let rec string_prepend_node a23 tree = 
    (match tree with
         | FTEmpty -> 
            (FTSingle (a23))
         | (FTSingle (x66)) -> 
            (FTDeep ((Cons (a23, Empty)), FTEmpty, (Cons (x66, Empty))))
         | (FTDeep (first, middle, last)) -> 
            (match first with
                 | (Cons (b19, (Cons (c2, (Cons (d, (Cons (e, Empty)))))))) -> 
                    (FTDeep ((Cons (a23, (Cons (b19, Empty)))), (string_prepend_node (string_node3 c2 d e) middle), last))
                 | x67 -> 
                    (FTDeep ((Cons (a23, first)), middle, last))));;

let rec string_prepend char string2 = 
    (string_prepend_node (FTValue (char)) string2);;

let rec string_append_node a24 tree2 = 
    (match tree2 with
         | FTEmpty -> 
            (FTSingle (a24))
         | (FTSingle (x68)) -> 
            (FTDeep ((Cons (x68, Empty)), FTEmpty, (Cons (a24, Empty))))
         | (FTDeep (first2, middle2, last2)) -> 
            (match last2 with
                 | (Cons (b20, (Cons (c3, (Cons (d2, (Cons (e2, Empty)))))))) -> 
                    (FTDeep (first2, (string_append_node (string_node3 e2 d2 c3) middle2), (Cons (a24, (Cons (b20, Empty))))))
                 | x69 -> 
                    (FTDeep (first2, middle2, (Cons (a24, last2))))));;

let rec string_append char2 string3 = 
    (string_append_node (FTValue (char2)) string3);;

let rec string_first_node node2 = 
    (match node2 with
         | (FTValue (x70)) -> 
            x70
         | (FTNode2 (x71, x72, x73)) -> 
            (string_first_node x72)
         | (FTNode3 (x74, x75, x76, x77)) -> 
            (string_first_node x75));;

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
         | (FTValue (x78)) -> 
            None
         | (FTNode2 (x79, a25, b21)) -> 
            (match (string_rest_node a25) with
                 | (Some (node5)) -> 
                    (Some ((string_node2 node5 b21)))
                 | None -> 
                    (Some (b21)))
         | (FTNode3 (x80, a26, b22, c4)) -> 
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
                         | x81 -> 
                            (FTDeep (rest8, middle4, last4))))
         | x82 -> 
            string5);;

let rec string_foldr_node f25 node11 identity = 
    (match node11 with
         | (FTValue (a27)) -> 
            (f25 a27 identity)
         | (FTNode2 (x83, a28, b23)) -> 
            (string_foldr_node f25 a28 (string_foldr_node f25 b23 identity))
         | (FTNode3 (x84, a29, b24, c5)) -> 
            (string_foldr_node f25 a29 (string_foldr_node f25 b24 (string_foldr_node f25 c5 identity))));;

let rec string_foldr f26 identity2 tree3 = 
    (match tree3 with
         | FTEmpty -> 
            identity2
         | (FTSingle (x85)) -> 
            (string_foldr_node f26 x85 identity2)
         | (FTDeep (first4, middle5, last5)) -> 
            (list_foldr (string_foldr_node f26) (string_foldr f26 (list_foldl (string_foldr_node f26) identity2 last5) middle5) first4));;

let rec string_foldl_node f27 node12 identity3 = 
    (match node12 with
         | (FTValue (a30)) -> 
            (f27 a30 identity3)
         | (FTNode2 (x86, b25, a31)) -> 
            (string_foldl_node f27 a31 (string_foldl_node f27 b25 identity3))
         | (FTNode3 (x87, c6, b26, a32)) -> 
            (string_foldl_node f27 a32 (string_foldl_node f27 b26 (string_foldl_node f27 c6 identity3))));;

let rec string_foldl f28 identity4 tree4 = 
    (match tree4 with
         | FTEmpty -> 
            identity4
         | (FTSingle (x88)) -> 
            (string_foldl_node f28 x88 identity4)
         | (FTDeep (first5, middle6, last6)) -> 
            (list_foldr (string_foldl_node f28) (string_foldl f28 (list_foldl (string_foldl_node f28) identity4 first5) middle6) last6));;

let rec string_size string6 = 
    (match string6 with
         | FTEmpty -> 
            (0l)
         | (FTSingle (x89)) -> 
            (string_node_size x89)
         | (FTDeep (first6, middle7, last7)) -> 
            (Int32.add (list_foldr Int32.add (0l) (list_map string_node_size first6)) (Int32.add (list_foldr Int32.add (0l) (list_map string_node_size last7)) (string_size middle7))));;

let rec string_concat_nodes nodes = 
    (match nodes with
         | (Cons (a33, (Cons (b27, Empty)))) -> 
            (Cons ((string_node2 a33 b27), Empty))
         | (Cons (a34, (Cons (b28, (Cons (c7, Empty)))))) -> 
            (Cons ((string_node3 a34 b28 c7), Empty))
         | (Cons (a35, (Cons (b29, (Cons (c8, (Cons (d3, Empty)))))))) -> 
            (Cons ((string_node2 a35 b29), (Cons ((string_node2 c8 d3), Empty))))
         | (Cons (a36, (Cons (b30, (Cons (c9, rest9)))))) -> 
            (Cons ((string_node3 a36 b30 c9), (string_concat_nodes rest9)))
         | x90 -> 
            Empty);;

type ('Ta37,'Tb31,'Tc10) triple  = 
     | Triple : 'Ta37 * 'Tb31 * 'Tc10 -> ('Ta37,'Tb31,'Tc10) triple;;

let rec string_concat2 a38 nodes2 b32 = 
    (match (Triple (a38, nodes2, b32)) with
         | (Triple (FTEmpty, nodes3, b33)) -> 
            (list_foldr string_prepend_node b33 nodes3)
         | (Triple (a39, nodes4, FTEmpty)) -> 
            (list_foldl string_append_node a39 nodes4)
         | (Triple ((FTSingle (x91)), nodes5, b34)) -> 
            (string_prepend_node x91 (list_foldr string_prepend_node b34 nodes5))
         | (Triple (a40, nodes6, (FTSingle (x92)))) -> 
            (string_append_node x92 (list_foldl string_append_node a40 nodes6))
         | (Triple ((FTDeep (first1, middle1, last1)), nodes7, (FTDeep (first22, middle22, last22)))) -> 
            (FTDeep (first1, (string_concat2 middle1 (string_concat_nodes (list_concat (list_reverse last1) (list_concat nodes7 first22))) middle22), last22)));;

let rec string_concat a41 b35 = 
    (string_concat2 a41 Empty b35);;

let rec string_is_empty string7 = 
    (match (string_first string7) with
         | (Some (x93)) -> 
            False
         | None -> 
            True);;

let rec string_any predicate4 string8 = 
    (string_foldl (fun x94 b36 -> (or2 (predicate4 x94) b36)) False string8);;

let rec string_every predicate5 string9 = 
    (string_foldl (fun x95 b37 -> (and2 (predicate5 x95) b37)) True string9);;

let rec string_to_list string10 = 
    (string_foldr list_cons Empty string10);;

let rec string_from_list list23 = 
    (list_foldl string_append (string_empty ()) list23);;

let rec string_skip count3 string11 = 
    (match string11 with
         | FTEmpty -> 
            FTEmpty
         | x96 -> 
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

let rec string_flatmap f29 string18 = 
    (string_foldl (fun x97 xs17 -> (string_concat xs17 (f29 x97))) (string_empty ()) string18);;

let rec string_split2 separator2 list24 current parts = 
    (match list24 with
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

let rec string_trim_start2 list25 = 
    (match list25 with
         | (Cons (x98, xs18)) -> 
            (match (x4 x98 (32l)) with
                 | True -> 
                    (string_trim_start2 xs18)
                 | False -> 
                    list25)
         | Empty -> 
            list25);;

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

let rec string_index_of index3 substring string23 = 
    (match (x6 index3 (string_size string23)) with
         | True -> 
            None
         | False -> 
            (match (string_equal substring (string_substring index3 (string_size substring) string23)) with
                 | True -> 
                    (Some (index3))
                 | False -> 
                    (string_index_of (Int32.add index3 (1l)) substring string23)));;

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

let rec string_to_int322 string_to_int323 string24 accumulator x99 = 
    (string_to_int323 string24 (Some ((Int32.add (Int32.mul (10l) accumulator) (Int32.sub x99 (48l))))));;

let rec string_to_int324 string25 accumulator2 = 
    (match string25 with
         | Empty -> 
            accumulator2
         | (Cons (x100, rest12)) -> 
            (maybe_flatmap (fun accumulator3 -> ((maybe_flatmap (string_to_int322 string_to_int324 rest12 accumulator3)) ((maybe_filter string_point_is_digit) (Some (x100))))) accumulator2));;

let rec string_to_int325 string26 = 
    (match string26 with
         | (Cons (45l, string27)) -> 
            (match (list_is_empty string27) with
                 | True -> 
                    None
                 | False -> 
                    (maybe_map (fun x101 -> (Int32.mul (-1l) x101)) (string_to_int325 string27)))
         | (Cons (x102, rest13)) -> 
            (match (string_point_is_digit x102) with
                 | True -> 
                    (string_to_int324 string26 (Some ((0l))))
                 | False -> 
                    None)
         | Empty -> 
            None);;

let rec string_to_int32 string28 = 
    (string_to_int325 (string_to_list string28));;

let rec string_from_int322 integer string29 = 
    (match (x3 integer (9l)) with
         | True -> 
            (string_from_int322 (Int32.div integer (10l)) (Cons ((Int32.add (Int32.rem integer (10l)) (48l)), string29)))
         | False -> 
            (Cons ((Int32.add integer (48l)), string29)));;

let rec string_from_int323 integer2 = 
    (match (x2 integer2 (0l)) with
         | True -> 
            (match (x4 integer2 (-2147483648l)) with
                 | True -> 
                    (Cons ((45l), (Cons ((50l), (Cons ((49l), (Cons ((52l), (Cons ((55l), (Cons ((52l), (Cons ((56l), (Cons ((51l), (Cons ((54l), (Cons ((52l), (Cons ((56l), Empty))))))))))))))))))))))
                 | False -> 
                    (Cons ((45l), (string_from_int323 (Int32.mul integer2 (-1l))))))
         | False -> 
            (string_from_int322 integer2 Empty));;

let rec string_from_int32 integer3 = 
    (string_from_list (string_from_int323 integer3));;

let rec string_collect_from_slice2 predicate6 index4 slice2 initial6 = 
    (match (x2 index4 (slice_size slice2)) with
         | False -> 
            (Pair (index4, initial6))
         | True -> 
            (match (predicate6 (slice_get slice2 index4)) with
                 | True -> 
                    (string_collect_from_slice2 predicate6 (Int32.add index4 (1l)) slice2 (string_append (slice_get slice2 index4) initial6))
                 | False -> 
                    (Pair (index4, initial6))));;

let rec string_collect_from_slice predicate7 index5 slice3 = 
    (string_collect_from_slice2 predicate7 index5 slice3 (string_empty ()));;

let rec string_to_slice string30 = 
    (string_foldl (fun c12 slice4 -> (slice_concat slice4 (slice_of_u8 c12 (1l)))) (slice_empty ()) string30);;

let rec string_from_slice slice5 = 
    (slice_foldl string_append (string_empty ()) slice5);;

let rec string_collect_from_indexed_iterator2 predicate8 iterator6 initial7 = 
    (match (indexed_iterator_next iterator6) with
         | (Pair (None, x103)) -> 
            (Pair (iterator6, initial7))
         | (Pair ((Some (x104)), next3)) -> 
            (match (predicate8 x104) with
                 | True -> 
                    (string_collect_from_indexed_iterator2 predicate8 next3 (string_append x104 initial7))
                 | False -> 
                    (Pair (iterator6, initial7))));;

let rec string_collect_from_indexed_iterator predicate9 iterator7 = 
    (string_collect_from_indexed_iterator2 predicate9 iterator7 (string_empty ()));;

let rec string_from_indexed_iterator iterator8 = 
    (pair_right (string_collect_from_indexed_iterator (fun x105 -> True) iterator8));;

let rec string_iterable () = 
    (IterableClass ((fun string31 -> (Pair ((string_first string31), (string_rest string31))))));;

let rec string_from_boolean boolean2 = 
    (match boolean2 with
         | True -> 
            (string_from_list (Cons ((84l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))))
         | False -> 
            (string_from_list (Cons ((70l), (Cons ((97l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty))))))))))));;

let rec valid_string_from_unicode_code_point point2 = 
    (match (x3 point2 (65535l)) with
         | True -> 
            (string_from_list (Cons ((Int32.add (240l) (Int32.div (Int32.logand point2 (1835008l)) (262144l))), (Cons ((Int32.add (128l) (Int32.div (Int32.logand point2 (258048l)) (4096l))), (Cons ((Int32.add (128l) (Int32.div (Int32.logand point2 (4032l)) (64l))), (Cons ((Int32.add (128l) (Int32.logand point2 (63l))), Empty)))))))))
         | False -> 
            (match (x3 point2 (2047l)) with
                 | True -> 
                    (string_from_list (Cons ((Int32.add (224l) (Int32.div (Int32.logand point2 (61440l)) (4096l))), (Cons ((Int32.add (128l) (Int32.div (Int32.logand point2 (4032l)) (64l))), (Cons ((Int32.add (128l) (Int32.logand point2 (63l))), Empty)))))))
                 | False -> 
                    (match (x3 point2 (127l)) with
                         | True -> 
                            (string_from_list (Cons ((Int32.add (192l) (Int32.div (Int32.logand point2 (1984l)) (64l))), (Cons ((Int32.add (128l) (Int32.logand point2 (63l))), Empty)))))
                         | False -> 
                            (string_of_char point2))));;

let rec invalid_code_point () = 
    (string_from_list (Cons ((255l), (Cons ((253l), Empty)))));;

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

let rec result_bimap f30 g3 result5 = 
    (match result5 with
         | (Result (x106)) -> 
            (Result ((f30 x106)))
         | (Error (y8)) -> 
            (Error ((g3 y8))));;

let rec result_either f31 g4 result6 = 
    (match result6 with
         | (Result (x107)) -> 
            (f31 x107)
         | (Error (x108)) -> 
            (g4 x108));;

let rec result_map f32 result7 = 
    (result_bimap f32 id result7);;

let rec result_flatmap f33 result8 = 
    (match result8 with
         | (Result (x109)) -> 
            (f33 x109)
         | (Error (error4)) -> 
            (Error (error4)));;

let rec result_or_else value6 result9 = 
    (match result9 with
         | (Result (x110)) -> 
            x110
         | (Error (x111)) -> 
            value6);;

let rec result_error2 result10 = 
    (match result10 with
         | (Error (x112)) -> 
            True
         | x113 -> 
            False);;

let rec result_filter_list list26 = 
    (list_foldr (fun result11 new_list -> (match result11 with
         | (Result (x114)) -> 
            (Cons (x114, new_list))
         | x115 -> 
            new_list)) Empty list26);;

let rec result_partition list27 = 
    (list_foldr (fun result12 state2 -> (match result12 with
         | (Result (x116)) -> 
            (Pair ((Cons (x116, (pair_left state2))), (pair_right state2)))
         | (Error (e4)) -> 
            (Pair ((pair_left state2), (Cons (e4, (pair_right state2))))))) (Pair (Empty, Empty)) list27);;

let rec result_concat list28 = 
    (match (list_filter result_error2 list28) with
         | (Cons ((Error (error5)), x117)) -> 
            (Error (error5))
         | (Cons ((Result (x118)), x119)) -> 
            (Result (Empty))
         | Empty -> 
            (Result ((result_filter_list list28))));;

let rec result_of_maybe error6 maybe9 = 
    (match maybe9 with
         | (Some (x120)) -> 
            (Result (x120))
         | None -> 
            (Error (error6)));;

let rec result_bind result13 f34 = 
    (result_flatmap f34 result13);;

let rec result_return value7 = 
    (result_lift value7);;

type ('Ts,'Tv2) state  = 
     | Operation : ('Ts -> ('Ts,'Tv2) pair) -> ('Ts,'Tv2) state;;

let rec state_run state3 operation = 
    (match operation with
         | (Operation (f35)) -> 
            (f35 state3));;

let rec state_final_value initial_state operation2 = 
    (match (state_run initial_state operation2) with
         | (Pair (x121, value8)) -> 
            value8);;

let rec state_return value9 = 
    (Operation ((fun state4 -> (Pair (state4, value9)))));;

let rec state_bind operation3 f36 = 
    (Operation ((fun state5 -> (match (state_run state5 operation3) with
         | (Pair (new_state, new_value2)) -> 
            (state_run new_state (f36 new_value2))))));;

let rec state_get () = 
    (Operation ((fun state6 -> (Pair (state6, state6)))));;

let rec state_set state7 = 
    (Operation ((fun x122 -> (Pair (state7, state7)))));;

let rec state_modify f37 = 
    (state_bind (state_get ()) (fun state8 -> (state_set (f37 state8))));;

let rec state_let value10 f38 = 
    (state_bind (state_return value10) f38);;

let rec state_foldr f39 initial_value operations = 
    (list_foldr (fun operation4 chain -> (state_bind operation4 (fun x123 -> (state_bind chain (fun xs19 -> (state_return (f39 x123 xs19))))))) (state_return initial_value) operations);;

let rec state_foreach f40 xs20 = 
    (state_foldr list_cons Empty (list_map f40 xs20));;

let rec state_flatmap f41 operation5 = 
    (state_bind operation5 f41);;

let rec state_map f42 operation6 = 
    (state_flatmap (fun x51 -> (state_return (f42 x51))) operation6);;

let rec state_lift value11 = 
    (state_return value11);;

type array_color  = 
     | ArrayRed
     | ArrayBlack;;

type ('Tvalue12) array  = 
     | ArrayEmpty
     | ArrayTree : array_color * ('Tvalue12) array * (int32,'Tvalue12) pair * ('Tvalue12) array -> ('Tvalue12) array;;

let rec array_empty () = 
    ArrayEmpty;;

let rec array_make_black array2 = 
    (match array2 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (x124, a43, y9, b39)) -> 
            (ArrayTree (ArrayBlack, a43, y9, b39)));;

let rec array_balance array3 = 
    (match array3 with
         | (ArrayTree (ArrayBlack, (ArrayTree (ArrayRed, (ArrayTree (ArrayRed, a44, x125, b40)), y10, c13)), z, d4)) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a44, x125, b40)), y10, (ArrayTree (ArrayBlack, c13, z, d4))))
         | (ArrayTree (ArrayBlack, (ArrayTree (ArrayRed, a45, x126, (ArrayTree (ArrayRed, b41, y11, c14)))), z2, d5)) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a45, x126, b41)), y11, (ArrayTree (ArrayBlack, c14, z2, d5))))
         | (ArrayTree (ArrayBlack, a46, x127, (ArrayTree (ArrayRed, (ArrayTree (ArrayRed, b42, y12, c15)), z3, d6)))) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a46, x127, b42)), y12, (ArrayTree (ArrayBlack, c15, z3, d6))))
         | (ArrayTree (ArrayBlack, a47, x128, (ArrayTree (ArrayRed, b43, y13, (ArrayTree (ArrayRed, c16, z4, d7)))))) -> 
            (ArrayTree (ArrayRed, (ArrayTree (ArrayBlack, a47, x128, b43)), y13, (ArrayTree (ArrayBlack, c16, z4, d7))))
         | rest14 -> 
            rest14);;

let rec array_set2 x129 value13 array4 = 
    (match array4 with
         | ArrayEmpty -> 
            (ArrayTree (ArrayRed, ArrayEmpty, (Pair (x129, value13)), ArrayEmpty))
         | (ArrayTree (color, a48, y14, b44)) -> 
            (match (x2 x129 (pair_left y14)) with
                 | True -> 
                    (array_balance (ArrayTree (color, (array_set2 x129 value13 a48), y14, b44)))
                 | False -> 
                    (match (x3 x129 (pair_left y14)) with
                         | True -> 
                            (array_balance (ArrayTree (color, a48, y14, (array_set2 x129 value13 b44))))
                         | False -> 
                            (ArrayTree (color, a48, (Pair (x129, value13)), b44)))));;

let rec array_set x130 value14 array5 = 
    (array_make_black (array_set2 x130 value14 array5));;

let rec array_get x131 array6 = 
    (match array6 with
         | ArrayEmpty -> 
            None
         | (ArrayTree (x132, a49, (Pair (y15, value15)), b45)) -> 
            (match (x2 x131 y15) with
                 | True -> 
                    (array_get x131 a49)
                 | False -> 
                    (match (x3 x131 y15) with
                         | True -> 
                            (array_get x131 b45)
                         | False -> 
                            (Some (value15)))));;

let rec array_min array7 default = 
    (match array7 with
         | ArrayEmpty -> 
            default
         | (ArrayTree (x133, ArrayEmpty, y16, x134)) -> 
            y16
         | (ArrayTree (x135, a50, x136, x137)) -> 
            (array_min a50 default));;

let rec array_remove_min array8 = 
    (match array8 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (x138, ArrayEmpty, y17, b46)) -> 
            b46
         | (ArrayTree (color2, a51, y18, b47)) -> 
            (array_balance (ArrayTree (color2, (array_remove_min a51), y18, b47))));;

let rec array_remove_root array9 = 
    (match array9 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (x139, ArrayEmpty, y19, ArrayEmpty)) -> 
            ArrayEmpty
         | (ArrayTree (x140, a52, y20, ArrayEmpty)) -> 
            a52
         | (ArrayTree (x141, ArrayEmpty, y21, b48)) -> 
            b48
         | (ArrayTree (color3, a53, y22, b49)) -> 
            (array_balance (ArrayTree (color3, a53, (array_min b49 y22), (array_remove_min b49)))));;

let rec array_remove2 x142 array10 = 
    (match array10 with
         | ArrayEmpty -> 
            ArrayEmpty
         | (ArrayTree (color4, a54, y23, b50)) -> 
            (match (x2 x142 (pair_left y23)) with
                 | True -> 
                    (array_balance (ArrayTree (color4, (array_remove2 x142 a54), y23, b50)))
                 | False -> 
                    (match (x3 x142 (pair_left y23)) with
                         | True -> 
                            (array_balance (ArrayTree (color4, a54, y23, (array_remove2 x142 b50))))
                         | False -> 
                            (array_remove_root array10))));;

let rec array_remove x143 array11 = 
    (array_make_black (array_remove2 x143 array11));;

let rec array_entries array12 = 
    (match array12 with
         | ArrayEmpty -> 
            Empty
         | (ArrayTree (x144, a55, entry, b51)) -> 
            (list_flatten (Cons ((array_entries a55), (Cons ((Cons (entry, Empty)), (Cons ((array_entries b51), Empty))))))));;

let rec array_from_list2 entries index6 array13 = 
    (match entries with
         | (Cons (x145, xs21)) -> 
            (array_from_list2 xs21 (Int32.add index6 (1l)) (array_set index6 x145 array13))
         | Empty -> 
            array13);;

let rec array_from_list entries2 = 
    (array_from_list2 entries2 (0l) ArrayEmpty);;

let rec array_of entries3 = 
    (list_foldl (fun entry2 array14 -> (match entry2 with
         | (Pair (key, value16)) -> 
            (array_set key value16 array14))) ArrayEmpty entries3);;

let rec array_singleton index7 value17 = 
    (ArrayTree (ArrayBlack, ArrayEmpty, (Pair (index7, value17)), ArrayEmpty));;

let rec array_get_or index8 default2 array15 = 
    (match (array_get index8 array15) with
         | (Some (value18)) -> 
            value18
         | None -> 
            default2);;

let rec array_size array16 = 
    (list_size (array_entries array16));;

type ('Tvalue19) dictionary  = 
     | Dictionary : (((string,'Tvalue19) pair) list) array -> ('Tvalue19) dictionary;;

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
                            (Dictionary ((array_set bucket_id (Cons ((Pair (key3, new_value3)), Empty)) array17))))));;

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

let rec dictionary_singleton key6 value20 = 
    (dictionary_set key6 value20 (dictionary_empty ()));;

let rec dictionary_get_or key7 default3 dictionary6 = 
    (match (dictionary_get key7 dictionary6) with
         | (Some (value21)) -> 
            value21
         | None -> 
            default3);;

let rec dictionary_size dictionary7 = 
    (list_size (dictionary_entries dictionary7));;

let rec dictionary_has key8 dictionary8 = 
    (match (dictionary_get key8 dictionary8) with
         | (Some (x146)) -> 
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
         | (Cons (x147, Empty)) -> 
            parts2
         | (Cons (x148, xs22)) -> 
            (match (x4 x148 (0l)) with
                 | True -> 
                    (bigint_trim_parts_reversed xs22)
                 | False -> 
                    parts2)
         | Empty -> 
            Empty);;

let rec bigint_trim_parts parts3 = 
    (list_reverse (bigint_trim_parts_reversed (list_reverse parts3)));;

let rec bigint_from_string string32 = 
    (match (string_first string32) with
         | (Some (45l)) -> 
            (Bigint (True, (bigint_trim_parts (list_reverse (list_map ((flip Int32.sub) (48l)) (string_to_list (string_rest string32)))))))
         | x149 -> 
            (Bigint (False, (bigint_trim_parts (list_reverse (list_map ((flip Int32.sub) (48l)) (string_to_list string32)))))));;

let rec bigint_from int = 
    (bigint_from_string (string_from_int32 int));;

let rec bigint_zero () = 
    (Bigint (False, (Cons ((0l), Empty))));;

let rec bigint_one () = 
    (Bigint (False, (Cons ((1l), Empty))));;

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

let rec less_than_with_carry x150 y24 previous_less_than = 
    (match (x2 x150 y24) with
         | True -> 
            True
         | False -> 
            (match (x4 x150 y24) with
                 | True -> 
                    previous_less_than
                 | False -> 
                    False));;

let rec bigint_less_than_parts a56 b52 previous_less_than2 = 
    (match (Pair (a56, b52)) with
         | (Pair (Empty, Empty)) -> 
            False
         | (Pair ((Cons (x151, x152)), Empty)) -> 
            False
         | (Pair (Empty, (Cons (x153, x154)))) -> 
            True
         | (Pair ((Cons (x155, Empty)), (Cons (y25, Empty)))) -> 
            (less_than_with_carry x155 y25 previous_less_than2)
         | (Pair ((Cons (x156, xs23)), (Cons (y26, ys4)))) -> 
            (bigint_less_than_parts xs23 ys4 (less_than_with_carry x156 y26 previous_less_than2)));;

let rec bigint_less_than a57 b53 = 
    (match (Pair (a57, b53)) with
         | (Pair ((Bigint (True, x157)), (Bigint (False, x158)))) -> 
            True
         | (Pair ((Bigint (False, x159)), (Bigint (True, x160)))) -> 
            False
         | (Pair ((Bigint (True, a_parts)), (Bigint (True, b_parts)))) -> 
            (bigint_less_than_parts b_parts a_parts False)
         | (Pair ((Bigint (x161, a_parts2)), (Bigint (x162, b_parts2)))) -> 
            (bigint_less_than_parts a_parts2 b_parts2 False));;

let rec bigint_subtract_parts a58 b54 carry = 
    (match (Pair (a58, b54)) with
         | (Pair ((Cons (x163, xs24)), Empty)) -> 
            (bigint_subtract_parts a58 (Cons ((0l), Empty)) carry)
         | (Pair ((Cons (x164, xs25)), (Cons (y27, ys5)))) -> 
            (match (x2 (Int32.sub x164 (Int32.add y27 carry)) (0l)) with
                 | True -> 
                    (Cons ((Int32.sub (Int32.add x164 (10l)) (Int32.add y27 carry)), (bigint_subtract_parts xs25 ys5 (1l))))
                 | False -> 
                    (Cons ((Int32.sub x164 (Int32.add y27 carry)), (bigint_subtract_parts xs25 ys5 (0l)))))
         | x165 -> 
            Empty);;

let rec bigint_add_parts a59 b55 carry2 = 
    (match (Pair (a59, b55)) with
         | (Pair ((Cons (x166, xs26)), (Cons (y28, ys6)))) -> 
            (match (x3 (Int32.add x166 (Int32.add y28 carry2)) (9l)) with
                 | True -> 
                    (Cons ((Int32.sub (Int32.add x166 (Int32.add y28 carry2)) (10l)), (bigint_add_parts xs26 ys6 (1l))))
                 | False -> 
                    (Cons ((Int32.add x166 (Int32.add y28 carry2)), (bigint_add_parts xs26 ys6 (0l)))))
         | (Pair ((Cons (x167, x168)), Empty)) -> 
            (bigint_add_parts a59 (Cons ((0l), Empty)) carry2)
         | (Pair (Empty, (Cons (x169, x170)))) -> 
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
         | x171 -> 
            (bigint_add_zeroes (Int32.sub n6 (1l)) (Cons ((0l), digits))));;

let rec bigint_multiply_digit x172 digits2 carry3 = 
    (match digits2 with
         | Empty -> 
            (match (x3 carry3 (0l)) with
                 | True -> 
                    (Cons (carry3, Empty))
                 | False -> 
                    Empty)
         | (Cons (y29, ys7)) -> 
            (Cons ((Int32.rem (Int32.add (Int32.mul x172 y29) carry3) (10l)), (bigint_multiply_digit x172 ys7 (Int32.div (Int32.add (Int32.mul x172 y29) carry3) (10l))))));;

let rec bigint_multiply_parts a60 b56 base = 
    (match a60 with
         | (Cons (x173, xs27)) -> 
            (bigint_add_parts (bigint_add_zeroes base (bigint_multiply_digit x173 b56 (0l))) (bigint_multiply_parts xs27 b56 (Int32.add base (1l))) (0l))
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
         | (Pair ((Bigint (True, x174)), (Bigint (False, x175)))) -> 
            (bigint_subtract b58 (bigint_negate a62))
         | (Pair ((Bigint (False, x176)), (Bigint (True, x177)))) -> 
            (bigint_subtract a62 (bigint_negate b58)));;

let rec bigint_multiply a63 b59 = 
    (match (Pair (a63, b59)) with
         | (Pair ((Bigint (x178, (Cons (0l, Empty)))), (Bigint (x179, x180)))) -> 
            (Bigint (False, (Cons ((0l), Empty))))
         | (Pair ((Bigint (x181, x182)), (Bigint (x183, (Cons (0l, Empty)))))) -> 
            (Bigint (False, (Cons ((0l), Empty))))
         | (Pair ((Bigint (True, a_parts9)), (Bigint (False, b_parts9)))) -> 
            (Bigint (True, (bigint_multiply_parts a_parts9 b_parts9 (0l))))
         | (Pair ((Bigint (False, a_parts10)), (Bigint (True, b_parts10)))) -> 
            (Bigint (True, (bigint_trim_parts (bigint_multiply_parts a_parts10 b_parts10 (0l)))))
         | (Pair ((Bigint (x184, a_parts11)), (Bigint (x185, b_parts11)))) -> 
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
         | x186 -> 
            False);;

let rec atom_character character3 = 
    (match character3 with
         | 40l -> 
            False
         | 41l -> 
            False
         | x187 -> 
            (not (whitespace character3)));;

type range  = 
     | Range : int32 * int32 -> range;;

type sexp  = 
     | Symbol : int32 * string * range -> sexp
     | Integer : int32 * range -> sexp
     | List : (sexp) list * range -> sexp;;

let rec sexp_range sexp2 = 
    (match sexp2 with
         | (Symbol (x188, x189, range2)) -> 
            range2
         | (Integer (x190, range3)) -> 
            range3
         | (List (x191, range4)) -> 
            range4);;

let rec sexp_symbol_text sexp3 = 
    (match sexp3 with
         | (Symbol (x192, text, x193)) -> 
            (Some (text))
         | x194 -> 
            None);;

type parse_error  = 
     | ParseErrorTooFewClosingBrackets
     | ParseErrorTooManyClosingBrackets;;

type ('Tsymbol,'Tvalue22) parser_result  = 
     | ParserResult : int32 * (int32,('Tsymbol) dictionary) pair * 'Tvalue22 -> ('Tsymbol,'Tvalue22) parser_result
     | ParserError : parse_error -> ('Tsymbol,'Tvalue22) parser_result
     | ParserEnd : int32 -> ('Tsymbol,'Tvalue22) parser_result;;

let rec intern_string index9 next_index name symbol_state = 
    (match symbol_state with
         | (Pair (token, symbols)) -> 
            (match (dictionary_get name symbols) with
                 | (Some ((Pair (token2, name2)))) -> 
                    (ParserResult (next_index, symbol_state, (Symbol (token2, name2, (Range (index9, next_index))))))
                 | None -> 
                    (ParserResult (next_index, (Pair ((Int32.add token (1l)), (dictionary_set name (Pair (token, name)) symbols))), (Symbol (token, name, (Range (index9, next_index))))))));;

let rec parse_symbol index10 slice6 symbols2 = 
    (match (string_collect_from_slice atom_character index10 slice6) with
         | (Pair (next_index2, name3)) -> 
            (match (string_to_int32 name3) with
                 | (Some (integer4)) -> 
                    (ParserResult (next_index2, symbols2, (Integer (integer4, (Range (index10, next_index2))))))
                 | None -> 
                    (match (string_is_empty name3) with
                         | False -> 
                            (intern_string index10 next_index2 name3 symbols2)
                         | True -> 
                            (ParserEnd (index10)))));;

let rec parse_list index11 slice7 parse_sexps2 symbols3 = 
    (match (parse_sexps2 index11 slice7 symbols3 Empty) with
         | (ParserResult (next_index3, symbols4, expressions)) -> 
            (ParserResult (next_index3, symbols4, (List (expressions, (Range ((Int32.sub index11 (1l)), next_index3))))))
         | (ParserError (error7)) -> 
            (ParserError (error7))
         | (ParserEnd (index12)) -> 
            (ParserEnd (index12)));;

let rec parse_expression depth index13 slice8 parse_sexps3 symbols5 = 
    (match (x2 index13 (slice_size slice8)) with
         | False -> 
            (match depth with
                 | 0l -> 
                    (ParserEnd (index13))
                 | x195 -> 
                    (ParserError (ParseErrorTooFewClosingBrackets)))
         | True -> 
            (match (slice_get slice8 index13) with
                 | 40l -> 
                    (parse_list (Int32.add index13 (1l)) slice8 (parse_sexps3 (Int32.add depth (1l))) symbols5)
                 | 41l -> 
                    (match depth with
                         | 0l -> 
                            (ParserError (ParseErrorTooManyClosingBrackets))
                         | x196 -> 
                            (ParserEnd ((Int32.add index13 (1l)))))
                 | x197 -> 
                    (match (whitespace x197) with
                         | True -> 
                            (parse_expression depth (Int32.add index13 (1l)) slice8 parse_sexps3 symbols5)
                         | False -> 
                            (parse_symbol index13 slice8 symbols5))));;

let rec parse_sexps4 depth2 index14 slice9 symbols6 expressions2 = 
    (match (parse_expression depth2 index14 slice9 parse_sexps4 symbols6) with
         | (ParserResult (index15, symbols7, expression2)) -> 
            (parse_sexps4 depth2 index15 slice9 symbols7 (Cons (expression2, expressions2)))
         | (ParserError (error8)) -> 
            (ParserError (error8))
         | (ParserEnd (index16)) -> 
            (ParserResult (index16, symbols6, (list_reverse expressions2))));;

let rec parse_sexps symbols8 slice10 = 
    (match (parse_sexps4 (0l) (0l) slice10 symbols8 Empty) with
         | (ParserResult (x198, symbols9, expressions3)) -> 
            (Result ((Pair (symbols9, expressions3))))
         | (ParserError (error9)) -> 
            (Error (error9))
         | (ParserEnd (x199)) -> 
            (Error (ParseErrorTooFewClosingBrackets)));;

let rec wrap_in_brackets string33 = 
    (string_concat (string_of_char (40l)) (string_concat string33 (string_of_char (41l))));;

let rec stringify_sexp2 stringify_sexps2 expression3 = 
    (match expression3 with
         | (Symbol (x200, name4, x201)) -> 
            name4
         | (Integer (integer5, x202)) -> 
            (string_from_int32 integer5)
         | (List (expressions4, x203)) -> 
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
         | x204 -> 
            False);;

let rec transform_line line2 = 
    (match (string_split (124l) line2) with
         | (Cons (name5, parts9)) -> 
            (string_concat (string_from_list (Cons ((40l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((32l), (Cons ((100l), (Cons ((97l), (Cons ((116l), (Cons ((97l), (Cons ((45l), Empty))))))))))))))))))))) (string_concat (string_trim name5) (string_concat (string_from_list (Cons ((32l), (Cons ((40l), (Cons ((41l), (Cons ((32l), (Cons ((40l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((105l), (Cons ((110l), (Cons ((103l), Empty))))))))))))))))))))))) (string_concat (string_from_list (Cons ((45l), (Cons ((102l), (Cons ((114l), (Cons ((111l), (Cons ((109l), (Cons ((45l), (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((32l), Empty))))))))))))))))))))))) (match (parts_are_empty parts9) with
                 | True -> 
                    (string_from_list (Cons ((69l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), (Cons ((41l), (Cons ((41l), Empty)))))))))))))))
                 | False -> 
                    (string_concat (string_from_list (Cons ((40l), (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((32l), Empty))))))))))))) (string_concat (string_join (string_of_char (32l)) (list_map string_from_int32 (string_to_list (string_join (string_of_char (124l)) parts9)))) (string_from_list (Cons ((41l), (Cons ((41l), (Cons ((41l), Empty))))))))))))))
         | Empty -> 
            (string_empty ()));;

let rec string_gen stdin_iterator = 
    (match (string_collect_from_slice (const True) (0l) stdin_iterator) with
         | (Pair (x205, stdin)) -> 
            (Result ((string_join (string_of_char (10l)) (list_map transform_line (string_split (10l) stdin))))));;

type module_reference  = 
     | ModulePath : string * boolean -> module_reference
     | ModuleSelf;;

type source_reference  = 
     | SourceReference : string * module_reference -> source_reference;;

type identifier  = 
     | Identifier : int32 * string * source_reference * range * (int32) maybe -> identifier;;

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
     | FunctionApplication : (expression) list * range -> expression;;

type definition  = 
     | TypeDefinition : identifier * boolean * (type_parameter) list * (constructor) list * range -> definition
     | FunctionDefinition : identifier * boolean * (identifier) list * expression * range -> definition
     | TargetDefinition : source_reference * _slice -> definition;;

let rec source_reference_file_path source_reference2 = 
    (match source_reference2 with
         | (SourceReference (file_path, x206)) -> 
            file_path);;

let rec source_reference_module source_reference3 = 
    (match source_reference3 with
         | (SourceReference (x207, module2)) -> 
            module2);;

let rec identifier_token identifier2 = 
    (match identifier2 with
         | (Identifier (token3, x208, x209, x210, x211)) -> 
            token3);;

let rec identifier_name identifier3 = 
    (match identifier3 with
         | (Identifier (x212, name6, x213, x214, x215)) -> 
            name6);;

let rec identifier_with_name name7 identifier4 = 
    (match identifier4 with
         | (Identifier (x216, x217, x218, x219, x220)) -> 
            (Identifier (x216, name7, x218, x219, x220)));;

let rec identifier_source_reference identifier5 = 
    (match identifier5 with
         | (Identifier (x221, x222, source_reference4, x223, x224)) -> 
            source_reference4);;

let rec identifier_module identifier6 = 
    (source_reference_module (identifier_source_reference identifier6));;

let rec identifier_range identifier7 = 
    (match identifier7 with
         | (Identifier (x225, x226, x227, range5, x228)) -> 
            range5);;

let rec identifier_id identifier8 = 
    (match identifier8 with
         | (Identifier (x229, x230, x231, x232, id2)) -> 
            id2);;

let rec identifier_is identifier9 id3 = 
    (match (identifier_id identifier9) with
         | (Some (a64)) -> 
            (x4 a64 id3)
         | None -> 
            False);;

let rec identifier_with_id id4 identifier10 = 
    (match identifier10 with
         | (Identifier (x233, x234, x235, x236, x237)) -> 
            (Identifier (x233, x234, x235, x236, id4)));;

let rec identifier_equal a65 b60 = 
    (x4 (identifier_token a65) (identifier_token b60));;

let rec module_equal a66 b61 = 
    (match a66 with
         | (ModulePath (a67, x238)) -> 
            (match b61 with
                 | (ModulePath (b62, x239)) -> 
                    (string_equal a67 b62)
                 | ModuleSelf -> 
                    False)
         | ModuleSelf -> 
            (match b61 with
                 | (ModulePath (x240, x241)) -> 
                    False
                 | ModuleSelf -> 
                    True));;

let rec definition_source_reference definition2 = 
    (match definition2 with
         | (TypeDefinition (identifier11, x242, x243, x244, x245)) -> 
            (identifier_source_reference identifier11)
         | (FunctionDefinition (identifier12, x246, x247, x248, x249)) -> 
            (identifier_source_reference identifier12)
         | (TargetDefinition (source_reference5, x250)) -> 
            source_reference5);;

let rec definition_module definition3 = 
    (source_reference_module (definition_source_reference definition3));;

let rec definition_public definition4 = 
    (match definition4 with
         | (TypeDefinition (x251, public, x252, x253, x254)) -> 
            public
         | (FunctionDefinition (x255, public2, x256, x257, x258)) -> 
            public2
         | (TargetDefinition (x259, x260)) -> 
            False);;

let rec definition_identifier definition5 = 
    (match definition5 with
         | (TypeDefinition (identifier13, x261, x262, x263, x264)) -> 
            (Some (identifier13))
         | (FunctionDefinition (identifier14, x265, x266, x267, x268)) -> 
            (Some (identifier14))
         | (TargetDefinition (x269, x270)) -> 
            None);;

let rec constructor_identifier constructor2 = 
    (match constructor2 with
         | (ComplexConstructor (identifier15, x271, x272)) -> 
            identifier15
         | (SimpleConstructor (identifier16)) -> 
            identifier16);;

let rec type_parameter_identifier parameter = 
    (match parameter with
         | (UniversalParameter (identifier17)) -> 
            identifier17
         | (ExistentialParameter (identifier18)) -> 
            identifier18);;

let rec captured_identifiers_from_pattern pattern2 = 
    (match pattern2 with
         | (Capture (identifier19)) -> 
            (Cons (identifier19, Empty))
         | (ConstructorPattern (x273, patterns, x274)) -> 
            (list_flatmap captured_identifiers_from_pattern patterns)
         | x275 -> 
            Empty);;

let rec identifiers_from_definition definition6 = 
    (match definition6 with
         | (TypeDefinition (name8, x276, x277, constructors, x278)) -> 
            (Cons (name8, (list_map constructor_identifier constructors)))
         | (FunctionDefinition (name9, x279, arguments, x280, x281)) -> 
            (Cons (name9, Empty))
         | (TargetDefinition (x282, x283)) -> 
            Empty);;

let rec public_identifiers definitions = 
    ((list_flatmap list_from_maybe) ((list_map definition_identifier) ((list_filter definition_public) definitions)));;

let rec over_match_pair_expression f43 pair9 = 
    (match pair9 with
         | (Pair (pattern3, expression5)) -> 
            (result_bind (f43 expression5) (fun expression6 -> (result_return (Pair (pattern3, expression6))))));;

let rec over_match_pair_expressions over_subexpressions2 f44 pairs = 
    (result_concat (list_map (over_match_pair_expression (fun x51 -> ((result_flatmap (over_subexpressions2 f44)) (f44 x51)))) pairs));;

let rec over_subexpressions f45 expression7 = 
    (result_bind (f45 expression7) (fun expression8 -> (match expression8 with
         | (Lambda (arguments2, expression9, range6)) -> 
            (result_bind (f45 expression9) (fun expression10 -> (result_bind (over_subexpressions f45 expression10) (fun expression11 -> (result_return (Lambda (arguments2, expression11, range6)))))))
         | (Match (expression12, pairs2, range7)) -> 
            (result_bind (f45 expression12) (fun expression13 -> (result_bind (over_subexpressions f45 expression13) (fun expression14 -> (result_bind (over_match_pair_expressions over_subexpressions f45 pairs2) (fun pairs3 -> (result_return (Match (expression14, pairs3, range7)))))))))
         | (Constructor (identifier20, expressions6, range8)) -> 
            (result_bind (result_concat (list_map (fun x51 -> ((result_flatmap (over_subexpressions f45)) (f45 x51))) expressions6)) (fun expressions7 -> (result_return (Constructor (identifier20, expressions7, range8)))))
         | (FunctionApplication (expressions8, range9)) -> 
            (result_bind (result_concat (list_map (fun x51 -> ((result_flatmap (over_subexpressions f45)) (f45 x51))) expressions8)) (fun expressions9 -> (result_return (FunctionApplication (expressions9, range9)))))
         | x284 -> 
            (result_return expression8))));;

let rec over_definition_expressions f46 definition7 = 
    (match definition7 with
         | (FunctionDefinition (identifier21, public3, arguments3, expression15, range10)) -> 
            (result_bind (f46 expression15) (fun expression16 -> (result_return (FunctionDefinition (identifier21, public3, arguments3, expression16, range10)))))
         | x285 -> 
            (result_return definition7));;

let rec over_function_application f47 expression17 = 
    (match expression17 with
         | (FunctionApplication (expressions10, range11)) -> 
            (f47 expressions10 range11)
         | x286 -> 
            (result_return expression17));;

let rec over_match_expression f48 expression18 = 
    (match expression18 with
         | (Match (expression19, pairs4, range12)) -> 
            (f48 expression19 pairs4 range12)
         | x287 -> 
            (result_return expression18));;

let rec over_identifiers f49 expression20 = 
    (match expression20 with
         | (Variable (name10)) -> 
            (result_bind (f49 name10) (fun name11 -> (result_return (Variable (name11)))))
         | (Lambda (arguments4, expression21, range13)) -> 
            (result_bind (over_identifiers f49 expression21) (fun expression22 -> (result_bind (result_concat (list_map f49 arguments4)) (fun arguments5 -> (result_return (Lambda (arguments5, expression22, range13)))))))
         | (Constructor (name12, Empty, range14)) -> 
            (result_bind (f49 name12) (fun name13 -> (result_return (Constructor (name13, Empty, range14)))))
         | (Constructor (name14, expressions11, range15)) -> 
            (result_bind (result_concat (list_map (over_identifiers f49) expressions11)) (fun expressions12 -> (result_bind (f49 name14) (fun name15 -> (result_return (Constructor (name15, expressions12, range15)))))))
         | (FunctionApplication (expressions13, range16)) -> 
            (result_bind (result_concat (list_map (over_identifiers f49) expressions13)) (fun expressions14 -> (result_return (FunctionApplication (expressions14, range16)))))
         | (Match (expression23, rules, range17)) -> 
            (result_bind (result_concat (list_map (over_match_pair_expression (over_identifiers f49)) rules)) (fun rules2 -> (result_bind (over_identifiers f49 expression23) (fun expression24 -> (result_return (Match (expression24, rules2, range17)))))))
         | x288 -> 
            (result_return expression20));;

let rec expression_calls_function_in_tail_position name16 expression25 = 
    (match expression25 with
         | (FunctionApplication ((Cons ((Variable (f50)), rest15)), x289)) -> 
            (identifier_equal name16 f50)
         | (Match (x290, rules3, x291)) -> 
            (list_any (fun pair10 -> (match pair10 with
                 | (Pair (pattern4, expression26)) -> 
                    (and2 (not (list_any (identifier_equal name16) (captured_identifiers_from_pattern pattern4))) (expression_calls_function_in_tail_position name16 expression26)))) rules3)
         | x292 -> 
            False);;

let rec any_captures_match name17 pattern5 = 
    (list_any (identifier_equal name17) (captured_identifiers_from_pattern pattern5));;

let rec over_tail_recursive_match_rule name18 f51 over_tail_recursive_call2 rule = 
    (match rule with
         | (Pair (pattern6, expression27)) -> 
            (match (any_captures_match name18 pattern6) with
                 | True -> 
                    (Pair (pattern6, expression27))
                 | False -> 
                    (Pair (pattern6, (over_tail_recursive_call2 name18 f51 expression27)))));;

let rec over_tail_recursive_call name19 f52 expression28 = 
    (match expression28 with
         | (FunctionApplication ((Cons ((Variable (applied_name)), rest16)), range18)) -> 
            (match (identifier_equal name19 applied_name) with
                 | True -> 
                    (f52 rest16 range18)
                 | False -> 
                    expression28)
         | (Match (expression29, rules4, range19)) -> 
            (Match (expression29, (list_map (over_tail_recursive_match_rule name19 f52 over_tail_recursive_call) rules4), range19))
         | x293 -> 
            expression28);;

let rec data_strings_file_ending () = 
    (string_from_list (Cons ((46l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((115l), Empty)))))))))))))))));;

let rec data_reuse_file_ending () = 
    (string_from_list (Cons ((46l), (Cons ((114l), (Cons ((101l), (Cons ((117l), (Cons ((115l), (Cons ((101l), Empty)))))))))))));;

type source_file  = 
     | SourceFile : module_reference * string * _slice -> source_file;;

type source_file_type  = 
     | SourceFileTypeReuse
     | SourceFileTypeStrings
     | SourceFileTypeTargetLanguage;;

let rec source_file_of module3 path iterator9 = 
    (SourceFile (module3, path, iterator9));;

let rec source_file_module file = 
    (match file with
         | (SourceFile (module4, x294, x295)) -> 
            module4);;

let rec source_file_path file2 = 
    (match file2 with
         | (SourceFile (x296, path2, x297)) -> 
            path2);;

let rec source_file_content file3 = 
    (match file3 with
         | (SourceFile (x298, x299, content)) -> 
            content);;

let rec source_file_size file4 = 
    (match file4 with
         | (SourceFile (x300, x301, content2)) -> 
            (slice_size content2));;

let rec source_file_in_same_module a68 b63 = 
    (module_equal (source_file_module a68) (source_file_module b63));;

let rec last_n_chars n7 path3 = 
    (string_substring (Int32.sub (string_size path3) n7) n7 path3);;

let rec is_reuse_source file5 = 
    (string_equal (last_n_chars (6l) (source_file_path file5)) (data_reuse_file_ending ()));;

let rec is_strings_source file6 = 
    (string_equal (last_n_chars (8l) (source_file_path file6)) (data_strings_file_ending ()));;

let rec source_file_type2 file7 = 
    (match (is_reuse_source file7) with
         | True -> 
            SourceFileTypeReuse
         | False -> 
            (match (is_strings_source file7) with
                 | True -> 
                    SourceFileTypeStrings
                 | False -> 
                    SourceFileTypeTargetLanguage));;

type parser_scope  = 
     | ParserScope : (int32) array * parser_scope -> parser_scope
     | ParserScopeRoot : (int32) array -> parser_scope;;

let rec parser_scope_empty () = 
    (ParserScopeRoot ((array_empty ())));;

let rec parser_scope_new parent = 
    (ParserScope ((array_empty ()), parent));;

let rec parser_scope_set identifier_token2 symbol_table_id scope = 
    (match scope with
         | (ParserScope (symbols10, parent2)) -> 
            (ParserScope ((array_set identifier_token2 symbol_table_id symbols10), parent2))
         | (ParserScopeRoot (symbols11)) -> 
            (ParserScopeRoot ((array_set identifier_token2 symbol_table_id symbols11))));;

let rec parser_scope_set2 identifier22 scope2 = 
    (maybe_or_else scope2 (maybe_map (fun symbol_table_id2 -> (parser_scope_set (identifier_token identifier22) symbol_table_id2 scope2)) (identifier_id identifier22)));;

let rec parser_scope_set_all syms scope3 = 
    (list_foldl parser_scope_set2 scope3 syms);;

let rec parser_scope_resolve identifier23 scope4 = 
    (match scope4 with
         | (ParserScope (symbols12, parent3)) -> 
            (match (array_get (identifier_token identifier23) symbols12) with
                 | None -> 
                    (parser_scope_resolve identifier23 parent3)
                 | id5 -> 
                    (identifier_with_id id5 identifier23))
         | (ParserScopeRoot (symbols13)) -> 
            (identifier_with_id (array_get (identifier_token identifier23) symbols13) identifier23));;

let rec parser_scope_set_list symbols14 scope5 = 
    (list_foldl (pair_map parser_scope_set) scope5 symbols14);;

type symbol_table_entry  = 
     | SymbolTableEntry : int32 * string -> symbol_table_entry;;

type symbol_table  = 
     | SymbolTable : int32 * (symbol_table_entry) array -> symbol_table;;

let rec symbol_table_empty () = 
    (SymbolTable ((0l), (array_empty ())));;

let rec symbol_table_id3 table = 
    (match table with
         | (SymbolTable (id6, x302)) -> 
            id6);;

let rec symbol_table_bind string34 table2 = 
    (match table2 with
         | (SymbolTable (id7, array21)) -> 
            (SymbolTable ((Int32.add id7 (1l)), (array_set id7 (SymbolTableEntry (id7, string34)) array21))));;

let rec symbol_table_bind_list names table3 = 
    (list_foldl symbol_table_bind table3 names);;

let rec data_ () = 
    (string_from_list (Cons ((58l), Empty)));;

type ('Tdefinition8) parser_context  = 
     | ParserContext : source_reference * (int32,((int32,string) pair) dictionary) pair * parser_scope * parser_scope * symbol_table * ('Tdefinition8) array -> ('Tdefinition8) parser_context;;

let rec parser_context_add_constructors definition9 array22 = 
    (match definition9 with
         | (TypeDefinition (x303, x304, x305, constructors2, x306)) -> 
            (list_foldl (fun constructor3 array23 -> (array_set (identifier_token (constructor_identifier constructor3)) definition9 array23)) array22 constructors2)
         | x307 -> 
            array22);;

let rec prefix_module_symbol module5 identifier24 = 
    (match module5 with
         | (ModulePath (name20, open2)) -> 
            (match open2 with
                 | True -> 
                    identifier24
                 | False -> 
                    (identifier_with_name (string_join (data_ ()) (Cons (name20, (Cons ((identifier_name identifier24), Empty))))) identifier24))
         | ModuleSelf -> 
            identifier24);;

let rec prefix_module_symbols module6 syms2 = 
    (list_map (prefix_module_symbol module6) syms2);;

let rec parser_context_add_definition definition10 context = 
    (match context with
         | (ParserContext (source_reference6, symbols15, module_scope, global_scope, symbol_table2, constructors3)) -> 
            (let_bind (identifiers_from_definition definition10) (fun definition_symbols -> (let_bind (source_reference_module source_reference6) (fun module7 -> (ParserContext (source_reference6, symbols15, (parser_scope_set_all definition_symbols module_scope), (match (definition_public definition10) with
                 | True -> 
                    (parser_scope_set_all (prefix_module_symbols module7 definition_symbols) global_scope)
                 | False -> 
                    global_scope), symbol_table2, (parser_context_add_constructors definition10 constructors3))))))));;

let rec parser_context_token_is_constructor token4 context2 = 
    (match context2 with
         | (ParserContext (x308, x309, x310, x311, x312, constructors4)) -> 
            (match (array_get token4 constructors4) with
                 | (Some (x313)) -> 
                    True
                 | None -> 
                    False));;

let rec parser_context_new_module context3 = 
    (match context3 with
         | (ParserContext (source_reference7, symbols16, x314, global_scope2, symbol_table3, constructors5)) -> 
            (ParserContext (source_reference7, symbols16, (parser_scope_new global_scope2), global_scope2, symbol_table3, constructors5)));;

let rec parser_context_module_scope context4 = 
    (match context4 with
         | (ParserContext (x315, x316, module_scope2, x317, x318, x319)) -> 
            module_scope2);;

let rec parser_context_bind_symbol identifier25 context5 = 
    (match context5 with
         | (ParserContext (source_reference8, symbols17, module_scope3, global_scope3, symbol_table4, constructors6)) -> 
            (ParserContext (source_reference8, symbols17, module_scope3, global_scope3, (symbol_table_bind (identifier_name identifier25) symbol_table4), constructors6)));;

let rec parser_context_symbols context6 = 
    (match context6 with
         | (ParserContext (x320, symbols18, x321, x322, x323, x324)) -> 
            symbols18);;

let rec parser_context_with_symbols symbols19 context7 = 
    (match context7 with
         | (ParserContext (source_reference9, x325, module_scope4, global_scope4, symbol_table5, constructors7)) -> 
            (ParserContext (source_reference9, symbols19, module_scope4, global_scope4, symbol_table5, constructors7)));;

let rec parser_context_symbol_id context8 = 
    (match context8 with
         | (ParserContext (x326, x327, x328, x329, symbol_table6, x330)) -> 
            (symbol_table_id3 symbol_table6));;

let rec parser_context_source_reference context9 = 
    (match context9 with
         | (ParserContext (source_reference10, x331, x332, x333, x334, x335)) -> 
            source_reference10);;

let rec parser_context_with_source_reference source_reference11 context10 = 
    (match context10 with
         | (ParserContext (x336, symbols20, module_scope5, global_scope5, symbol_table7, constructors8)) -> 
            (ParserContext (source_reference11, symbols20, module_scope5, global_scope5, symbol_table7, constructors8)));;

let rec default_scope symbols21 = 
    (parser_scope_set_list (list_map (fun x51 -> ((fun x337 -> (Pair (x337, x337))) (pair_left x51))) symbols21) (parser_scope_empty ()));;

let rec max_symbol_id symbols22 = 
    (list_foldl (fun x338 xs28 -> (max xs28 (pair_left x338))) (0l) symbols22);;

let rec parser_run symbols23 parser2 = 
    (match (state_run (ParserContext ((SourceReference ((string_empty ()), ModuleSelf)), (Pair ((Int32.add (max_symbol_id symbols23) (1l)), (dictionary_of (list_map (fun x339 -> (Pair ((pair_right x339), x339))) symbols23)))), (default_scope symbols23), (default_scope symbols23), (symbol_table_bind_list (list_map pair_right symbols23) (symbol_table_empty ())), (array_empty ()))) parser2) with
         | (Pair (x340, result14)) -> 
            result14);;

let rec parser_return value23 = 
    (state_return (result_return value23));;

let rec parser_error error10 = 
    (state_return (result_error error10));;

let rec parser_bind parser3 f53 = 
    (state_bind parser3 (fun result15 -> (result_prod state_return (result_bind result15 (fun value24 -> (result_return (f53 value24)))))));;

let rec parser_token_is_constructor token5 = 
    (state_bind (state_get ()) (fun context11 -> (parser_return (parser_context_token_is_constructor token5 context11))));;

let rec parser_add_definition definition11 = 
    (state_bind (state_modify (parser_context_add_definition definition11)) (fun x341 -> (parser_return definition11)));;

let rec parser_get_symbols () = 
    (state_bind (state_get ()) (fun state9 -> (parser_return (parser_context_symbols state9))));;

let rec parser_set_symbols symbols24 = 
    (state_bind (state_modify (parser_context_with_symbols symbols24)) (fun x342 -> (parser_return symbols24)));;

let rec parser_get_module_scope () = 
    (state_bind (state_get ()) (fun state10 -> (parser_return (parser_context_module_scope state10))));;

let rec parser_new_module () = 
    (state_bind (state_modify parser_context_new_module) (fun state11 -> (parser_return state11)));;

let rec parser_bind_symbol identifier26 = 
    (state_bind (state_modify (parser_context_bind_symbol identifier26)) (fun state12 -> (parser_return (identifier_with_id (Some ((Int32.sub (parser_context_symbol_id state12) (1l)))) identifier26))));;

let rec parser_get_source_reference () = 
    (state_bind (state_get ()) (fun state13 -> (parser_return (parser_context_source_reference state13))));;

let rec parser_set_source_reference source_reference12 = 
    (state_bind (state_modify (parser_context_with_source_reference source_reference12)) (fun x343 -> (parser_return source_reference12)));;

let rec parser_sequence list29 = 
    (list_foldr (fun a69 b64 -> (parser_bind a69 (fun a70 -> (parser_bind b64 (fun b65 -> (parser_return (Cons (a70, b65)))))))) (parser_return Empty) list29);;

let rec parser_bind_symbols syms3 = 
    (parser_sequence (list_map parser_bind_symbol syms3));;

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
     | ErrorAlreadyDefined : string * source_reference * range -> error
     | ErrorReservedIdentifier : string * source_reference * range -> error
     | MalformedSexpTooFewClosingBrackets
     | MalformedSexpTooManyClosingBrackets;;

let rec malformed_function_definition source_reference13 range20 = 
    (MalformedFunctionDefinitionError (source_reference13, range20));;

let rec malformed_type_definition source_reference14 range21 = 
    (MalformedTypeDefinitionError (source_reference14, range21));;

let rec malformed_type source_reference15 range22 = 
    (MalformedTypeError (source_reference15, range22));;

let rec malformed_pattern source_reference16 range23 = 
    (MalformedPatternError (source_reference16, range23));;

let rec not_defined text2 source_reference17 range24 = 
    (match text2 with
         | (Some (text3)) -> 
            (ErrorNotDefined (text3, source_reference17, range24))
         | None -> 
            (InternalParserError (source_reference17, range24)));;

let rec data_def () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), Empty)))))));;

let rec data_typ () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), Empty)))))));;

let rec data_fn () = 
    (string_from_list (Cons ((102l), (Cons ((110l), Empty)))));;

let rec data_match () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_exists () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((115l), Empty)))))))))))));;

let rec data_pub () = 
    (string_from_list (Cons ((112l), (Cons ((117l), (Cons ((98l), Empty)))))));;

let rec identifier_def () = 
    (-1l);;

let rec identifier_typ () = 
    (-2l);;

let rec identifier_fn () = 
    (-3l);;

let rec identifier_match () = 
    (-4l);;

let rec identifier_exists () = 
    (-5l);;

let rec identifier_pub () = 
    (-6l);;

let rec identifier_to_symbol identifier27 = 
    (match identifier27 with
         | (Identifier (token6, name21, x344, range25, x345)) -> 
            (Symbol (token6, name21, range25)));;

let rec type_to_sexp types_to_sexp type2 = 
    (match type2 with
         | (SimpleType (identifier28)) -> 
            (identifier_to_symbol identifier28)
         | (FunctionType (arg_types, return_type, range26)) -> 
            (List ((Cons ((Symbol ((identifier_fn ()), (data_fn ()), range26)), (Cons ((List ((types_to_sexp arg_types), range26)), (Cons ((type_to_sexp types_to_sexp return_type), Empty)))))), range26))
         | (ComplexType (identifier29, types, range27)) -> 
            (List ((Cons ((identifier_to_symbol identifier29), (types_to_sexp types))), range27)));;

let rec types_to_sexp2 types2 = 
    (list_map (type_to_sexp types_to_sexp2) types2);;

let rec constructor_to_sexp constructor4 = 
    (match constructor4 with
         | (SimpleConstructor (identifier30)) -> 
            (identifier_to_symbol identifier30)
         | (ComplexConstructor (identifier31, types3, range28)) -> 
            (List ((Cons ((identifier_to_symbol identifier31), (types_to_sexp2 types3))), range28)));;

let rec constructors_to_sexp constructors9 = 
    (list_map constructor_to_sexp constructors9);;

let rec type_parameter_to_sexp parameter2 = 
    (match parameter2 with
         | (ExistentialParameter (identifier32)) -> 
            (List ((Cons ((Symbol ((identifier_exists ()), (data_exists ()), (identifier_range identifier32))), (Cons ((identifier_to_symbol identifier32), Empty)))), (identifier_range identifier32)))
         | (UniversalParameter (identifier33)) -> 
            (identifier_to_symbol identifier33));;

let rec type_name_to_sexp token7 range29 name22 parameters = 
    (match parameters with
         | Empty -> 
            (Symbol (token7, name22, range29))
         | x346 -> 
            (List ((Cons ((Symbol (token7, name22, range29)), (list_map type_parameter_to_sexp parameters))), range29)));;

let rec function_arguments_to_sexp arguments6 range30 = 
    (List ((list_map identifier_to_symbol arguments6), range30));;

let rec pattern_to_sexp pattern7 = 
    (match pattern7 with
         | (ConstructorPattern (identifier34, Empty, x347)) -> 
            (identifier_to_symbol identifier34)
         | (ConstructorPattern (identifier35, patterns2, range31)) -> 
            (List ((Cons ((identifier_to_symbol identifier35), (list_map pattern_to_sexp patterns2))), range31))
         | (IntegerPattern (value25, range32)) -> 
            (Integer (value25, range32))
         | (Capture (identifier36)) -> 
            (identifier_to_symbol identifier36));;

let rec match_pair_to_sexp expression_to_sexp2 pair11 = 
    (match pair11 with
         | (Pair (pattern8, expression30)) -> 
            (Cons ((pattern_to_sexp pattern8), (Cons ((expression_to_sexp2 expression30), Empty)))));;

let rec expression_to_sexp expression31 = 
    (match expression31 with
         | (IntegerConstant (integer6, range33)) -> 
            (Integer (integer6, range33))
         | (Variable ((Identifier (token8, string35, x348, range34, x349)))) -> 
            (Symbol (token8, string35, range34))
         | (Lambda (arguments7, expression32, range35)) -> 
            (List ((Cons ((Symbol ((identifier_fn ()), (data_fn ()), range35)), (Cons ((function_arguments_to_sexp arguments7 range35), (Cons ((expression_to_sexp expression32), Empty)))))), range35))
         | (Match (expression33, pairs5, range36)) -> 
            (List ((Cons ((Symbol ((identifier_match ()), (data_match ()), range36)), (Cons ((expression_to_sexp expression33), (list_flatmap (match_pair_to_sexp expression_to_sexp) pairs5))))), range36))
         | (Constructor (identifier37, expressions15, range37)) -> 
            (match expressions15 with
                 | Empty -> 
                    (identifier_to_symbol identifier37)
                 | x350 -> 
                    (List ((Cons ((identifier_to_symbol identifier37), (list_map expression_to_sexp expressions15))), range37)))
         | (FunctionApplication (expressions16, range38)) -> 
            (List ((list_map expression_to_sexp expressions16), range38)));;

let rec type_definition_to_sexp token9 name23 parameters2 constructors10 range39 = 
    (list_concat (Cons ((Symbol ((identifier_typ ()), (data_typ ()), range39)), (Cons ((type_name_to_sexp token9 range39 name23 parameters2), Empty)))) (constructors_to_sexp constructors10));;

let rec function_definition_to_sexp name24 arguments8 expression34 range40 = 
    (Cons ((Symbol ((identifier_def ()), (data_def ()), range40)), (Cons ((identifier_to_symbol name24), (Cons ((function_arguments_to_sexp arguments8 range40), (Cons ((expression_to_sexp expression34), Empty))))))));;

let rec definition_to_sexp2 public4 range41 sexp4 = 
    (List ((match public4 with
         | True -> 
            (Cons ((Symbol ((identifier_pub ()), (data_pub ()), range41)), sexp4))
         | False -> 
            sexp4), range41));;

let rec definition_to_sexp definition12 = 
    (match definition12 with
         | (TypeDefinition ((Identifier (token10, name25, x351, x352, x353)), public5, parameters3, constructors11, range42)) -> 
            (definition_to_sexp2 public5 range42 (type_definition_to_sexp token10 name25 parameters3 constructors11 range42))
         | (FunctionDefinition (name26, public6, arguments9, expression35, range43)) -> 
            (definition_to_sexp2 public6 range43 (function_definition_to_sexp name26 arguments9 expression35 range43))
         | (TargetDefinition (x354, data)) -> 
            (Symbol ((0l), (string_from_slice data), (Range ((0l), (0l))))));;

let rec definitions_to_sexps definitions2 = 
    (list_map definition_to_sexp definitions2);;

let rec with_language_identifiers other_symbols = 
    (list_concat other_symbols (Cons ((Pair ((identifier_def ()), (data_def ()))), (Cons ((Pair ((identifier_typ ()), (data_typ ()))), (Cons ((Pair ((identifier_fn ()), (data_fn ()))), (Cons ((Pair ((identifier_match ()), (data_match ()))), (Cons ((Pair ((identifier_exists ()), (data_exists ()))), (Cons ((Pair ((identifier_pub ()), (data_pub ()))), Empty)))))))))))));;

let rec symbol_to_identifier symbol2 = 
    (match symbol2 with
         | (Symbol (token11, name27, range44)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference18 -> (parser_return (Identifier (token11, name27, source_reference18, range44, None)))))
         | (Integer (x355, range45)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference19 -> (parser_error (MalformedSymbolError (source_reference19, range45)))))
         | (List (x356, range46)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference20 -> (parser_error (MalformedSymbolError (source_reference20, range46))))));;

let rec resolve_symbol symbol3 scope6 = 
    (parser_bind (symbol_to_identifier symbol3) (fun identifier38 -> (match (parser_scope_resolve identifier38 scope6) with
         | (Identifier (x357, name28, source_reference21, range47, None)) -> 
            (parser_error (ErrorNotDefined (name28, source_reference21, range47)))
         | identifier39 -> 
            (parser_return identifier39))));;

let rec sexp_to_complex_type sexp_to_type scope7 symbol4 parameters4 range48 = 
    (parser_bind (resolve_symbol symbol4 scope7) (fun identifier40 -> (parser_bind (parser_sequence (list_map (sexp_to_type scope7) parameters4)) (fun sub_types -> (parser_return (ComplexType (identifier40, sub_types, range48)))))));;

let rec sexp_to_function_type sexp_to_type2 parameters5 range49 = 
    (match parameters5 with
         | (Cons ((List (arg_types2, x358)), (Cons (return_type2, Empty)))) -> 
            (parser_bind (parser_sequence (list_map sexp_to_type2 arg_types2)) (fun arg_types3 -> (parser_bind (sexp_to_type2 return_type2) (fun return_type3 -> (parser_return (FunctionType (arg_types3, return_type3, range49)))))))
         | x359 -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference22 -> (parser_error (MalformedTypeError (source_reference22, range49))))));;

let rec sexp_to_type3 scope8 type3 = 
    (match type3 with
         | (List ((Cons (symbol5, parameters6)), range50)) -> 
            (parser_bind (symbol_to_identifier symbol5) (fun identifier41 -> (match (x4 (identifier_token identifier41) (identifier_fn ())) with
                 | True -> 
                    (sexp_to_function_type (sexp_to_type3 scope8) parameters6 range50)
                 | False -> 
                    (sexp_to_complex_type sexp_to_type3 scope8 symbol5 parameters6 range50))))
         | (Integer (x360, range51)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference23 -> (parser_error (MalformedTypeError (source_reference23, range51)))))
         | (List (x361, range52)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference24 -> (parser_error (MalformedTypeError (source_reference24, range52)))))
         | symbol6 -> 
            (parser_bind (resolve_symbol symbol6 scope8) (fun identifier42 -> (parser_return (SimpleType (identifier42))))));;

let rec sexp_to_constructor_definition scope9 constructor5 = 
    (match constructor5 with
         | (List ((Cons (name29, types4)), range53)) -> 
            (parser_bind (symbol_to_identifier name29) (fun name30 -> (parser_bind (parser_bind_symbol name30) (fun name31 -> (parser_bind (parser_sequence (list_map (sexp_to_type3 scope9) types4)) (fun types5 -> (parser_return (ComplexConstructor (name31, types5, range53)))))))))
         | (Integer (x362, range54)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference25 -> (parser_error (MalformedConstructorError (source_reference25, range54)))))
         | (List (x363, range55)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference26 -> (parser_error (MalformedConstructorError (source_reference26, range55)))))
         | symbol7 -> 
            (parser_bind (symbol_to_identifier symbol7) (fun name32 -> (parser_bind (parser_bind_symbol name32) (fun name33 -> (parser_return (SimpleConstructor (name33))))))));;

let rec sexp_to_type_parameter sexp5 = 
    (match sexp5 with
         | (List ((Cons (x364, (Cons (name34, Empty)))), x365)) -> 
            (parser_bind (symbol_to_identifier name34) (fun name35 -> (parser_bind (parser_bind_symbol name35) (fun name36 -> (parser_return (ExistentialParameter (name36)))))))
         | (Integer (x366, range56)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference27 -> (parser_error (MalformedDefinitionError (source_reference27, range56)))))
         | (List (x367, range57)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference28 -> (parser_error (MalformedDefinitionError (source_reference28, range57)))))
         | symbol8 -> 
            (parser_bind (symbol_to_identifier symbol8) (fun name37 -> (parser_bind (parser_bind_symbol name37) (fun name38 -> (parser_return (UniversalParameter (name38))))))));;

let rec sexp_to_lambda sexp_to_expression scope10 rest17 range58 = 
    (match rest17 with
         | (Cons ((List (arguments10, x368)), (Cons (expression36, Empty)))) -> 
            (parser_bind (parser_sequence (list_map symbol_to_identifier arguments10)) (fun arguments11 -> (parser_bind (parser_bind_symbols arguments11) (fun arguments12 -> (let_bind (parser_scope_new scope10) (fun scope11 -> (let_bind (parser_scope_set_all arguments12 scope11) (fun scope12 -> (parser_bind (sexp_to_expression scope12 expression36) (fun expression37 -> (parser_return (Lambda (arguments12, expression37, range58)))))))))))))
         | x369 -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference29 -> (parser_error (MalformedFunctionDefinitionError (source_reference29, range58))))));;

let rec sexp_to_function_application sexp_to_expression2 range59 expressions17 = 
    (parser_bind (parser_sequence (list_map sexp_to_expression2 expressions17)) (fun expressions18 -> (parser_return (FunctionApplication (expressions18, range59)))));;

let rec to_constructor_or_capture scope13 symbol9 = 
    (parser_bind (symbol_to_identifier symbol9) (fun identifier43 -> (parser_bind (parser_token_is_constructor (identifier_token identifier43)) (fun constructor6 -> (match constructor6 with
         | True -> 
            (parser_bind (resolve_symbol symbol9 scope13) (fun identifier44 -> (parser_return (ConstructorPattern (identifier44, Empty, (identifier_range identifier44))))))
         | False -> 
            (parser_bind (parser_bind_symbol identifier43) (fun identifier45 -> (parser_return (Capture (identifier45))))))))));;

let rec sexp_to_pattern scope14 sexp6 = 
    (match sexp6 with
         | (List ((Cons (name39, rest18)), range60)) -> 
            (parser_bind (parser_sequence (list_map (sexp_to_pattern scope14) rest18)) (fun patterns3 -> (parser_bind (resolve_symbol name39 scope14) (fun identifier46 -> (parser_return (ConstructorPattern (identifier46, patterns3, range60)))))))
         | (List (Empty, range61)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference30 -> (parser_error (MalformedPatternError (source_reference30, range61)))))
         | (Integer (integer7, range62)) -> 
            (parser_return (IntegerPattern (integer7, range62)))
         | symbol10 -> 
            (to_constructor_or_capture scope14 symbol10));;

let rec sexp_to_match_pair sexp_to_expression3 scope15 range63 pair12 = 
    (match pair12 with
         | (Cons (pattern9, (Cons (expression38, Empty)))) -> 
            (parser_bind (sexp_to_pattern scope15 pattern9) (fun pattern10 -> (let_bind (captured_identifiers_from_pattern pattern10) (fun captures -> (let_bind (parser_scope_new scope15) (fun scope16 -> (let_bind (parser_scope_set_all captures scope16) (fun scope17 -> (parser_bind (sexp_to_expression3 scope17 expression38) (fun expression39 -> (parser_return (Pair (pattern10, expression39)))))))))))))
         | x370 -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference31 -> (parser_error (MalformedMatchExpressionError (source_reference31, range63))))));;

let rec sexp_to_match_pairs sexp_to_expression4 scope18 range64 xs29 = 
    (match (list_partition (2l) xs29) with
         | Empty -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference32 -> (parser_error (MalformedMatchExpressionError (source_reference32, range64)))))
         | pairs6 -> 
            (parser_sequence (list_map (sexp_to_match_pair sexp_to_expression4 scope18 range64) pairs6)));;

let rec sexp_to_match sexp_to_expression5 scope19 range65 rest19 = 
    (match rest19 with
         | (Cons (expression40, rest20)) -> 
            (parser_bind (sexp_to_expression5 scope19 expression40) (fun expression41 -> (parser_bind (sexp_to_match_pairs sexp_to_expression5 scope19 range65 rest20) (fun pairs7 -> (parser_return (Match (expression41, pairs7, range65)))))))
         | x371 -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference33 -> (parser_error (InternalParserError (source_reference33, range65))))));;

let rec sexp_to_constructor sexp_to_expression6 range66 symbol11 rest21 scope20 = 
    (parser_bind (symbol_to_identifier symbol11) (fun identifier47 -> (parser_bind (resolve_symbol symbol11 scope20) (fun identifier48 -> (parser_bind (parser_sequence (list_map sexp_to_expression6 rest21)) (fun expressions19 -> (parser_return (Constructor (identifier48, expressions19, range66)))))))));;

let rec sexp_to_list_expression sexp_to_expression7 scope21 expressions20 range67 = 
    (match expressions20 with
         | (Cons ((Symbol (token12, name40, symbol_range)), rest22)) -> 
            (match (x4 token12 (identifier_fn ())) with
                 | True -> 
                    (sexp_to_lambda sexp_to_expression7 scope21 rest22 range67)
                 | False -> 
                    (match (x4 token12 (identifier_match ())) with
                         | True -> 
                            (sexp_to_match sexp_to_expression7 scope21 range67 rest22)
                         | False -> 
                            (parser_bind (parser_token_is_constructor token12) (fun constructor7 -> (match constructor7 with
                                 | True -> 
                                    (sexp_to_constructor (sexp_to_expression7 scope21) range67 (Symbol (token12, name40, symbol_range)) rest22 scope21)
                                 | False -> 
                                    (sexp_to_function_application (sexp_to_expression7 scope21) range67 expressions20))))))
         | x372 -> 
            (sexp_to_function_application (sexp_to_expression7 scope21) range67 expressions20));;

let rec sexp_to_expression8 scope22 sexp7 = 
    (match sexp7 with
         | (Integer (integer8, range68)) -> 
            (parser_return (IntegerConstant (integer8, range68)))
         | (List (expressions21, range69)) -> 
            (match expressions21 with
                 | Empty -> 
                    (parser_bind (parser_get_source_reference ()) (fun source_reference34 -> (parser_error (MalformedExpressionError (source_reference34, range69)))))
                 | x373 -> 
                    (sexp_to_list_expression sexp_to_expression8 scope22 expressions21 range69))
         | symbol12 -> 
            (parser_bind (resolve_symbol symbol12 scope22) (fun identifier49 -> (parser_bind (parser_token_is_constructor (identifier_token identifier49)) (fun constructor8 -> (parser_return (match constructor8 with
                 | True -> 
                    (Constructor (identifier49, Empty, (identifier_range identifier49)))
                 | False -> 
                    (Variable (identifier49)))))))));;

let rec sexp_to_type_definition scope23 type_name public7 rest23 range70 = 
    (match type_name with
         | (List ((Cons (name41, parameters7)), x374)) -> 
            (parser_bind (symbol_to_identifier name41) (fun name42 -> (parser_bind (parser_bind_symbol name42) (fun name43 -> (parser_bind (parser_sequence (list_map sexp_to_type_parameter parameters7)) (fun parameters8 -> (let_bind (list_map type_parameter_identifier parameters8) (fun parameter_identifiers -> (let_bind (parser_scope_new scope23) (fun scope24 -> (let_bind (parser_scope_set_all (Cons (name43, parameter_identifiers)) scope24) (fun scope25 -> (parser_bind (parser_sequence (list_map (sexp_to_constructor_definition scope25) rest23)) (fun constructors12 -> (parser_return (TypeDefinition (name43, public7, parameters8, constructors12, range70)))))))))))))))))
         | (Integer (x375, range71)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference35 -> (parser_error (MalformedTypeError (source_reference35, range71)))))
         | (List (x376, range72)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference36 -> (parser_error (MalformedTypeError (source_reference36, range72)))))
         | symbol13 -> 
            (parser_bind (symbol_to_identifier symbol13) (fun name44 -> (parser_bind (parser_bind_symbol name44) (fun name45 -> (let_bind (parser_scope_new scope23) (fun scope26 -> (let_bind (parser_scope_set2 name45 scope26) (fun scope27 -> (parser_bind (parser_sequence (list_map (sexp_to_constructor_definition scope27) rest23)) (fun constructors13 -> (parser_return (TypeDefinition (name45, public7, Empty, constructors13, range70))))))))))))));;

let rec sexp_to_function_definition scope28 name_symbol public8 rest24 range73 = 
    (match rest24 with
         | (Cons ((List (arguments13, x377)), (Cons (expression42, Empty)))) -> 
            (parser_bind (symbol_to_identifier name_symbol) (fun name46 -> (parser_bind (parser_bind_symbol name46) (fun name47 -> (parser_bind (parser_sequence (list_map symbol_to_identifier arguments13)) (fun arguments14 -> (parser_bind (parser_bind_symbols arguments14) (fun arguments15 -> (let_bind (parser_scope_new scope28) (fun scope29 -> (let_bind (parser_scope_set_all (Cons (name47, arguments15)) scope29) (fun scope30 -> (parser_bind (sexp_to_expression8 scope30 expression42) (fun expression43 -> (parser_return (FunctionDefinition (name47, public8, arguments15, expression43, range73)))))))))))))))))
         | x378 -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference37 -> (parser_error (MalformedFunctionDefinitionError (source_reference37, range73))))));;

let rec sexp_to_definition scope31 name48 public9 rest25 range74 kind = 
    (match (x4 kind (identifier_typ ())) with
         | True -> 
            (sexp_to_type_definition scope31 name48 public9 rest25 range74)
         | False -> 
            (match (x4 kind (identifier_def ())) with
                 | True -> 
                    (sexp_to_function_definition scope31 name48 public9 rest25 range74)
                 | False -> 
                    (parser_bind (parser_get_source_reference ()) (fun source_reference38 -> (parser_error (MalformedDefinitionError (source_reference38, range74)))))));;

let rec specific_malformed_definition_error kind2 range75 = 
    (match (x4 kind2 (identifier_typ ())) with
         | True -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference39 -> (parser_error (MalformedTypeDefinitionError (source_reference39, range75)))))
         | False -> 
            (match (x4 kind2 (identifier_def ())) with
                 | True -> 
                    (parser_bind (parser_get_source_reference ()) (fun source_reference40 -> (parser_error (MalformedFunctionDefinitionError (source_reference40, range75)))))
                 | False -> 
                    (parser_bind (parser_get_source_reference ()) (fun source_reference41 -> (parser_error (MalformedDefinitionError (source_reference41, range75)))))));;

let rec sexp_to_definition2 scope32 expression44 = 
    (match expression44 with
         | (List ((Cons ((Symbol (-1l, x379, x380)), Empty)), range76)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference42 -> (parser_error (FunctionDefinitionMissingName (source_reference42, range76)))))
         | (List ((Cons ((Symbol (-1l, x381, x382)), (Cons ((List (x383, x384)), Empty)))), range77)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference43 -> (parser_error (FunctionDefinitionMissingName (source_reference43, range77)))))
         | (List ((Cons ((Symbol (-2l, x385, x386)), Empty)), range78)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference44 -> (parser_error (TypeDefinitionMissingName (source_reference44, range78)))))
         | (List ((Cons ((Symbol (-6l, x387, x388)), (Cons ((Symbol (-1l, x389, x390)), Empty)))), range79)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference45 -> (parser_error (FunctionDefinitionMissingName (source_reference45, range79)))))
         | (List ((Cons ((Symbol (-6l, x391, x392)), (Cons ((Symbol (-1l, x393, x394)), (Cons ((List (x395, x396)), Empty)))))), range80)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference46 -> (parser_error (FunctionDefinitionMissingName (source_reference46, range80)))))
         | (List ((Cons ((Symbol (-6l, x397, x398)), (Cons ((Symbol (-2l, x399, x400)), Empty)))), range81)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference47 -> (parser_error (TypeDefinitionMissingName (source_reference47, range81)))))
         | (List ((Cons ((Symbol (-2l, x401, x402)), (Cons (x403, Empty)))), range82)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference48 -> (parser_error (TypeDefinitionMissingConstructors (source_reference48, range82)))))
         | (List ((Cons ((Symbol (kind3, x404, x405)), Empty)), range83)) -> 
            (specific_malformed_definition_error kind3 range83)
         | (List ((Cons ((Symbol (kind4, x406, x407)), (Cons (x408, Empty)))), range84)) -> 
            (specific_malformed_definition_error kind4 range84)
         | (List ((Cons ((Symbol (-6l, x409, x410)), (Cons ((Symbol (kind5, x411, x412)), (Cons (name49, rest26)))))), range85)) -> 
            (sexp_to_definition scope32 name49 True rest26 range85 kind5)
         | (List ((Cons ((Symbol (kind6, x413, x414)), (Cons (name50, rest27)))), range86)) -> 
            (sexp_to_definition scope32 name50 False rest27 range86 kind6)
         | (List ((Cons ((List (x415, range87)), Empty)), x416)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference49 -> (parser_error (MalformedDefinitionError (source_reference49, range87)))))
         | (List (x417, range88)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference50 -> (parser_error (MalformedDefinitionError (source_reference50, range88)))))
         | (Integer (x418, range89)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference51 -> (parser_error (MalformedDefinitionError (source_reference51, range89)))))
         | (Symbol (x419, x420, range90)) -> 
            (parser_bind (parser_get_source_reference ()) (fun source_reference52 -> (parser_error (MalformedDefinitionError (source_reference52, range90))))));;

let rec parse_definition expression45 = 
    (parser_bind (parser_get_module_scope ()) (fun scope33 -> (parser_bind (sexp_to_definition2 scope33 expression45) (fun definition13 -> (parser_add_definition definition13)))));;

let rec sexp_error_to_ast_error error11 = 
    (match error11 with
         | ParseErrorTooFewClosingBrackets -> 
            MalformedSexpTooFewClosingBrackets
         | ParseErrorTooManyClosingBrackets -> 
            MalformedSexpTooManyClosingBrackets);;

let rec parse_definitions module8 file_path2 iterator10 = 
    (parser_bind (parser_set_source_reference (SourceReference (file_path2, module8))) (fun x421 -> (parser_bind (parser_get_symbols ()) (fun symbols25 -> (match (parse_sexps symbols25 iterator10) with
         | (Result ((Pair (symbols26, expressions22)))) -> 
            (parser_bind (parser_set_symbols symbols26) (fun x422 -> (parser_sequence (list_map parse_definition expressions22))))
         | (Error (error12)) -> 
            (parser_error (sexp_error_to_ast_error error12)))))));;

let rec transform_strings path4 content3 = 
    (match (string_gen content3) with
         | (Result (string36)) -> 
            (string_to_slice string36)
         | (Error (error13)) -> 
            (slice_empty ()));;

let rec parse_reuse_file file8 = 
    (match file8 with
         | (SourceFile (module9, path5, content4)) -> 
            (parse_definitions module9 path5 content4));;

let rec parse_strings_file file9 = 
    (match file9 with
         | (SourceFile (module10, path6, content5)) -> 
            (parse_definitions module10 path6 (transform_strings path6 content5)));;

let rec parse_target_file file10 = 
    (match file10 with
         | (SourceFile (module11, path7, content6)) -> 
            (parser_return (Cons ((TargetDefinition ((SourceReference (path7, module11)), content6)), Empty))));;

let rec parse_source_file file11 = 
    (match (source_file_type2 file11) with
         | SourceFileTypeStrings -> 
            (parse_strings_file file11)
         | SourceFileTypeReuse -> 
            (parse_reuse_file file11)
         | SourceFileTypeTargetLanguage -> 
            (parse_target_file file11));;

let rec parse_module files = 
    (parser_bind (parser_new_module ()) (fun x423 -> (parser_bind (parser_sequence (list_map parse_source_file files)) (fun definitions3 -> (parser_return (list_flatten definitions3))))));;

let rec parse_source_files symbols27 files2 = 
    ((result_map list_flatten) ((parser_run (with_language_identifiers symbols27)) (parser_sequence ((list_map parse_module) ((list_partition_by source_file_in_same_module) files2)))));;

let rec data_double_dash () = 
    (string_from_list (Cons ((45l), (Cons ((45l), Empty)))));;

let rec data_single_dash () = 
    (string_from_list (Cons ((45l), Empty)));;

let rec data_true () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))));;

type cli_arguments  = 
     | CliArguments : ((string,string) pair) list * (string) list -> cli_arguments
     | CliErrorMissingValue : string -> cli_arguments;;

let rec is_key argument = 
    (string_equal (data_double_dash ()) (string_take (2l) argument));;

let rec is_flag argument2 = 
    (string_equal (data_single_dash ()) (string_take (1l) argument2));;

let rec parse_arguments2 arguments16 kv_args inputs = 
    (match arguments16 with
         | (Cons (first8, (Cons (second, rest28)))) -> 
            (match (is_key first8) with
                 | True -> 
                    (parse_arguments2 (list_rest (list_rest arguments16)) (Cons ((Pair ((string_skip (2l) first8), second)), kv_args)) inputs)
                 | False -> 
                    (match (is_flag first8) with
                         | True -> 
                            (parse_arguments2 (list_rest arguments16) (Cons ((Pair ((string_skip (1l) first8), (data_true ()))), kv_args)) inputs)
                         | False -> 
                            (parse_arguments2 (list_rest arguments16) kv_args (Cons (first8, inputs)))))
         | (Cons (first9, Empty)) -> 
            (match (is_key first9) with
                 | True -> 
                    (CliErrorMissingValue (first9))
                 | False -> 
                    (match (is_flag first9) with
                         | True -> 
                            (CliArguments ((list_reverse (Cons ((Pair ((string_skip (1l) first9), (data_true ()))), kv_args))), (list_reverse inputs)))
                         | False -> 
                            (CliArguments ((list_reverse kv_args), (list_reverse (Cons (first9, inputs)))))))
         | Empty -> 
            (CliArguments ((list_reverse kv_args), (list_reverse inputs))));;

let rec parse_arguments arguments17 = 
    (parse_arguments2 arguments17 Empty Empty);;

let rec data_parseerrortoofewclosingbrackets () = 
    (string_from_list (Cons ((84l), (Cons ((111l), (Cons ((111l), (Cons ((32l), (Cons ((102l), (Cons ((101l), (Cons ((119l), (Cons ((32l), (Cons ((99l), (Cons ((108l), (Cons ((111l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((98l), (Cons ((114l), (Cons ((97l), (Cons ((99l), (Cons ((107l), (Cons ((101l), (Cons ((116l), (Cons ((115l), Empty)))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_parseerrortoomanyclosingbrackets () = 
    (string_from_list (Cons ((84l), (Cons ((111l), (Cons ((111l), (Cons ((32l), (Cons ((109l), (Cons ((97l), (Cons ((110l), (Cons ((121l), (Cons ((32l), (Cons ((99l), (Cons ((108l), (Cons ((111l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((98l), (Cons ((114l), (Cons ((97l), (Cons ((99l), (Cons ((107l), (Cons ((101l), (Cons ((116l), (Cons ((115l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_success () = 
    (string_from_list (Cons ((115l), (Cons ((117l), (Cons ((99l), (Cons ((99l), (Cons ((101l), (Cons ((115l), (Cons ((115l), Empty)))))))))))))));;

let rec data_fn2 () = 
    (string_from_list (Cons ((102l), (Cons ((110l), Empty)))));;

let rec data_pub2 () = 
    (string_from_list (Cons ((112l), (Cons ((117l), (Cons ((98l), Empty)))))));;

let rec data_def2 () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), Empty)))))));;

let rec data_typ2 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), Empty)))))));;

let rec data_exists2 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((115l), Empty)))))))))))));;

let rec data_match2 () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_list () = 
    (string_from_list (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), Empty)))))))));;

let rec data_pipe () = 
    (string_from_list (Cons ((112l), (Cons ((105l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_open_bracket () = 
    (string_from_list (Cons ((40l), Empty)));;

let rec data_close_bracket () = 
    (string_from_list (Cons ((41l), Empty)));;

let rec data_bind () = 
    (string_from_list (Cons ((98l), (Cons ((105l), (Cons ((110l), (Cons ((100l), Empty)))))))));;

let rec stringify_error error14 = 
    (match error14 with
         | ParseErrorTooFewClosingBrackets -> 
            (data_parseerrortoofewclosingbrackets ())
         | ParseErrorTooManyClosingBrackets -> 
            (data_parseerrortoomanyclosingbrackets ()));;

let rec language_identifiers () = 
    (Cons ((Pair ((string_empty ()), (Pair ((-100l), (string_empty ()))))), (Cons ((Pair ((data_def2 ()), (Pair ((-1l), (data_def2 ()))))), (Cons ((Pair ((data_typ2 ()), (Pair ((-2l), (data_typ2 ()))))), (Cons ((Pair ((data_fn2 ()), (Pair ((-3l), (data_fn2 ()))))), (Cons ((Pair ((data_match2 ()), (Pair ((-4l), (data_match2 ()))))), (Cons ((Pair ((data_exists2 ()), (Pair ((-5l), (data_exists2 ()))))), (Cons ((Pair ((data_pub2 ()), (Pair ((-6l), (data_pub2 ()))))), (Cons ((Pair ((data_list ()), (Pair ((-7l), (data_list ()))))), (Cons ((Pair ((data_pipe ()), (Pair ((-8l), (data_pipe ()))))), Empty))))))))))))))))));;

let rec space () = 
    (string_of_char (32l));;

let rec newline2 () = 
    (string_of_char (10l));;

let rec indent2 n8 = 
    (string_concat (newline2 ()) (string_repeat (space ()) n8));;

let rec list_with_space items = 
    (wrap_in_brackets (string_join (space ()) items));;

let rec list_without_space items2 = 
    (wrap_in_brackets (string_join (string_empty ()) items2));;

let rec add_modifiers public10 rest29 = 
    (match public10 with
         | True -> 
            (Cons ((data_pub2 ()), (Cons ((space ()), rest29))))
         | False -> 
            rest29);;

let rec format_pattern pattern11 = 
    (match pattern11 with
         | (List (patterns4, x424)) -> 
            (list_with_space (list_map format_pattern patterns4))
         | x425 -> 
            (stringify_sexp x425));;

let rec format_match_rule format_expression depth3 rule2 = 
    (match rule2 with
         | (Pair (pattern12, expression46)) -> 
            (string_join (string_empty ()) (Cons ((format_pattern pattern12), (Cons ((indent2 (Int32.add depth3 (4l))), (Cons ((format_expression (Int32.add depth3 (4l)) expression46), Empty))))))));;

let rec format_match_rules format_expression2 depth4 rules5 = 
    (string_join (indent2 depth4) (list_map (format_match_rule format_expression2 depth4) rules5));;

let rec rule_pairs rules6 = 
    (match (Int32.rem (list_size rules6) (2l)) with
         | 0l -> 
            (list_pairs rules6)
         | x426 -> 
            (list_pairs (list_reverse (Cons ((Symbol ((-100l), (string_empty ()), (Range ((0l), (0l))))), (list_reverse rules6))))));;

let rec monadic_function_call expressions23 = 
    (match (Pair ((list_first expressions23), (list_last expressions23))) with
         | (Pair ((Some ((Symbol (x427, name51, x428)))), (Some ((List ((Cons ((Symbol (-3l, x429, x430)), x431)), x432)))))) -> 
            (match (list_last (string_split (45l) name51)) with
                 | (Some (last_part)) -> 
                    (string_equal last_part (data_bind ()))
                 | None -> 
                    False)
         | x433 -> 
            False);;

let rec format_long_list_expression format_expression3 stringified depth5 expressions24 = 
    (match (x6 (string_size stringified) (78l)) with
         | True -> 
            (string_join (indent2 (Int32.add depth5 (4l))) (list_map (format_expression3 (Int32.add depth5 (4l))) expressions24))
         | False -> 
            stringified);;

let rec format_list_expression format_expression4 depth6 expressions25 = 
    (match (monadic_function_call expressions25) with
         | True -> 
            (string_join (space ()) (list_flatten (Cons ((list_map stringify_sexp (list_reverse (list_skip (1l) (list_reverse expressions25)))), (Cons ((Cons ((maybe_or_else (string_empty ()) (maybe_map (format_expression4 (Int32.sub depth6 (4l))) (list_last expressions25))), Empty)), Empty))))))
         | False -> 
            (match (string_join (space ()) (list_map (format_expression4 depth6) expressions25)) with
                 | stringified2 -> 
                    (match (x5 (list_size expressions25) (2l)) with
                         | False -> 
                            (format_long_list_expression format_expression4 stringified2 depth6 expressions25)
                         | True -> 
                            stringified2)));;

let rec format_expression5 depth7 expression47 = 
    (match expression47 with
         | (List ((Cons ((Symbol (-3l, x434, x435)), (Cons (arguments18, (Cons (expression48, Empty)))))), x436)) -> 
            (list_without_space (Cons ((data_fn2 ()), (Cons ((space ()), (Cons ((stringify_sexp arguments18), (Cons ((indent2 (Int32.add depth7 (4l))), (Cons ((format_expression5 (Int32.add depth7 (4l)) expression48), Empty)))))))))))
         | (List ((Cons ((Symbol (-4l, x437, x438)), (Cons (expression49, rules7)))), range91)) -> 
            (list_without_space (Cons ((data_match2 ()), (Cons ((space ()), (Cons ((format_expression5 depth7 expression49), (Cons ((indent2 (Int32.add depth7 (7l))), (Cons ((format_match_rules format_expression5 (Int32.add depth7 (7l)) (rule_pairs rules7)), Empty)))))))))))
         | (List (expressions26, range92)) -> 
            (wrap_in_brackets (format_list_expression format_expression5 depth7 expressions26))
         | x439 -> 
            (stringify_sexp x439));;

let rec format_type type4 = 
    (match type4 with
         | (List ((Cons ((Symbol (-3l, x440, x441)), (Cons ((List (argument_types, x442)), (Cons (return_type4, Empty)))))), x443)) -> 
            (list_with_space (Cons ((data_fn2 ()), (Cons ((list_with_space (list_map format_type argument_types)), (Cons ((format_type return_type4), Empty)))))))
         | (List ((Cons (identifier50, parameters9)), x444)) -> 
            (list_with_space (Cons ((stringify_sexp identifier50), (list_map format_type parameters9))))
         | x445 -> 
            (stringify_sexp x445));;

let rec format_type_constructor constructor9 = 
    (match constructor9 with
         | (List ((Cons (identifier51, types6)), x446)) -> 
            (list_with_space (Cons ((stringify_sexp identifier51), (list_map format_type types6))))
         | x447 -> 
            (stringify_sexp x447));;

let rec format_type_constructor_split constructor10 = 
    (match constructor10 with
         | (List ((Cons (identifier52, (Cons (first10, rest30)))), x448)) -> 
            (wrap_in_brackets (string_join (space ()) (Cons ((stringify_sexp identifier52), (Cons ((string_join (indent2 (Int32.add (string_size (stringify_sexp identifier52)) (7l))) (Cons ((format_type first10), (list_map format_type rest30)))), Empty))))))
         | x449 -> 
            (stringify_sexp x449));;

let rec format_type_parameter parameter3 = 
    (match parameter3 with
         | (List ((Cons ((Symbol (-5l, x450, x451)), (Cons (identifier53, Empty)))), x452)) -> 
            (list_with_space (Cons ((data_exists2 ()), (Cons ((stringify_sexp identifier53), Empty)))))
         | x453 -> 
            (stringify_sexp parameter3));;

let rec format_type_definition_name name52 parameters10 = 
    (match parameters10 with
         | Empty -> 
            (stringify_sexp name52)
         | x454 -> 
            (list_with_space (Cons ((stringify_sexp name52), (list_map format_type_parameter parameters10)))));;

let rec format_type_definition_constructors constructors14 = 
    (match constructors14 with
         | (Cons (constructor11, Empty)) -> 
            (match (x6 (string_size (stringify_sexps constructors14)) (80l)) with
                 | True -> 
                    (string_concat (indent2 (5l)) (format_type_constructor_split constructor11))
                 | False -> 
                    (string_concat (space ()) (format_type_constructor constructor11)))
         | x455 -> 
            (string_concat (indent2 (5l)) (string_join (indent2 (5l)) (list_map format_type_constructor constructors14))));;

let rec format_type_definition public11 name53 parameters11 constructors15 = 
    (list_without_space (add_modifiers public11 (Cons ((data_typ2 ()), (Cons ((space ()), (Cons ((format_type_definition_name name53 parameters11), (Cons ((format_type_definition_constructors constructors15), Empty))))))))));;

let rec format_function_definition public12 name54 arguments19 expression50 = 
    (list_without_space (add_modifiers public12 (list_flatten (Cons ((Cons ((data_def2 ()), (Cons ((space ()), (Cons ((stringify_sexp name54), (Cons ((space ()), (Cons ((wrap_in_brackets (string_join (space ()) (list_map stringify_sexp arguments19))), Empty)))))))))), (Cons ((match expression50 with
         | (Integer (x456, x457)) -> 
            (Cons ((space ()), Empty))
         | x458 -> 
            (Cons ((indent2 (5l)), Empty))), (Cons ((Cons ((format_expression5 (5l) expression50), Empty)), Empty)))))))));;

let rec format_definition definition14 = 
    (match definition14 with
         | (List ((Cons ((Symbol (-6l, x459, x460)), (Cons ((Symbol (-2l, x461, x462)), (Cons ((List ((Cons (name55, parameters12)), x463)), constructors16)))))), range93)) -> 
            (format_type_definition True name55 parameters12 constructors16)
         | (List ((Cons ((Symbol (-6l, x464, x465)), (Cons ((Symbol (-2l, x466, x467)), (Cons (name56, constructors17)))))), range94)) -> 
            (format_type_definition True name56 Empty constructors17)
         | (List ((Cons ((Symbol (-2l, x468, x469)), (Cons ((List ((Cons (name57, parameters13)), x470)), constructors18)))), range95)) -> 
            (format_type_definition False name57 parameters13 constructors18)
         | (List ((Cons ((Symbol (-2l, x471, x472)), (Cons (name58, constructors19)))), range96)) -> 
            (format_type_definition False name58 Empty constructors19)
         | (List ((Cons ((Symbol (-6l, x473, x474)), (Cons ((Symbol (-1l, x475, x476)), (Cons (name59, (Cons ((List (arguments20, x477)), (Cons (expression51, Empty)))))))))), range97)) -> 
            (format_function_definition True name59 arguments20 expression51)
         | (List ((Cons ((Symbol (-1l, x478, x479)), (Cons (name60, (Cons ((List (arguments21, x480)), (Cons (expression52, Empty)))))))), range98)) -> 
            (format_function_definition False name60 arguments21 expression52)
         | x481 -> 
            (stringify_sexp definition14));;

let rec format_file definitions4 = 
    (match (list_is_empty definitions4) with
         | True -> 
            (string_empty ())
         | False -> 
            ((string_concat (newline2 ())) (((flip string_concat) (newline2 ())) ((string_join (string_repeat (newline2 ()) (2l))) ((list_map format_definition) definitions4)))));;

let rec format_source_file file12 = 
    ((result_bimap (fun x51 -> (string_to_slice (format_file (pair_right x51)))) stringify_error) ((parse_sexps (Pair ((0l), (dictionary_of (language_identifiers ()))))) (source_file_content file12)));;

let rec result_from_pair pair13 = 
    (result_map (pair_cons (pair_left pair13)) (pair_right pair13));;

let rec format_source_files files3 = 
    (result_concat (list_map (fun x51 -> (result_from_pair ((pair_bimap source_file_path format_source_file) (pair_dup x51)))) files3));;

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

let rec source_string_concat a71 b66 = 
    (SourceStringConcat (a71, b66));;

let rec source_string_join separator4 strings2 = 
    (match strings2 with
         | (Cons (first11, rest31)) -> 
            (list_foldl (fun string38 joined2 -> (source_string_concat joined2 (source_string_concat (SourceString (separator4)) string38))) first11 rest31)
         | Empty -> 
            (source_string_empty ()));;

let rec data_space () = 
    (string_from_list (Cons ((32l), Empty)));;

let rec data_fun () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), Empty)))))));;

let rec data_type () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_if () = 
    (string_from_list (Cons ((105l), (Cons ((102l), Empty)))));;

let rec data_then () = 
    (string_from_list (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_else () = 
    (string_from_list (Cons ((101l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))));;

let rec data_with () = 
    (string_from_list (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((104l), Empty)))))))));;

let rec data_of () = 
    (string_from_list (Cons ((111l), (Cons ((102l), Empty)))));;

let rec data_class () = 
    (string_from_list (Cons ((99l), (Cons ((108l), (Cons ((97l), (Cons ((115l), (Cons ((115l), Empty)))))))))));;

let rec data_end () = 
    (string_from_list (Cons ((101l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_in () = 
    (string_from_list (Cons ((105l), (Cons ((110l), Empty)))));;

let rec data_let () = 
    (string_from_list (Cons ((108l), (Cons ((101l), (Cons ((116l), Empty)))))));;

let rec data_open () = 
    (string_from_list (Cons ((111l), (Cons ((112l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_and () = 
    (string_from_list (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_or () = 
    (string_from_list (Cons ((111l), (Cons ((114l), Empty)))));;

let rec data_as () = 
    (string_from_list (Cons ((97l), (Cons ((115l), Empty)))));;

let rec data_less_than () = 
    (string_from_list (Cons ((60l), Empty)));;

let rec data_assert () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((115l), (Cons ((101l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_asr () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_begin () = 
    (string_from_list (Cons ((98l), (Cons ((101l), (Cons ((103l), (Cons ((105l), (Cons ((110l), Empty)))))))))));;

let rec data_constraint () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((97l), (Cons ((105l), (Cons ((110l), (Cons ((116l), Empty)))))))))))))))))))));;

let rec data_do () = 
    (string_from_list (Cons ((100l), (Cons ((111l), Empty)))));;

let rec data_done () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((110l), (Cons ((101l), Empty)))))))));;

let rec data_downto () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((119l), (Cons ((110l), (Cons ((116l), (Cons ((111l), Empty)))))))))))));;

let rec data_exception () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((99l), (Cons ((101l), (Cons ((112l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))))));;

let rec data_external () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((116l), (Cons ((101l), (Cons ((114l), (Cons ((110l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))))));;

let rec data_false () = 
    (string_from_list (Cons ((102l), (Cons ((97l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))))));;

let rec data_true2 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))));;

let rec data_for () = 
    (string_from_list (Cons ((102l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_function () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))));;

let rec data_functor () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), Empty)))))))))))))));;

let rec data_include () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((99l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), Empty)))))))))))))));;

let rec data_inherit () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((105l), (Cons ((116l), Empty)))))))))))))));;

let rec data_initializer () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((97l), (Cons ((108l), (Cons ((105l), (Cons ((122l), (Cons ((101l), (Cons ((114l), Empty)))))))))))))))))))))));;

let rec data_land () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))));;

let rec data_lazy () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((122l), (Cons ((121l), Empty)))))))));;

let rec data_lor () = 
    (string_from_list (Cons ((108l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_lsl () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((108l), Empty)))))));;

let rec data_lsr () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_lxor () = 
    (string_from_list (Cons ((108l), (Cons ((120l), (Cons ((111l), (Cons ((114l), Empty)))))))));;

let rec data_method () = 
    (string_from_list (Cons ((109l), (Cons ((101l), (Cons ((116l), (Cons ((104l), (Cons ((111l), (Cons ((100l), Empty)))))))))))));;

let rec data_mod () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), Empty)))))));;

let rec data_module () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), Empty)))))))))))));;

let rec data_mutable () = 
    (string_from_list (Cons ((109l), (Cons ((117l), (Cons ((116l), (Cons ((97l), (Cons ((98l), (Cons ((108l), (Cons ((101l), Empty)))))))))))))));;

let rec data_new () = 
    (string_from_list (Cons ((110l), (Cons ((101l), (Cons ((119l), Empty)))))));;

let rec data_nonrec () = 
    (string_from_list (Cons ((110l), (Cons ((111l), (Cons ((110l), (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))))))))));;

let rec data_object () = 
    (string_from_list (Cons ((111l), (Cons ((98l), (Cons ((106l), (Cons ((101l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_private () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((105l), (Cons ((118l), (Cons ((97l), (Cons ((116l), (Cons ((101l), Empty)))))))))))))));;

let rec data_rec () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))));;

let rec data_sig () = 
    (string_from_list (Cons ((115l), (Cons ((105l), (Cons ((103l), Empty)))))));;

let rec data_struct () = 
    (string_from_list (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_try () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((121l), Empty)))))));;

let rec data_val () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), Empty)))))));;

let rec data_virtual () = 
    (string_from_list (Cons ((118l), (Cons ((105l), (Cons ((114l), (Cons ((116l), (Cons ((117l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))));;

let rec data_when () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_while () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((105l), (Cons ((108l), (Cons ((101l), Empty)))))))))));;

let rec data_parser () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((101l), (Cons ((114l), Empty)))))))))))));;

let rec data_value () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), (Cons ((117l), (Cons ((101l), Empty)))))))))));;

let rec data_to () = 
    (string_from_list (Cons ((116l), (Cons ((111l), Empty)))));;

let rec data_def3 () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), Empty)))))));;

let rec data_typ3 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), Empty)))))));;

let rec data_fn3 () = 
    (string_from_list (Cons ((102l), (Cons ((110l), Empty)))));;

let rec data_match3 () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_exists3 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((115l), Empty)))))))))))));;

let rec data_pub3 () = 
    (string_from_list (Cons ((112l), (Cons ((117l), (Cons ((98l), Empty)))))));;

let rec data_2 () = 
    (string_from_list (Cons ((43l), Empty)));;

let rec data__ () = 
    (string_from_list (Cons ((45l), Empty)));;

let rec data_3 () = 
    (string_from_list (Cons ((42l), Empty)));;

let rec data_4 () = 
    (string_from_list (Cons ((47l), Empty)));;

let rec data_5 () = 
    (string_from_list (Cons ((37l), Empty)));;

let rec data_6 () = 
    (string_from_list (Cons ((38l), Empty)));;

let rec data_int32_less_than () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((45l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((45l), (Cons ((116l), (Cons ((104l), (Cons ((97l), (Cons ((110l), Empty)))))))))))))))))))))))))))))));;

let rec data_pipe2 () = 
    (string_from_list (Cons ((112l), (Cons ((105l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_dot () = 
    (string_from_list (Cons ((46l), Empty)));;

let rec data_list2 () = 
    (string_from_list (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), Empty)))))))));;

let rec data_slice_empty () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((101l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), Empty)))))))))))))))))))))));;

let rec data_slice_of_u8 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((111l), (Cons ((102l), (Cons ((45l), (Cons ((117l), (Cons ((56l), Empty)))))))))))))))))))))));;

let rec data_slice_size () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((105l), (Cons ((122l), (Cons ((101l), Empty)))))))))))))))))))));;

let rec data_slice_get () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((103l), (Cons ((101l), (Cons ((116l), Empty)))))))))))))))))));;

let rec data_slice_concat () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((99l), (Cons ((97l), (Cons ((116l), Empty)))))))))))))))))))))))));;

let rec data_slice_foldl () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((102l), (Cons ((111l), (Cons ((108l), (Cons ((100l), (Cons ((108l), Empty)))))))))))))))))))))));;

let rec data_slice_subslice () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((117l), (Cons ((98l), (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))))))))))))))))))))));;

let rec data_slice () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))));;

let rec data_int32 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), Empty)))))))))));;

let rec identifier_ () = 
    (0l);;

let rec identifier__ () = 
    (1l);;

let rec identifier_2 () = 
    (2l);;

let rec identifier_3 () = 
    (3l);;

let rec identifier_4 () = 
    (4l);;

let rec identifier_5 () = 
    (5l);;

let rec identifier_int32_less_than () = 
    (6l);;

let rec identifier_list () = 
    (7l);;

let rec identifier_pipe () = 
    (8l);;

let rec identifier_dot () = 
    (9l);;

let rec identifier_slice_empty () = 
    (10l);;

let rec identifier_slice_of_u8 () = 
    (11l);;

let rec identifier_slice_size () = 
    (12l);;

let rec identifier_slice_get () = 
    (13l);;

let rec identifier_slice_concat () = 
    (14l);;

let rec identifier_slice_foldl () = 
    (15l);;

let rec identifier_slice_subslice () = 
    (16l);;

let rec identifier_int32 () = 
    (17l);;

let rec identifier_slice () = 
    (18l);;

let rec intrinsic_identifiers () = 
    (Cons ((Pair ((identifier_ ()), (data_2 ()))), (Cons ((Pair ((identifier__ ()), (data__ ()))), (Cons ((Pair ((identifier_2 ()), (data_3 ()))), (Cons ((Pair ((identifier_3 ()), (data_4 ()))), (Cons ((Pair ((identifier_4 ()), (data_5 ()))), (Cons ((Pair ((identifier_5 ()), (data_6 ()))), (Cons ((Pair ((identifier_int32_less_than ()), (data_int32_less_than ()))), (Cons ((Pair ((identifier_list ()), (data_list2 ()))), (Cons ((Pair ((identifier_pipe ()), (data_pipe2 ()))), (Cons ((Pair ((identifier_dot ()), (data_dot ()))), (Cons ((Pair ((identifier_slice_empty ()), (data_slice_empty ()))), (Cons ((Pair ((identifier_slice_foldl ()), (data_slice_foldl ()))), (Cons ((Pair ((identifier_slice_of_u8 ()), (data_slice_of_u8 ()))), (Cons ((Pair ((identifier_slice_size ()), (data_slice_size ()))), (Cons ((Pair ((identifier_slice_get ()), (data_slice_get ()))), (Cons ((Pair ((identifier_slice_concat ()), (data_slice_concat ()))), (Cons ((Pair ((identifier_slice_subslice ()), (data_slice_subslice ()))), (Cons ((Pair ((identifier_int32 ()), (data_int32 ()))), (Cons ((Pair ((identifier_slice ()), (data_slice ()))), Empty))))))))))))))))))))))))))))))))))))));;

let rec token_is_operator token13 = 
    (and2 (x6 token13 (0l)) (x5 token13 (5l)));;

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

let rec data_sparkle_x () = 
    (string_from_list (Cons ((226l), (Cons ((156l), (Cons ((168l), (Cons ((120l), Empty)))))))));;

let rec data_empty () = 
    (string_from_list (Cons ((69l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), Empty)))))))))));;

let rec data_cons () = 
    (string_from_list (Cons ((67l), (Cons ((111l), (Cons ((110l), (Cons ((115l), Empty)))))))));;

let rec identifier_sparkle_x () = 
    (1000l);;

let rec identifier_cons () = 
    (1001l);;

let rec identifier_empty () = 
    (1002l);;

let rec with_local_transform_keywords identifiers = 
    (list_concat identifiers (Cons ((Pair ((identifier_sparkle_x ()), (data_sparkle_x ()))), (Cons ((Pair ((identifier_cons ()), (data_cons ()))), (Cons ((Pair ((identifier_empty ()), (data_empty ()))), Empty)))))));;

let rec expression_is_token token14 expression53 = 
    (match expression53 with
         | (Variable ((Identifier (expression_token, x482, x483, x484, x485)))) -> 
            (x4 expression_token token14)
         | x486 -> 
            False);;

let rec first_expression_is_token token15 expressions27 = 
    ((maybe_else (fun () -> False)) ((maybe_map (expression_is_token token15)) (list_first expressions27)));;

let rec transform_special_form token16 transformer definition15 = 
    (over_definition_expressions (over_subexpressions (over_function_application (fun expressions28 range99 -> (result_return (match (first_expression_is_token token16 expressions28) with
         | True -> 
            (transformer (definition_source_reference definition15) (list_rest expressions28) range99)
         | False -> 
            (FunctionApplication (expressions28, range99))))))) definition15);;

let rec transform_special_forms token17 transformer2 definitions5 = 
    (result_concat (list_map (transform_special_form token17 transformer2) definitions5));;

let rec generated_x_variable source_reference53 range100 = 
    (Identifier ((identifier_sparkle_x ()), (data_sparkle_x ()), source_reference53, range100, (Some ((-1l)))));;

let rec transform_pipe source_reference54 expressions29 range101 = 
    (match expressions29 with
         | (Cons (value26, expressions30)) -> 
            (list_foldl (fun expression54 composed -> (FunctionApplication ((Cons (expression54, (Cons (composed, Empty)))), range101))) value26 expressions30)
         | Empty -> 
            (Lambda ((Cons ((generated_x_variable source_reference54 range101), Empty)), (Variable ((generated_x_variable source_reference54 range101))), range101)));;

let rec transform_dot source_reference55 expressions31 range102 = 
    (Lambda ((Cons ((generated_x_variable source_reference55 range102), Empty)), (list_foldr (fun expression55 composed2 -> (FunctionApplication ((Cons (expression55, (Cons (composed2, Empty)))), range102))) (Variable ((generated_x_variable source_reference55 range102))) expressions31), range102));;

let rec transform_list cons empty source_reference56 expressions32 range103 = 
    (list_foldr (fun expression56 composed3 -> (Constructor (cons, (Cons (expression56, (Cons (composed3, Empty)))), range103))) (Constructor (empty, Empty, range103)) expressions32);;

let rec transform_match_expression expression57 pairs8 range104 = 
    (result_return (Match (expression57, pairs8, range104)));;

let rec transform_match_expressions definition16 = 
    (over_definition_expressions (over_subexpressions (over_match_expression (fun expression58 pairs9 range105 -> (transform_match_expression expression58 pairs9 range105)))) definition16);;

let rec find_constructor token18 definitions6 = 
    (list_find_first (fun identifier54 -> (x4 token18 (identifier_token identifier54))) (list_flatmap identifiers_from_definition definitions6));;

let rec transform_list_special_form definitions7 = 
    (match (find_constructor (identifier_cons ()) definitions7) with
         | None -> 
            (result_return definitions7)
         | (Some (cons2)) -> 
            (match (find_constructor (identifier_empty ()) definitions7) with
                 | None -> 
                    (result_return definitions7)
                 | (Some (empty2)) -> 
                    (transform_special_forms (identifier_list ()) (transform_list cons2 empty2) definitions7)));;

let rec local_transforms definitions8 = 
    (result_bind definitions8 (fun definitions9 -> (result_bind (transform_special_forms (identifier_pipe ()) transform_pipe definitions9) (fun definitions10 -> (result_bind (transform_special_forms (identifier_dot ()) transform_dot definitions10) (fun definitions11 -> (result_bind (transform_list_special_form definitions11) (fun definitions12 -> (result_bind (result_concat (list_map transform_match_expressions definitions12)) (fun definitions13 -> (result_return definitions13)))))))))));;

let rec data_sparkle () = 
    (string_from_list (Cons ((226l), (Cons ((156l), (Cons ((168l), Empty)))))));;

let rec data_7 () = 
    (string_from_list Empty);;

let rec identifier_is_reserved identifier55 = 
    (string_equal (string_substring (0l) (3l) (identifier_name identifier55)) (data_sparkle ()));;

let rec invalid_identifier_error identifier56 = 
    (ErrorReservedIdentifier ((identifier_name identifier56), (identifier_source_reference identifier56), (identifier_range identifier56)));;

let rec validate_identifier identifier57 = 
    (match (identifier_is_reserved identifier57) with
         | True -> 
            (result_error (invalid_identifier_error identifier57))
         | False -> 
            (result_lift identifier57));;

let rec validate_identifiers_in_definition definition17 = 
    (over_definition_expressions (over_identifiers validate_identifier) definition17);;

let rec validate_reserved_identifiers definitions14 = 
    (result_flatmap (fun x51 -> (result_concat ((list_map validate_identifiers_in_definition) x51))) definitions14);;

type ('Tcompilation_result,'Ttransform_error) compiler_backend  = 
     | Backend : string * (string) list * (string) list * (string -> (definition) list -> 'Tcompilation_result) * (( unit  -> string)) list * (((definition) list,'Ttransform_error) result -> ((definition) list,'Ttransform_error) result) -> ('Tcompilation_result,'Ttransform_error) compiler_backend;;

let rec compiler_backend_name backend = 
    (match backend with
         | (Backend (name61, x487, x488, x489, x490, x491)) -> 
            name61);;

let rec compiler_backend_preamble_files backend2 = 
    (match backend2 with
         | (Backend (x492, files4, x493, x494, x495, x496)) -> 
            files4);;

let rec compiler_backend_pervasives_files backend3 = 
    (match backend3 with
         | (Backend (x497, x498, files5, x499, x500, x501)) -> 
            files5);;

let rec compiler_backend_generate_source backend4 module_name definitions15 = 
    (match backend4 with
         | (Backend (x502, x503, x504, generate2, x505, x506)) -> 
            (generate2 module_name definitions15));;

let rec compiler_backend_reserved_identifiers backend5 = 
    (match backend5 with
         | (Backend (x507, x508, x509, x510, identifiers2, x511)) -> 
            identifiers2);;

let rec compiler_backend_transform_definitions backend6 definitions16 = 
    (match backend6 with
         | (Backend (x512, x513, x514, x515, x516, transform)) -> 
            (transform definitions16));;

let rec data_internal_error () = 
    (string_from_list (Cons ((69l), (Cons ((110l), (Cons ((99l), (Cons ((111l), (Cons ((117l), (Cons ((110l), (Cons ((116l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((101l), (Cons ((114l), (Cons ((114l), (Cons ((111l), (Cons ((114l), (Cons ((32l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((98l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((105l), (Cons ((116l), (Cons ((32l), (Cons ((119l), (Cons ((97l), (Cons ((115l), (Cons ((32l), (Cons ((117l), (Cons ((110l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((101l), (Cons ((100l), (Cons ((46l), (Cons ((32l), (Cons ((84l), (Cons ((104l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((109l), (Cons ((105l), (Cons ((103l), (Cons ((104l), (Cons ((116l), (Cons ((32l), (Cons ((98l), (Cons ((101l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((109l), (Cons ((112l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((114l), (Cons ((32l), (Cons ((98l), (Cons ((117l), (Cons ((103l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_reserved_identifier_error () = 
    (string_from_list (Cons ((83l), (Cons ((121l), (Cons ((109l), (Cons ((98l), (Cons ((111l), (Cons ((108l), (Cons ((115l), (Cons ((32l), (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((120l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((104l), (Cons ((32l), (Cons ((226l), (Cons ((156l), (Cons ((168l), (Cons ((32l), (Cons ((97l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((114l), (Cons ((101l), (Cons ((115l), (Cons ((101l), (Cons ((114l), (Cons ((118l), (Cons ((101l), (Cons ((100l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_not_defined_error () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((102l), (Cons ((111l), (Cons ((108l), (Cons ((108l), (Cons ((111l), (Cons ((119l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((105l), (Cons ((100l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((105l), (Cons ((102l), (Cons ((105l), (Cons ((101l), (Cons ((114l), (Cons ((32l), (Cons ((119l), (Cons ((97l), (Cons ((115l), (Cons ((32l), (Cons ((110l), (Cons ((111l), (Cons ((116l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((101l), (Cons ((100l), (Cons ((58l), (Cons ((32l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_already_defined_error () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((102l), (Cons ((111l), (Cons ((108l), (Cons ((108l), (Cons ((111l), (Cons ((119l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((105l), (Cons ((100l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((105l), (Cons ((102l), (Cons ((105l), (Cons ((101l), (Cons ((114l), (Cons ((32l), (Cons ((119l), (Cons ((97l), (Cons ((115l), (Cons ((32l), (Cons ((97l), (Cons ((108l), (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((100l), (Cons ((121l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((101l), (Cons ((100l), (Cons ((58l), (Cons ((32l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_expression () = 
    (string_from_list (Cons ((73l), (Cons ((32l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((98l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((105l), (Cons ((116l), (Cons ((32l), (Cons ((100l), (Cons ((111l), (Cons ((101l), (Cons ((115l), (Cons ((110l), (Cons ((39l), (Cons ((116l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((116l), (Cons ((97l), (Cons ((105l), (Cons ((110l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((121l), (Cons ((116l), (Cons ((104l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_function_definition () = 
    (string_from_list (Cons ((77l), (Cons ((97l), (Cons ((108l), (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((109l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((102l), (Cons ((111l), (Cons ((117l), (Cons ((110l), (Cons ((100l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_function_definition_missing_name () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((109l), (Cons ((105l), (Cons ((115l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((105l), (Cons ((116l), (Cons ((115l), (Cons ((32l), (Cons ((110l), (Cons ((97l), (Cons ((109l), (Cons ((101l), (Cons ((44l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((97l), (Cons ((114l), (Cons ((103l), (Cons ((117l), (Cons ((109l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((32l), (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((100l), (Cons ((32l), (Cons ((105l), (Cons ((116l), (Cons ((115l), (Cons ((32l), (Cons ((98l), (Cons ((111l), (Cons ((100l), (Cons ((121l), (Cons ((46l), (Cons ((32l), (Cons ((65l), (Cons ((32l), (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((110l), (Cons ((101l), (Cons ((101l), (Cons ((100l), (Cons ((115l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((110l), (Cons ((97l), (Cons ((109l), (Cons ((101l), (Cons ((44l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((97l), (Cons ((114l), (Cons ((103l), (Cons ((117l), (Cons ((109l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((32l), (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((32l), (Cons ((40l), (Cons ((119l), (Cons ((104l), (Cons ((105l), (Cons ((99l), (Cons ((104l), (Cons ((32l), (Cons ((99l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((98l), (Cons ((101l), (Cons ((32l), (Cons ((101l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), (Cons ((41l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((98l), (Cons ((111l), (Cons ((100l), (Cons ((121l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((109l), (Cons ((32l), (Cons ((111l), (Cons ((102l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_definition () = 
    (string_from_list (Cons ((79l), (Cons ((110l), (Cons ((108l), (Cons ((121l), (Cons ((32l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((45l), (Cons ((32l), (Cons ((111l), (Cons ((114l), (Cons ((32l), (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((32l), (Cons ((99l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((98l), (Cons ((101l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((112l), (Cons ((32l), (Cons ((108l), (Cons ((101l), (Cons ((118l), (Cons ((101l), (Cons ((108l), (Cons ((32l), (Cons ((111l), (Cons ((102l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((46l), (Cons ((32l), (Cons ((89l), (Cons ((111l), (Cons ((117l), (Cons ((32l), (Cons ((110l), (Cons ((101l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((32l), (Cons ((119l), (Cons ((114l), (Cons ((97l), (Cons ((112l), (Cons ((32l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_type_definition () = 
    (string_from_list (Cons ((73l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((105l), (Cons ((110l), (Cons ((107l), (Cons ((32l), (Cons ((121l), (Cons ((111l), (Cons ((117l), (Cons ((32l), (Cons ((119l), (Cons ((97l), (Cons ((110l), (Cons ((116l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((32l), (Cons ((119l), (Cons ((114l), (Cons ((105l), (Cons ((116l), (Cons ((101l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((44l), (Cons ((32l), (Cons ((98l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((105l), (Cons ((116l), (Cons ((32l), (Cons ((100l), (Cons ((111l), (Cons ((101l), (Cons ((115l), (Cons ((110l), (Cons ((39l), (Cons ((116l), (Cons ((32l), (Cons ((104l), (Cons ((97l), (Cons ((118l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((114l), (Cons ((105l), (Cons ((103l), (Cons ((104l), (Cons ((116l), (Cons ((32l), (Cons ((115l), (Cons ((104l), (Cons ((97l), (Cons ((112l), (Cons ((101l), (Cons ((46l), (Cons ((32l), (Cons ((73l), (Cons ((116l), (Cons ((32l), (Cons ((115l), (Cons ((104l), (Cons ((111l), (Cons ((117l), (Cons ((108l), (Cons ((100l), (Cons ((32l), (Cons ((108l), (Cons ((111l), (Cons ((111l), (Cons ((107l), (Cons ((32l), (Cons ((108l), (Cons ((105l), (Cons ((107l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((105l), (Cons ((115l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_type_definition_ex () = 
    (string_from_list (Cons ((40l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((110l), (Cons ((97l), (Cons ((109l), (Cons ((101l), (Cons ((45l), (Cons ((111l), (Cons ((102l), (Cons ((45l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((78l), (Cons ((97l), (Cons ((109l), (Cons ((101l), (Cons ((79l), (Cons ((102l), (Cons ((67l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), (Cons ((32l), (Cons ((46l), (Cons ((46l), (Cons ((46l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_type_definition_missing_name () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((109l), (Cons ((105l), (Cons ((115l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((105l), (Cons ((116l), (Cons ((115l), (Cons ((32l), (Cons ((110l), (Cons ((97l), (Cons ((109l), (Cons ((101l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), (Cons ((46l), (Cons ((32l), (Cons ((65l), (Cons ((32l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((110l), (Cons ((101l), (Cons ((101l), (Cons ((100l), (Cons ((115l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((110l), (Cons ((97l), (Cons ((109l), (Cons ((101l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((116l), (Cons ((32l), (Cons ((108l), (Cons ((101l), (Cons ((97l), (Cons ((115l), (Cons ((116l), (Cons ((32l), (Cons ((111l), (Cons ((110l), (Cons ((101l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_type_definition_missing_constructors () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((109l), (Cons ((105l), (Cons ((115l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((32l), (Cons ((111l), (Cons ((102l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), (Cons ((115l), (Cons ((46l), (Cons ((32l), (Cons ((65l), (Cons ((32l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((110l), (Cons ((101l), (Cons ((101l), (Cons ((100l), (Cons ((115l), (Cons ((32l), (Cons ((97l), (Cons ((116l), (Cons ((32l), (Cons ((108l), (Cons ((101l), (Cons ((97l), (Cons ((115l), (Cons ((116l), (Cons ((32l), (Cons ((111l), (Cons ((110l), (Cons ((101l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_pattern () = 
    (string_from_list (Cons ((73l), (Cons ((32l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((112l), (Cons ((97l), (Cons ((116l), (Cons ((116l), (Cons ((101l), (Cons ((114l), (Cons ((110l), (Cons ((32l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((98l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((100l), (Cons ((111l), (Cons ((101l), (Cons ((115l), (Cons ((110l), (Cons ((39l), (Cons ((116l), (Cons ((32l), (Cons ((108l), (Cons ((111l), (Cons ((111l), (Cons ((107l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((114l), (Cons ((114l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_match_expression () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), (Cons ((32l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((105l), (Cons ((115l), (Cons ((32l), (Cons ((110l), (Cons ((111l), (Cons ((116l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((114l), (Cons ((114l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((44l), (Cons ((32l), (Cons ((109l), (Cons ((97l), (Cons ((107l), (Cons ((101l), (Cons ((32l), (Cons ((115l), (Cons ((117l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((121l), (Cons ((111l), (Cons ((117l), (Cons ((32l), (Cons ((104l), (Cons ((97l), (Cons ((118l), (Cons ((101l), (Cons ((32l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((115l), (Cons ((101l), (Cons ((115l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((114l), (Cons ((114l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((108l), (Cons ((121l), (Cons ((32l), (Cons ((115l), (Cons ((111l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((97l), (Cons ((116l), (Cons ((32l), (Cons ((97l), (Cons ((108l), (Cons ((108l), (Cons ((32l), (Cons ((121l), (Cons ((111l), (Cons ((117l), (Cons ((114l), (Cons ((32l), (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), (Cons ((32l), (Cons ((114l), (Cons ((117l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((109l), (Cons ((101l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((32l), (Cons ((112l), (Cons ((97l), (Cons ((105l), (Cons ((114l), (Cons ((115l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_symbol () = 
    (string_from_list (Cons ((69l), (Cons ((120l), (Cons ((112l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((110l), (Cons ((32l), (Cons ((105l), (Cons ((100l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((105l), (Cons ((102l), (Cons ((105l), (Cons ((101l), (Cons ((114l), (Cons ((32l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_constructor () = 
    (string_from_list (Cons ((69l), (Cons ((120l), (Cons ((112l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), (Cons ((32l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_malformed_type () = 
    (string_from_list (Cons ((69l), (Cons ((120l), (Cons ((112l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((101l), (Cons ((100l), (Cons ((32l), (Cons ((97l), (Cons ((32l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((32l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((58l), Empty)))))))))))))))))))))))))))))))))))))))))));;

let rec data_too_few_closing_brackets () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((97l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((111l), (Cons ((32l), (Cons ((102l), (Cons ((101l), (Cons ((119l), (Cons ((32l), (Cons ((99l), (Cons ((108l), (Cons ((111l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((115l), (Cons ((101l), (Cons ((115l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_too_many_closing_brackets () = 
    (string_from_list (Cons ((84l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((97l), (Cons ((114l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((111l), (Cons ((32l), (Cons ((109l), (Cons ((97l), (Cons ((110l), (Cons ((121l), (Cons ((32l), (Cons ((99l), (Cons ((108l), (Cons ((111l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((115l), (Cons ((101l), (Cons ((115l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_no_location_information () = 
    (string_from_list (Cons ((40l), (Cons ((78l), (Cons ((111l), (Cons ((32l), (Cons ((108l), (Cons ((111l), (Cons ((99l), (Cons ((97l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((97l), (Cons ((118l), (Cons ((97l), (Cons ((105l), (Cons ((108l), (Cons ((97l), (Cons ((98l), (Cons ((108l), (Cons ((101l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_line () = 
    (string_from_list (Cons ((76l), (Cons ((105l), (Cons ((110l), (Cons ((101l), (Cons ((58l), (Cons ((32l), Empty)))))))))))));;

let rec data_column () = 
    (string_from_list (Cons ((67l), (Cons ((111l), (Cons ((108l), (Cons ((117l), (Cons ((109l), (Cons ((110l), (Cons ((58l), (Cons ((32l), Empty)))))))))))))))));;

let rec data_file () = 
    (string_from_list (Cons ((70l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((58l), (Cons ((32l), Empty)))))))))))));;

let rec data_range () = 
    (string_from_list (Cons ((82l), (Cons ((97l), (Cons ((110l), (Cons ((103l), (Cons ((101l), (Cons ((58l), (Cons ((32l), Empty)))))))))))))));;

let rec string_format list30 = 
    (string_join (string_of_char (10l)) (list_map (string_join (string_empty ())) list30));;

let rec file_matches_reference source_reference57 file13 = 
    ((string_equal (source_reference_file_path source_reference57)) (source_file_path file13));;

let rec find_file_matching files6 source_reference58 = 
    (list_find_first (file_matches_reference source_reference58) files6);;

let rec range_information range106 = 
    (match range106 with
         | (Range (start2, end2)) -> 
            (string_join (string_of_char (45l)) (Cons ((string_from_int32 start2), (Cons ((string_from_int32 end2), Empty))))));;

let rec count_lines index17 lines2 source = 
    (match (string_index_of index17 (string_of_char (10l)) source) with
         | (Some (index18)) -> 
            (count_lines (Int32.add index18 (1l)) (Int32.add lines2 (1l)) source)
         | None -> 
            (Pair (lines2, (Int32.add (Int32.sub (string_size source) index17) (1l)))));;

let rec line_information file14 range107 = 
    (match range107 with
         | (Range (start3, x517)) -> 
            (match (string_from_slice (source_file_content file14)) with
                 | content7 -> 
                    (count_lines (0l) (1l) (string_substring (0l) start3 content7))));;

let rec next_newline content8 index19 = 
    (match (string_index_of index19 (string_of_char (10l)) content8) with
         | (Some (index20)) -> 
            (Int32.add index20 (1l))
         | None -> 
            index19);;

let rec source_paragraph file15 range108 = 
    (match range108 with
         | (Range (start4, end3)) -> 
            (match (string_from_slice (source_file_content file15)) with
                 | content9 -> 
                    (match (next_newline content9 (Int32.sub start4 (100l))) with
                         | paragraph_start -> 
                            (match (Int32.sub (next_newline content9 (Int32.add end3 (50l))) paragraph_start) with
                                 | paragraph_size -> 
                                    (string_substring paragraph_start paragraph_size content9)))));;

let rec location_information files7 source_reference59 range109 = 
    (match (find_file_matching files7 source_reference59) with
         | (Some (file16)) -> 
            (match (line_information file16 range109) with
                 | (Pair (lines3, column)) -> 
                    (string_format (Cons (Empty, (Cons ((Cons ((source_paragraph file16 range109), Empty)), (Cons (Empty, (Cons ((Cons ((data_line ()), (Cons ((string_from_int32 lines3), Empty)))), (Cons ((Cons ((data_column ()), (Cons ((string_from_int32 column), Empty)))), (Cons ((Cons ((data_range ()), (Cons ((range_information range109), Empty)))), (Cons ((Cons ((data_file ()), (Cons ((source_file_path file16), Empty)))), Empty))))))))))))))))
         | None -> 
            (data_no_location_information ()));;

let rec error_to_string files8 error15 = 
    (match error15 with
         | (InternalParserError (source_reference60, range110)) -> 
            (string_format (Cons ((Cons ((data_internal_error ()), Empty)), (Cons ((Cons ((location_information files8 source_reference60 range110), Empty)), Empty)))))
         | (MalformedExpressionError (source_reference61, range111)) -> 
            (string_format (Cons ((Cons ((data_malformed_expression ()), Empty)), (Cons ((Cons ((location_information files8 source_reference61 range111), Empty)), Empty)))))
         | (MalformedDefinitionError (source_reference62, range112)) -> 
            (string_format (Cons ((Cons ((data_malformed_definition ()), Empty)), (Cons ((Cons ((location_information files8 source_reference62 range112), Empty)), Empty)))))
         | (MalformedFunctionDefinitionError (source_reference63, range113)) -> 
            (string_format (Cons ((Cons ((data_malformed_function_definition ()), Empty)), (Cons ((Cons ((location_information files8 source_reference63 range113), Empty)), Empty)))))
         | (FunctionDefinitionMissingName (source_reference64, range114)) -> 
            (string_format (Cons ((Cons ((data_function_definition_missing_name ()), Empty)), (Cons ((Cons ((location_information files8 source_reference64 range114), Empty)), Empty)))))
         | (MalformedTypeDefinitionError (source_reference65, range115)) -> 
            (string_format (Cons ((Cons ((data_malformed_type_definition ()), Empty)), (Cons (Empty, (Cons ((Cons ((data_malformed_type_definition_ex ()), Empty)), (Cons ((Cons ((location_information files8 source_reference65 range115), Empty)), Empty)))))))))
         | (TypeDefinitionMissingName (source_reference66, range116)) -> 
            (string_format (Cons ((Cons ((data_type_definition_missing_name ()), Empty)), (Cons ((Cons ((location_information files8 source_reference66 range116), Empty)), Empty)))))
         | (TypeDefinitionMissingConstructors (source_reference67, range117)) -> 
            (string_format (Cons ((Cons ((data_type_definition_missing_constructors ()), Empty)), (Cons ((Cons ((location_information files8 source_reference67 range117), Empty)), Empty)))))
         | (MalformedPatternError (source_reference68, range118)) -> 
            (string_format (Cons ((Cons ((data_malformed_pattern ()), Empty)), (Cons ((Cons ((location_information files8 source_reference68 range118), Empty)), Empty)))))
         | (MalformedMatchExpressionError (source_reference69, range119)) -> 
            (string_format (Cons ((Cons ((data_malformed_match_expression ()), Empty)), (Cons ((Cons ((location_information files8 source_reference69 range119), Empty)), Empty)))))
         | (MalformedSymbolError (source_reference70, range120)) -> 
            (string_format (Cons ((Cons ((data_malformed_symbol ()), Empty)), (Cons ((Cons ((location_information files8 source_reference70 range120), Empty)), Empty)))))
         | (MalformedConstructorError (source_reference71, range121)) -> 
            (string_format (Cons ((Cons ((data_malformed_constructor ()), Empty)), (Cons ((Cons ((location_information files8 source_reference71 range121), Empty)), Empty)))))
         | (MalformedTypeError (source_reference72, range122)) -> 
            (string_format (Cons ((Cons ((data_malformed_type ()), Empty)), (Cons ((Cons ((location_information files8 source_reference72 range122), Empty)), Empty)))))
         | (ErrorNotDefined (name62, source_reference73, range123)) -> 
            (string_format (Cons ((Cons ((string_concat (data_not_defined_error ()) name62), Empty)), (Cons ((Cons ((location_information files8 source_reference73 range123), Empty)), Empty)))))
         | (ErrorAlreadyDefined (name63, source_reference74, range124)) -> 
            (string_format (Cons ((Cons ((string_concat (data_already_defined_error ()) name63), Empty)), (Cons ((Cons ((location_information files8 source_reference74 range124), Empty)), Empty)))))
         | (ErrorReservedIdentifier (name64, source_reference75, range125)) -> 
            (string_format (Cons ((Cons ((string_concat (data_reserved_identifier_error ()) name64), Empty)), (Cons ((Cons ((location_information files8 source_reference75 range125), Empty)), Empty)))))
         | MalformedSexpTooFewClosingBrackets -> 
            (string_format (Cons ((Cons ((data_too_few_closing_brackets ()), Empty)), Empty)))
         | MalformedSexpTooManyClosingBrackets -> 
            (string_format (Cons ((Cons ((data_too_many_closing_brackets ()), Empty)), Empty))));;

let rec data_8 () = 
    (string_from_list (Cons ((47l), Empty)));;

let rec path_filename path8 = 
    (match (list_last (string_split (47l) path8)) with
         | (Some (filename)) -> 
            filename
         | None -> 
            path8);;

let rec path_filename_without_extension path9 = 
    (match (list_first (string_split (46l) (path_filename path9))) with
         | (Some (name65)) -> 
            name65
         | None -> 
            (path_filename path9));;

let rec path_filename_extension path10 = 
    (match (list_last (string_split (46l) (path_filename path10))) with
         | (Some (name66)) -> 
            name66
         | None -> 
            (string_empty ()));;

let rec path_join paths = 
    (string_join (data_8 ()) paths);;

let rec data_standard_library_filename () = 
    (string_from_list (Cons ((115l), (Cons ((116l), (Cons ((97l), (Cons ((110l), (Cons ((100l), (Cons ((97l), (Cons ((114l), (Cons ((100l), (Cons ((45l), (Cons ((108l), (Cons ((105l), (Cons ((98l), (Cons ((114l), (Cons ((97l), (Cons ((114l), (Cons ((121l), (Cons ((46l), (Cons ((114l), (Cons ((101l), (Cons ((117l), (Cons ((115l), (Cons ((101l), Empty)))))))))))))))))))))))))))))))))))))))))))));;

let rec data_parser_filename () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((101l), (Cons ((114l), (Cons ((46l), (Cons ((114l), (Cons ((101l), (Cons ((117l), (Cons ((115l), (Cons ((101l), Empty)))))))))))))))))))))))));;

let rec data_9 () = 
    (string_from_list Empty);;

let rec generate backend7 module_name2 definitions17 = 
    (result_map (compiler_backend_generate_source backend7 module_name2) definitions17);;

let rec module_name_and_path open3 path11 = 
    (Pair ((ModulePath ((path_filename_without_extension path11), open3)), path11));;

let rec standard_library_files backend8 data_path = 
    (Cons ((path_join (Cons (data_path, (Cons ((data_standard_library_filename ()), Empty))))), (list_map (fun filename2 -> (path_join (Cons (data_path, (Cons (filename2, Empty)))))) (compiler_backend_pervasives_files backend8))));;

let rec standard_library_module backend9 data_path2 = 
    (list_map (module_name_and_path True) (standard_library_files backend9 data_path2));;

let rec parser_module backend10 data_path3 = 
    (module_name_and_path True (path_join (Cons (data_path3, (Cons ((data_parser_filename ()), Empty))))));;

let rec preamble_files backend11 data_path4 = 
    (list_map (fun filename3 -> (Pair (ModuleSelf, (string_concat data_path4 filename3)))) (compiler_backend_preamble_files backend11));;

let rec data_space2 () = 
    (string_from_list (Cons ((32l), Empty)));;

let rec data_fun2 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), Empty)))))));;

let rec data_type2 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_if2 () = 
    (string_from_list (Cons ((105l), (Cons ((102l), Empty)))));;

let rec data_then2 () = 
    (string_from_list (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_else2 () = 
    (string_from_list (Cons ((101l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))));;

let rec data_with2 () = 
    (string_from_list (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((104l), Empty)))))))));;

let rec data_of2 () = 
    (string_from_list (Cons ((111l), (Cons ((102l), Empty)))));;

let rec data_class2 () = 
    (string_from_list (Cons ((99l), (Cons ((108l), (Cons ((97l), (Cons ((115l), (Cons ((115l), Empty)))))))))));;

let rec data_end2 () = 
    (string_from_list (Cons ((101l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_in2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), Empty)))));;

let rec data_let2 () = 
    (string_from_list (Cons ((108l), (Cons ((101l), (Cons ((116l), Empty)))))));;

let rec data_open2 () = 
    (string_from_list (Cons ((111l), (Cons ((112l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_and2 () = 
    (string_from_list (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_or2 () = 
    (string_from_list (Cons ((111l), (Cons ((114l), Empty)))));;

let rec data_as2 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), Empty)))));;

let rec data_less_than2 () = 
    (string_from_list (Cons ((60l), Empty)));;

let rec data_assert2 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((115l), (Cons ((101l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_asr2 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_begin2 () = 
    (string_from_list (Cons ((98l), (Cons ((101l), (Cons ((103l), (Cons ((105l), (Cons ((110l), Empty)))))))))));;

let rec data_constraint2 () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((97l), (Cons ((105l), (Cons ((110l), (Cons ((116l), Empty)))))))))))))))))))));;

let rec data_do2 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), Empty)))));;

let rec data_done2 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((110l), (Cons ((101l), Empty)))))))));;

let rec data_downto2 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((119l), (Cons ((110l), (Cons ((116l), (Cons ((111l), Empty)))))))))))));;

let rec data_exception2 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((99l), (Cons ((101l), (Cons ((112l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))))));;

let rec data_external2 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((116l), (Cons ((101l), (Cons ((114l), (Cons ((110l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))))));;

let rec data_false2 () = 
    (string_from_list (Cons ((102l), (Cons ((97l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))))));;

let rec data_true3 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))));;

let rec data_for2 () = 
    (string_from_list (Cons ((102l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_function2 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))));;

let rec data_functor2 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), Empty)))))))))))))));;

let rec data_include2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((99l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), Empty)))))))))))))));;

let rec data_inherit2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((105l), (Cons ((116l), Empty)))))))))))))));;

let rec data_initializer2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((97l), (Cons ((108l), (Cons ((105l), (Cons ((122l), (Cons ((101l), (Cons ((114l), Empty)))))))))))))))))))))));;

let rec data_land2 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))));;

let rec data_lazy2 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((122l), (Cons ((121l), Empty)))))))));;

let rec data_lor2 () = 
    (string_from_list (Cons ((108l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_lsl2 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((108l), Empty)))))));;

let rec data_lsr2 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_lxor2 () = 
    (string_from_list (Cons ((108l), (Cons ((120l), (Cons ((111l), (Cons ((114l), Empty)))))))));;

let rec data_method2 () = 
    (string_from_list (Cons ((109l), (Cons ((101l), (Cons ((116l), (Cons ((104l), (Cons ((111l), (Cons ((100l), Empty)))))))))))));;

let rec data_mod2 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), Empty)))))));;

let rec data_module2 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), Empty)))))))))))));;

let rec data_mutable2 () = 
    (string_from_list (Cons ((109l), (Cons ((117l), (Cons ((116l), (Cons ((97l), (Cons ((98l), (Cons ((108l), (Cons ((101l), Empty)))))))))))))));;

let rec data_new2 () = 
    (string_from_list (Cons ((110l), (Cons ((101l), (Cons ((119l), Empty)))))));;

let rec data_nonrec2 () = 
    (string_from_list (Cons ((110l), (Cons ((111l), (Cons ((110l), (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))))))))));;

let rec data_object2 () = 
    (string_from_list (Cons ((111l), (Cons ((98l), (Cons ((106l), (Cons ((101l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_private2 () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((105l), (Cons ((118l), (Cons ((97l), (Cons ((116l), (Cons ((101l), Empty)))))))))))))));;

let rec data_rec2 () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))));;

let rec data_sig2 () = 
    (string_from_list (Cons ((115l), (Cons ((105l), (Cons ((103l), Empty)))))));;

let rec data_struct2 () = 
    (string_from_list (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_try2 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((121l), Empty)))))));;

let rec data_val2 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), Empty)))))));;

let rec data_virtual2 () = 
    (string_from_list (Cons ((118l), (Cons ((105l), (Cons ((114l), (Cons ((116l), (Cons ((117l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))));;

let rec data_when2 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_while2 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((105l), (Cons ((108l), (Cons ((101l), Empty)))))))))));;

let rec data_parser2 () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((101l), (Cons ((114l), Empty)))))))))))));;

let rec data_value2 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), (Cons ((117l), (Cons ((101l), Empty)))))))))));;

let rec data_to2 () = 
    (string_from_list (Cons ((116l), (Cons ((111l), Empty)))));;

let rec data_def4 () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), Empty)))))));;

let rec data_typ4 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), Empty)))))));;

let rec data_fn4 () = 
    (string_from_list (Cons ((102l), (Cons ((110l), Empty)))));;

let rec data_match4 () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_exists4 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((115l), Empty)))))))))))));;

let rec data_pub4 () = 
    (string_from_list (Cons ((112l), (Cons ((117l), (Cons ((98l), Empty)))))));;

let rec data_10 () = 
    (string_from_list (Cons ((43l), Empty)));;

let rec data__2 () = 
    (string_from_list (Cons ((45l), Empty)));;

let rec data_11 () = 
    (string_from_list (Cons ((42l), Empty)));;

let rec data_12 () = 
    (string_from_list (Cons ((47l), Empty)));;

let rec data_13 () = 
    (string_from_list (Cons ((37l), Empty)));;

let rec data_14 () = 
    (string_from_list (Cons ((38l), Empty)));;

let rec data_int32_less_than2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((45l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((45l), (Cons ((116l), (Cons ((104l), (Cons ((97l), (Cons ((110l), Empty)))))))))))))))))))))))))))))));;

let rec data_pipe3 () = 
    (string_from_list (Cons ((112l), (Cons ((105l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_dot2 () = 
    (string_from_list (Cons ((46l), Empty)));;

let rec data_list3 () = 
    (string_from_list (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), Empty)))))))));;

let rec data_slice_empty2 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((101l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), Empty)))))))))))))))))))))));;

let rec data_slice_of_u82 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((111l), (Cons ((102l), (Cons ((45l), (Cons ((117l), (Cons ((56l), Empty)))))))))))))))))))))));;

let rec data_slice_size2 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((105l), (Cons ((122l), (Cons ((101l), Empty)))))))))))))))))))));;

let rec data_slice_get2 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((103l), (Cons ((101l), (Cons ((116l), Empty)))))))))))))))))));;

let rec data_slice_concat2 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((99l), (Cons ((97l), (Cons ((116l), Empty)))))))))))))))))))))))));;

let rec data_slice_foldl2 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((102l), (Cons ((111l), (Cons ((108l), (Cons ((100l), (Cons ((108l), Empty)))))))))))))))))))))));;

let rec data_slice_subslice2 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((117l), (Cons ((98l), (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))))))))))))))))))))));;

let rec data_slice2 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))));;

let rec data_int322 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), Empty)))))))))));;

let rec data_compile_error () = 
    (string_from_list (Cons ((42l), (Cons ((99l), (Cons ((111l), (Cons ((109l), (Cons ((112l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((32l), (Cons ((101l), (Cons ((114l), (Cons ((114l), (Cons ((111l), (Cons ((114l), (Cons ((42l), Empty)))))))))))))))))))))))))))))));;

let rec data_backslash () = 
    (string_from_list (Cons ((92l), Empty)));;

let rec data_arrow () = 
    (string_from_list (Cons ((32l), (Cons ((45l), (Cons ((62l), (Cons ((32l), Empty)))))))));;

let rec data_equals () = 
    (string_from_list (Cons ((32l), (Cons ((61l), (Cons ((32l), Empty)))))));;

let rec data_vertical_bar () = 
    (string_from_list (Cons ((32l), (Cons ((124l), (Cons ((32l), Empty)))))));;

let rec data_pipe_operator () = 
    (string_from_list (Cons ((32l), (Cons ((124l), (Cons ((62l), (Cons ((32l), Empty)))))))));;

let rec data_colon () = 
    (string_from_list (Cons ((32l), (Cons ((58l), (Cons ((32l), Empty)))))));;

let rec data_semicolon () = 
    (string_from_list (Cons ((32l), (Cons ((59l), (Cons ((32l), Empty)))))));;

let rec data_star () = 
    (string_from_list (Cons ((32l), (Cons ((42l), (Cons ((32l), Empty)))))));;

let rec data_int323 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), Empty)))))))))));;

let rec data_int32_plus () = 
    (string_from_list (Cons ((95l), (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((97l), (Cons ((100l), (Cons ((100l), Empty)))))))))))))))))))));;

let rec data_int32_multiply () = 
    (string_from_list (Cons ((95l), (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((109l), (Cons ((117l), (Cons ((108l), Empty)))))))))))))))))))));;

let rec data_int32_minus () = 
    (string_from_list (Cons ((95l), (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((115l), (Cons ((117l), (Cons ((98l), Empty)))))))))))))))))))));;

let rec data_int32_divide () = 
    (string_from_list (Cons ((80l), (Cons ((114l), (Cons ((101l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), (Cons ((46l), (Cons ((113l), (Cons ((117l), (Cons ((111l), (Cons ((116l), Empty)))))))))))))))))))))))));;

let rec data_int32_modulus () = 
    (string_from_list (Cons ((80l), (Cons ((114l), (Cons ((101l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), (Cons ((46l), (Cons ((114l), (Cons ((101l), (Cons ((109l), Empty)))))))))))))))))))))));;

let rec data_int32_and () = 
    (string_from_list (Cons ((95l), (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))))))))))))))));;

let rec data_slice_type () = 
    (string_from_list (Cons ((66l), (Cons ((121l), (Cons ((116l), (Cons ((101l), (Cons ((115l), Empty)))))))))));;

let rec data_cempty () = 
    (string_from_list (Cons ((67l), (Cons ((69l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), Empty)))))))))))));;

let rec data_ccons () = 
    (string_from_list (Cons ((67l), (Cons ((67l), (Cons ((111l), (Cons ((110l), (Cons ((115l), Empty)))))))))));;

let rec data_comma () = 
    (string_from_list (Cons ((44l), Empty)));;

let rec data_constant () = 
    (string_from_list (Cons ((95l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((97l), (Cons ((110l), (Cons ((116l), (Cons ((95l), Empty)))))))))))))))))))));;

let rec data_data () = 
    (string_from_list (Cons ((100l), (Cons ((97l), (Cons ((116l), (Cons ((97l), Empty)))))))));;

let rec data_case () = 
    (string_from_list (Cons ((99l), (Cons ((97l), (Cons ((115l), (Cons ((101l), Empty)))))))));;

let rec data_deriving () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((114l), (Cons ((105l), (Cons ((118l), (Cons ((105l), (Cons ((110l), (Cons ((103l), Empty)))))))))))))))));;

let rec data_family () = 
    (string_from_list (Cons ((102l), (Cons ((97l), (Cons ((109l), (Cons ((105l), (Cons ((108l), (Cons ((121l), Empty)))))))))))));;

let rec data_default () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((97l), (Cons ((117l), (Cons ((108l), (Cons ((116l), Empty)))))))))))))));;

let rec data_forall () = 
    (string_from_list (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((97l), (Cons ((108l), (Cons ((108l), Empty)))))))))))));;

let rec data_foreign () = 
    (string_from_list (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((101l), (Cons ((105l), (Cons ((103l), (Cons ((110l), Empty)))))))))))))));;

let rec data_import () = 
    (string_from_list (Cons ((105l), (Cons ((109l), (Cons ((112l), (Cons ((111l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_instance () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((97l), (Cons ((110l), (Cons ((99l), (Cons ((101l), Empty)))))))))))))))));;

let rec data_infix () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((102l), (Cons ((105l), (Cons ((120l), Empty)))))))))));;

let rec data_infixl () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((102l), (Cons ((105l), (Cons ((120l), (Cons ((108l), Empty)))))))))))));;

let rec data_infixr () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((102l), (Cons ((105l), (Cons ((120l), (Cons ((114l), Empty)))))))))))));;

let rec data_newtype () = 
    (string_from_list (Cons ((110l), (Cons ((101l), (Cons ((119l), (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), Empty)))))))))))))));;

let rec data_where () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((101l), Empty)))))))))));;

let rec data_15 () = 
    (string_from_list (Cons ((58l), (Cons ((58l), Empty)))));;

let rec data_open_bracket2 () = 
    (string_from_list (Cons ((40l), Empty)));;

let rec data_close_bracket2 () = 
    (string_from_list (Cons ((41l), Empty)));;

let rec data_dot3 () = 
    (string_from_list (Cons ((46l), Empty)));;

let rec data_language_exts () = 
    (string_from_list (Cons ((123l), (Cons ((45l), (Cons ((35l), (Cons ((32l), (Cons ((76l), (Cons ((65l), (Cons ((78l), (Cons ((71l), (Cons ((85l), (Cons ((65l), (Cons ((71l), (Cons ((69l), (Cons ((32l), (Cons ((69l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((101l), (Cons ((110l), (Cons ((116l), (Cons ((105l), (Cons ((97l), (Cons ((108l), (Cons ((81l), (Cons ((117l), (Cons ((97l), (Cons ((110l), (Cons ((116l), (Cons ((105l), (Cons ((102l), (Cons ((105l), (Cons ((99l), (Cons ((97l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((35l), (Cons ((45l), (Cons ((125l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_pervasives_filename () = 
    (string_from_list (Cons ((80l), (Cons ((101l), (Cons ((114l), (Cons ((118l), (Cons ((97l), (Cons ((115l), (Cons ((105l), (Cons ((118l), (Cons ((101l), (Cons ((115l), (Cons ((46l), (Cons ((104l), (Cons ((115l), Empty)))))))))))))))))))))))))));;

let rec data_preamble_filename () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((109l), (Cons ((98l), (Cons ((108l), (Cons ((101l), (Cons ((46l), (Cons ((104l), (Cons ((115l), Empty)))))))))))))))))))))));;

let rec data_haskell_language () = 
    (string_from_list (Cons ((104l), (Cons ((97l), (Cons ((115l), (Cons ((107l), (Cons ((101l), (Cons ((108l), (Cons ((108l), Empty)))))))))))))));;

let rec reserved_identifiers () = 
    (list_flatten (Cons ((Cons (data_if2, (Cons (data_then2, (Cons (data_else2, (Cons (data_with2, (Cons (data_of2, (Cons (data_end2, (Cons (data_in2, Empty)))))))))))))), (Cons ((Cons (data_type2, (Cons (data_let2, (Cons (data_class2, (Cons (data_do2, (Cons (data_module2, (Cons (data_data, Empty)))))))))))), (Cons ((Cons (data_case, (Cons (data_deriving, (Cons (data_family, (Cons (data_default, (Cons (data_forall, Empty)))))))))), (Cons ((Cons (data_foreign, (Cons (data_import, (Cons (data_instance, (Cons (data_infix, (Cons (data_infixl, Empty)))))))))), (Cons ((Cons (data_infixr, (Cons (data_newtype, (Cons (data_where, Empty)))))), Empty)))))))))));;

let rec escape_identifier identifier58 = 
    (SourceStringIdentifier (identifier58, IdentifierTransformationLowercase));;

let rec translate_constructor_identifier constructor12 = 
    (SourceStringIdentifier (constructor12, IdentifierTransformationCapitalize));;

let rec operator_translation_map () = 
    (dictionary_of (Cons ((Pair ((data_10 ()), (SourceString ((data_int32_plus ()))))), (Cons ((Pair ((data__2 ()), (SourceString ((data_int32_minus ()))))), (Cons ((Pair ((data_11 ()), (SourceString ((data_int32_multiply ()))))), (Cons ((Pair ((data_12 ()), (SourceString ((data_int32_divide ()))))), (Cons ((Pair ((data_13 ()), (SourceString ((data_int32_modulus ()))))), (Cons ((Pair ((data_14 ()), (SourceString ((data_int32_and ()))))), Empty)))))))))))));;

let rec translate_identifier identifier59 = 
    (match (token_is_operator (identifier_token identifier59)) with
         | True -> 
            (match (dictionary_get (identifier_name identifier59) (operator_translation_map ())) with
                 | (Some (translation)) -> 
                    translation
                 | None -> 
                    (escape_identifier identifier59))
         | False -> 
            (escape_identifier identifier59));;

let rec prefix_type_variable identifier60 = 
    (SourceStringIdentifier (identifier60, IdentifierTransformationLowercase));;

let rec prefix_type identifier61 = 
    (match (identifier_is identifier61 (identifier_slice ())) with
         | True -> 
            (SourceString ((data_slice_type ())))
         | False -> 
            (match (identifier_is identifier61 (identifier_int32 ())) with
                 | True -> 
                    (SourceString ((data_int323 ())))
                 | False -> 
                    (SourceStringIdentifier (identifier61, IdentifierTransformationCapitalize))));;

let rec translate_less_than translate_expression expressions33 = 
    (match expressions33 with
         | (Cons (a72, (Cons (b67, (Cons (then_case, (Cons (else_case, Empty)))))))) -> 
            (join (Cons ((SourceString ((data_if2 ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_open_bracket2 ()))), (Cons ((translate_expression a72), (Cons ((SourceString ((data_15 ()))), (Cons ((SourceString ((data_int323 ()))), (Cons ((SourceString ((data_close_bracket2 ()))), (Cons ((SourceString ((data_less_than2 ()))), (Cons ((SourceString ((data_open_bracket2 ()))), (Cons ((translate_expression b67), (Cons ((SourceString ((data_15 ()))), (Cons ((SourceString ((data_int323 ()))), (Cons ((SourceString ((data_close_bracket2 ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_then2 ()))), (Cons ((source_space ()), (Cons ((translate_expression then_case), (Cons ((source_space ()), (Cons ((SourceString ((data_else2 ()))), (Cons ((source_space ()), (Cons ((translate_expression else_case), Empty)))))))))))))))))))))))))))))))))))))))))))
         | x518 -> 
            (SourceString ((data_compile_error ()))));;

let rec translate_constructor translator name67 constructor13 = 
    (wrap_in_brackets2 (join ((fun parameters14 -> (Cons ((translate_constructor_identifier name67), (Cons ((source_space ()), (Cons (parameters14, Empty))))))) ((source_string_join (data_space2 ())) ((list_map translator) constructor13)))));;

let rec translate_pattern pattern13 = 
    (match pattern13 with
         | (Capture (identifier62)) -> 
            (escape_identifier identifier62)
         | (IntegerPattern (integer9, x519)) -> 
            (match (x2 integer9 (0l)) with
                 | True -> 
                    (SourceString ((wrap_in_brackets (string_from_int32 integer9))))
                 | False -> 
                    (SourceString ((string_from_int32 integer9))))
         | (ConstructorPattern (identifier63, Empty, x520)) -> 
            (translate_constructor_identifier identifier63)
         | (ConstructorPattern (identifier64, patterns5, x521)) -> 
            ((translate_constructor translate_pattern identifier64) patterns5));;

let rec translate_rule translate_expression2 n11 rule3 = 
    (match rule3 with
         | (Pair (pattern14, expression59)) -> 
            (join_lines (Cons ((line n11 (Cons ((translate_pattern pattern14), (Cons ((SourceString ((data_arrow ()))), Empty))))), (Cons ((line (Int32.add n11 (1l)) (Cons ((translate_expression2 (Int32.add n11 (1l)) expression59), Empty))), Empty))))));;

let rec translate_match_expression translate_expression3 n12 expression60 rules8 = 
    ((source_string_join (string_empty ())) ((fun rules9 -> (Cons ((SourceString ((data_case ()))), (Cons ((source_space ()), (Cons ((translate_expression3 n12 expression60), (Cons ((source_space ()), (Cons ((SourceString ((data_of2 ()))), (Cons (rules9, Empty))))))))))))) ((source_string_join (string_empty ())) ((list_map (translate_rule translate_expression3 n12)) rules8))));;

let rec translate_function_application translate_expression4 expressions34 = 
    (match expressions34 with
         | (Cons (no_args_function, Empty)) -> 
            (translate_expression4 no_args_function)
         | x522 -> 
            (source_string_join (data_space2 ()) (list_map translate_expression4 expressions34)));;

let rec translate_function_application2 translate_expression5 expressions35 = 
    (match expressions35 with
         | (Cons ((Variable (identifier65)), rest32)) -> 
            (match (x4 (identifier_token identifier65) (identifier_int32_less_than ())) with
                 | True -> 
                    (translate_less_than translate_expression5 rest32)
                 | False -> 
                    (translate_function_application translate_expression5 expressions35))
         | x523 -> 
            (translate_function_application translate_expression5 expressions35));;

let rec translate_argument_list arguments22 = 
    (source_string_join (data_space2 ()) (list_map escape_identifier arguments22));;

let rec translate_lambda translate_expression6 arguments23 expression61 = 
    (match (list_is_empty arguments23) with
         | True -> 
            (translate_expression6 expression61)
         | False -> 
            (join (Cons ((SourceString ((data_backslash ()))), (Cons ((source_space ()), (Cons ((translate_argument_list arguments23), (Cons ((SourceString ((data_arrow ()))), (Cons ((translate_expression6 expression61), Empty))))))))))));;

let rec translate_expression7 n13 expression62 = 
    (match expression62 with
         | (Lambda (arguments24, expression63, x524)) -> 
            (wrap_in_brackets2 (translate_lambda (translate_expression7 n13) arguments24 expression63))
         | (Constructor (identifier66, Empty, x525)) -> 
            (translate_constructor_identifier identifier66)
         | (Constructor (identifier67, expressions36, x526)) -> 
            ((translate_constructor (translate_expression7 n13) identifier67) expressions36)
         | (FunctionApplication (expressions37, x527)) -> 
            (wrap_in_brackets2 (translate_function_application2 (translate_expression7 n13) expressions37))
         | (IntegerConstant (integer10, x528)) -> 
            (match (x2 integer10 (0l)) with
                 | True -> 
                    (SourceString ((wrap_in_brackets (string_from_int32 integer10))))
                 | False -> 
                    (SourceString ((string_from_int32 integer10))))
         | (Variable (identifier68)) -> 
            (translate_identifier identifier68)
         | (Match (expression64, rules10, x529)) -> 
            (wrap_in_brackets2 (translate_match_expression translate_expression7 (Int32.add n13 (1l)) expression64 rules10)));;

let rec translate_function_definition name68 arguments25 expression65 = 
    (match (list_is_empty arguments25) with
         | True -> 
            ((line (0l)) (Cons (name68, (Cons ((source_space ()), (Cons ((SourceString ((data_equals ()))), (Cons ((source_space ()), (Cons ((translate_expression7 (0l) expression65), Empty)))))))))))
         | False -> 
            (join_lines (Cons (((line (0l)) (Cons (name68, (Cons ((source_space ()), (Cons ((translate_argument_list arguments25), (Cons ((SourceString ((data_equals ()))), Empty))))))))), (Cons (((line (1l)) (Cons ((translate_expression7 (1l) expression65), Empty))), Empty))))));;

let rec type_parameter_equals identifier69 parameter4 = 
    (identifier_equal identifier69 (type_parameter_identifier parameter4));;

let rec translate_simple_type identifier70 parameters15 = 
    (match (list_any (type_parameter_equals identifier70) parameters15) with
         | False -> 
            (prefix_type identifier70)
         | True -> 
            (prefix_type_variable identifier70));;

let rec translate_complex_types translate_types name69 types7 = 
    (wrap_in_brackets2 ((source_string_concat (source_string_concat (prefix_type name69) (source_space ()))) ((translate_types (data_space2 ())) types7)));;

let rec translate_function_type translate_types2 return_type5 argument_types2 = 
    (wrap_in_brackets2 ((translate_types2 (data_arrow ())) ((fun argument_types3 -> (list_concat argument_types3 (Cons (return_type5, Empty)))) argument_types2)));;

let rec translate_type translate_types3 parameters16 type5 = 
    (match type5 with
         | (SimpleType (identifier71)) -> 
            (translate_simple_type identifier71 parameters16)
         | (ComplexType (identifier72, types8, x530)) -> 
            (translate_complex_types translate_types3 identifier72 types8)
         | (FunctionType (argument_types4, return_type6, x531)) -> 
            (translate_function_type translate_types3 return_type6 argument_types4));;

let rec translate_types4 parameters17 separator5 types9 = 
    ((source_string_join separator5) ((list_map (translate_type (translate_types4 parameters17) parameters17)) types9));;

let rec translate_type_parameter parameter5 = 
    (match parameter5 with
         | (UniversalParameter (identifier73)) -> 
            (SourceString ((identifier_name identifier73)))
         | (ExistentialParameter (identifier74)) -> 
            (SourceString ((identifier_name identifier74))));;

let rec translate_complex_constructor_definition name70 types10 parameters18 = 
    (join (Cons ((translate_constructor_identifier name70), (Cons ((source_space ()), (Cons ((translate_types4 parameters18 (data_space2 ()) types10), Empty)))))));;

let rec translate_constructor_definition parameters19 constructor14 = 
    (match constructor14 with
         | (SimpleConstructor (identifier75)) -> 
            (translate_constructor_identifier identifier75)
         | (ComplexConstructor (identifier76, types11, x532)) -> 
            (translate_complex_constructor_definition identifier76 types11 parameters19));;

let rec translate_constructor_definitions n14 parameters20 constructors20 = 
    ((source_string_join (string_concat (newline ()) (string_concat (indent n14) (data_vertical_bar ())))) ((list_map (translate_constructor_definition parameters20)) constructors20));;

let rec append_universal_parameter parameter6 s2 = 
    (match parameter6 with
         | (UniversalParameter (identifier77)) -> 
            (join (Cons (s2, (Cons ((source_space ()), (Cons ((prefix_type_variable identifier77), Empty)))))))
         | (ExistentialParameter (x533)) -> 
            s2);;

let rec append_existential_parameter parameter7 s3 = 
    (match parameter7 with
         | (UniversalParameter (x534)) -> 
            s3
         | (ExistentialParameter (identifier78)) -> 
            (join (Cons (s3, (Cons ((SourceString ((data_forall ()))), (Cons ((source_space ()), (Cons ((prefix_type_variable identifier78), (Cons ((SourceString ((data_dot3 ()))), (Cons ((source_space ()), Empty))))))))))))));;

let rec translate_type_definition name71 parameters21 constructors21 = 
    (join_lines (Cons (((line (0l)) (Cons ((SourceString ((data_data ()))), (Cons ((source_space ()), (Cons ((prefix_type name71), (Cons ((list_foldl append_universal_parameter (source_string_empty ()) parameters21), (Cons ((SourceString ((data_equals ()))), (Cons ((list_foldl append_existential_parameter (source_string_empty ()) parameters21), Empty))))))))))))), (Cons (((line (1l)) (Cons ((SourceString ((string_repeat (data_space2 ()) (3l)))), (Cons ((translate_constructor_definitions (1l) parameters21 constructors21), Empty))))), Empty)))));;

let rec translate_definition definition18 = 
    (match definition18 with
         | (FunctionDefinition (name72, x535, arguments26, expression66, x536)) -> 
            (translate_function_definition (escape_identifier name72) arguments26 expression66)
         | (TypeDefinition (name73, x537, parameters22, constructors22, x538)) -> 
            (translate_type_definition name73 parameters22 constructors22)
         | (TargetDefinition (x539, data2)) -> 
            (SourceString ((string_from_slice data2))));;

let rec translate_module_declaration module_name3 = 
    (join (Cons ((SourceString ((data_module2 ()))), (Cons ((source_space ()), (Cons ((SourceString (module_name3)), (Cons ((source_space ()), (Cons ((SourceString ((data_where ()))), Empty)))))))))));;

let rec definition_to_public_identifier definition19 = 
    (match definition19 with
         | (FunctionDefinition (name74, True, x540, x541, x542)) -> 
            (Some ((Pair (IdentifierTransformationLowercase, name74))))
         | (TypeDefinition (name75, True, x543, x544, x545)) -> 
            (Some ((Pair (IdentifierTransformationCapitalize, name75))))
         | x546 -> 
            None);;

let rec public_identifiers_with_transformations definitions18 = 
    (list_flatmap (fun x51 -> (list_from_maybe (definition_to_public_identifier x51))) definitions18);;

let rec generate_source module_name4 definitions19 = 
    ((pair_cons (public_identifiers_with_transformations definitions19)) ((source_string_join (string_of_char (10l))) ((list_cons (SourceString ((data_language_exts ())))) ((list_cons (translate_module_declaration module_name4)) ((list_map translate_definition) definitions19)))));;

let rec compiler_backend_haskell () = 
    (Backend ((data_haskell_language ()), (Cons ((data_preamble_filename ()), Empty)), (Cons ((data_pervasives_filename ()), Empty)), generate_source, (reserved_identifiers ()), (fun x51 -> (local_transforms (validate_reserved_identifiers x51)))));;

let rec data_space3 () = 
    (string_from_list (Cons ((32l), Empty)));;

let rec data_fun3 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), Empty)))))));;

let rec data_type3 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_if3 () = 
    (string_from_list (Cons ((105l), (Cons ((102l), Empty)))));;

let rec data_then3 () = 
    (string_from_list (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_else3 () = 
    (string_from_list (Cons ((101l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))));;

let rec data_with3 () = 
    (string_from_list (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((104l), Empty)))))))));;

let rec data_of3 () = 
    (string_from_list (Cons ((111l), (Cons ((102l), Empty)))));;

let rec data_class3 () = 
    (string_from_list (Cons ((99l), (Cons ((108l), (Cons ((97l), (Cons ((115l), (Cons ((115l), Empty)))))))))));;

let rec data_end3 () = 
    (string_from_list (Cons ((101l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_in3 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), Empty)))));;

let rec data_let3 () = 
    (string_from_list (Cons ((108l), (Cons ((101l), (Cons ((116l), Empty)))))));;

let rec data_open3 () = 
    (string_from_list (Cons ((111l), (Cons ((112l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_and3 () = 
    (string_from_list (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_or3 () = 
    (string_from_list (Cons ((111l), (Cons ((114l), Empty)))));;

let rec data_as3 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), Empty)))));;

let rec data_less_than3 () = 
    (string_from_list (Cons ((60l), Empty)));;

let rec data_assert3 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((115l), (Cons ((101l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_asr3 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_begin3 () = 
    (string_from_list (Cons ((98l), (Cons ((101l), (Cons ((103l), (Cons ((105l), (Cons ((110l), Empty)))))))))));;

let rec data_constraint3 () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((97l), (Cons ((105l), (Cons ((110l), (Cons ((116l), Empty)))))))))))))))))))));;

let rec data_do3 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), Empty)))));;

let rec data_done3 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((110l), (Cons ((101l), Empty)))))))));;

let rec data_downto3 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((119l), (Cons ((110l), (Cons ((116l), (Cons ((111l), Empty)))))))))))));;

let rec data_exception3 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((99l), (Cons ((101l), (Cons ((112l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))))));;

let rec data_external3 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((116l), (Cons ((101l), (Cons ((114l), (Cons ((110l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))))));;

let rec data_false3 () = 
    (string_from_list (Cons ((102l), (Cons ((97l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))))));;

let rec data_true4 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))));;

let rec data_for3 () = 
    (string_from_list (Cons ((102l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_function3 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))));;

let rec data_functor3 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), Empty)))))))))))))));;

let rec data_include3 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((99l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), Empty)))))))))))))));;

let rec data_inherit3 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((105l), (Cons ((116l), Empty)))))))))))))));;

let rec data_initializer3 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((97l), (Cons ((108l), (Cons ((105l), (Cons ((122l), (Cons ((101l), (Cons ((114l), Empty)))))))))))))))))))))));;

let rec data_land3 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))));;

let rec data_lazy3 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((122l), (Cons ((121l), Empty)))))))));;

let rec data_lor3 () = 
    (string_from_list (Cons ((108l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_lsl3 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((108l), Empty)))))));;

let rec data_lsr3 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_lxor3 () = 
    (string_from_list (Cons ((108l), (Cons ((120l), (Cons ((111l), (Cons ((114l), Empty)))))))));;

let rec data_method3 () = 
    (string_from_list (Cons ((109l), (Cons ((101l), (Cons ((116l), (Cons ((104l), (Cons ((111l), (Cons ((100l), Empty)))))))))))));;

let rec data_mod3 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), Empty)))))));;

let rec data_module3 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), Empty)))))))))))));;

let rec data_mutable3 () = 
    (string_from_list (Cons ((109l), (Cons ((117l), (Cons ((116l), (Cons ((97l), (Cons ((98l), (Cons ((108l), (Cons ((101l), Empty)))))))))))))));;

let rec data_new3 () = 
    (string_from_list (Cons ((110l), (Cons ((101l), (Cons ((119l), Empty)))))));;

let rec data_nonrec3 () = 
    (string_from_list (Cons ((110l), (Cons ((111l), (Cons ((110l), (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))))))))));;

let rec data_object3 () = 
    (string_from_list (Cons ((111l), (Cons ((98l), (Cons ((106l), (Cons ((101l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_private3 () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((105l), (Cons ((118l), (Cons ((97l), (Cons ((116l), (Cons ((101l), Empty)))))))))))))));;

let rec data_rec3 () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))));;

let rec data_sig3 () = 
    (string_from_list (Cons ((115l), (Cons ((105l), (Cons ((103l), Empty)))))));;

let rec data_struct3 () = 
    (string_from_list (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_try3 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((121l), Empty)))))));;

let rec data_val3 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), Empty)))))));;

let rec data_virtual3 () = 
    (string_from_list (Cons ((118l), (Cons ((105l), (Cons ((114l), (Cons ((116l), (Cons ((117l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))));;

let rec data_when3 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_while3 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((105l), (Cons ((108l), (Cons ((101l), Empty)))))))))));;

let rec data_parser3 () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((101l), (Cons ((114l), Empty)))))))))))));;

let rec data_value3 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), (Cons ((117l), (Cons ((101l), Empty)))))))))));;

let rec data_to3 () = 
    (string_from_list (Cons ((116l), (Cons ((111l), Empty)))));;

let rec data_def5 () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), Empty)))))));;

let rec data_typ5 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), Empty)))))));;

let rec data_fn5 () = 
    (string_from_list (Cons ((102l), (Cons ((110l), Empty)))));;

let rec data_match5 () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_exists5 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((115l), Empty)))))))))))));;

let rec data_pub5 () = 
    (string_from_list (Cons ((112l), (Cons ((117l), (Cons ((98l), Empty)))))));;

let rec data_16 () = 
    (string_from_list (Cons ((43l), Empty)));;

let rec data__3 () = 
    (string_from_list (Cons ((45l), Empty)));;

let rec data_17 () = 
    (string_from_list (Cons ((42l), Empty)));;

let rec data_18 () = 
    (string_from_list (Cons ((47l), Empty)));;

let rec data_19 () = 
    (string_from_list (Cons ((37l), Empty)));;

let rec data_20 () = 
    (string_from_list (Cons ((38l), Empty)));;

let rec data_int32_less_than3 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((45l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((45l), (Cons ((116l), (Cons ((104l), (Cons ((97l), (Cons ((110l), Empty)))))))))))))))))))))))))))))));;

let rec data_pipe4 () = 
    (string_from_list (Cons ((112l), (Cons ((105l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_dot4 () = 
    (string_from_list (Cons ((46l), Empty)));;

let rec data_list4 () = 
    (string_from_list (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), Empty)))))))));;

let rec data_slice_empty3 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((101l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), Empty)))))))))))))))))))))));;

let rec data_slice_of_u83 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((111l), (Cons ((102l), (Cons ((45l), (Cons ((117l), (Cons ((56l), Empty)))))))))))))))))))))));;

let rec data_slice_size3 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((105l), (Cons ((122l), (Cons ((101l), Empty)))))))))))))))))))));;

let rec data_slice_get3 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((103l), (Cons ((101l), (Cons ((116l), Empty)))))))))))))))))));;

let rec data_slice_concat3 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((99l), (Cons ((97l), (Cons ((116l), Empty)))))))))))))))))))))))));;

let rec data_slice_foldl3 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((102l), (Cons ((111l), (Cons ((108l), (Cons ((100l), (Cons ((108l), Empty)))))))))))))))))))))));;

let rec data_slice_subslice3 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((117l), (Cons ((98l), (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))))))))))))))))))))));;

let rec data_slice3 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))));;

let rec data_int324 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), Empty)))))))))));;

let rec data_compile_error2 () = 
    (string_from_list (Cons ((42l), (Cons ((99l), (Cons ((111l), (Cons ((109l), (Cons ((112l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((32l), (Cons ((101l), (Cons ((114l), (Cons ((114l), (Cons ((111l), (Cons ((114l), (Cons ((42l), Empty)))))))))))))))))))))))))))))));;

let rec data_javascript_language () = 
    (string_from_list (Cons ((106l), (Cons ((97l), (Cons ((118l), (Cons ((97l), (Cons ((115l), (Cons ((99l), (Cons ((114l), (Cons ((105l), (Cons ((112l), (Cons ((116l), Empty)))))))))))))))))))));;

let rec data_preamble_filename2 () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((109l), (Cons ((98l), (Cons ((108l), (Cons ((101l), (Cons ((46l), (Cons ((106l), (Cons ((115l), Empty)))))))))))))))))))))));;

let rec data_pervasives_filename2 () = 
    (string_from_list (Cons ((112l), (Cons ((101l), (Cons ((114l), (Cons ((118l), (Cons ((97l), (Cons ((115l), (Cons ((105l), (Cons ((118l), (Cons ((101l), (Cons ((115l), (Cons ((46l), (Cons ((106l), (Cons ((115l), Empty)))))))))))))))))))))))))));;

let rec data_int32_plus2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((97l), (Cons ((100l), (Cons ((100l), Empty)))))))))))))))))));;

let rec data_int32_multiply2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((109l), (Cons ((117l), (Cons ((108l), Empty)))))))))))))))))));;

let rec data_int32_minus2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((115l), (Cons ((117l), (Cons ((98l), Empty)))))))))))))))))));;

let rec data_int32_divide2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((100l), (Cons ((105l), (Cons ((118l), Empty)))))))))))))))))));;

let rec data_int32_modulus2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((109l), (Cons ((111l), (Cons ((100l), Empty)))))))))))))))))));;

let rec data_int32_and2 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((95l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))))))))))))));;

let rec data_slice4 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))));;

let rec data_trampoline () = 
    (string_from_list (Cons ((95l), (Cons ((116l), (Cons ((114l), (Cons ((97l), (Cons ((109l), (Cons ((112l), (Cons ((111l), (Cons ((108l), (Cons ((105l), (Cons ((110l), (Cons ((101l), Empty)))))))))))))))))))))));;

let rec data_return_value_marker () = 
    (string_from_list (Cons ((95l), (Cons ((107l), (Cons ((58l), Empty)))))));;

let rec data_tailcall () = 
    (string_from_list (Cons ((95l), (Cons ((116l), (Cons ((97l), (Cons ((105l), (Cons ((108l), (Cons ((99l), (Cons ((97l), (Cons ((108l), (Cons ((108l), Empty)))))))))))))))))));;

let rec data_var () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((114l), Empty)))))));;

let rec data_return () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((116l), (Cons ((117l), (Cons ((114l), (Cons ((110l), Empty)))))))))))));;

let rec data_function4 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))));;

let rec data_import2 () = 
    (string_from_list (Cons ((105l), (Cons ((109l), (Cons ((112l), (Cons ((111l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_default2 () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((97l), (Cons ((117l), (Cons ((108l), (Cons ((116l), Empty)))))))))))))));;

let rec data_case2 () = 
    (string_from_list (Cons ((99l), (Cons ((97l), (Cons ((115l), (Cons ((101l), Empty)))))))));;

let rec data_break () = 
    (string_from_list (Cons ((98l), (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((107l), Empty)))))))))));;

let rec data_const () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), Empty)))))))))));;

let rec data_continue () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((116l), (Cons ((105l), (Cons ((110l), (Cons ((117l), (Cons ((101l), Empty)))))))))))))))));;

let rec data_catch () = 
    (string_from_list (Cons ((99l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_debugger () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((98l), (Cons ((117l), (Cons ((103l), (Cons ((103l), (Cons ((101l), (Cons ((114l), Empty)))))))))))))))));;

let rec data_delete () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((108l), (Cons ((101l), (Cons ((116l), (Cons ((101l), Empty)))))))))))));;

let rec data_export () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((111l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_extends () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((116l), (Cons ((101l), (Cons ((110l), (Cons ((100l), (Cons ((115l), Empty)))))))))))))));;

let rec data_enum () = 
    (string_from_list (Cons ((101l), (Cons ((110l), (Cons ((117l), (Cons ((109l), Empty)))))))));;

let rec data_finally () = 
    (string_from_list (Cons ((102l), (Cons ((105l), (Cons ((110l), (Cons ((97l), (Cons ((108l), (Cons ((108l), (Cons ((121l), Empty)))))))))))))));;

let rec data_instanceof () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((97l), (Cons ((110l), (Cons ((99l), (Cons ((101l), (Cons ((111l), (Cons ((102l), Empty)))))))))))))))))))));;

let rec data_null () = 
    (string_from_list (Cons ((110l), (Cons ((117l), (Cons ((108l), (Cons ((108l), Empty)))))))));;

let rec data_super () = 
    (string_from_list (Cons ((115l), (Cons ((117l), (Cons ((112l), (Cons ((101l), (Cons ((114l), Empty)))))))))));;

let rec data_switch () = 
    (string_from_list (Cons ((115l), (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))))));;

let rec data_this () = 
    (string_from_list (Cons ((116l), (Cons ((104l), (Cons ((105l), (Cons ((115l), Empty)))))))));;

let rec data_throw () = 
    (string_from_list (Cons ((116l), (Cons ((104l), (Cons ((114l), (Cons ((111l), (Cons ((119l), Empty)))))))))));;

let rec data_typeof () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), (Cons ((111l), (Cons ((102l), Empty)))))))))))));;

let rec data_void () = 
    (string_from_list (Cons ((118l), (Cons ((111l), (Cons ((105l), (Cons ((100l), Empty)))))))));;

let rec data_await () = 
    (string_from_list (Cons ((97l), (Cons ((119l), (Cons ((97l), (Cons ((105l), (Cons ((116l), Empty)))))))))));;

let rec data_end_statement () = 
    (string_from_list (Cons ((59l), Empty)));;

let rec data_equals2 () = 
    (string_from_list (Cons ((61l), Empty)));;

let rec data_empty_object () = 
    (string_from_list (Cons ((123l), (Cons ((125l), Empty)))));;

let rec data_open_bracket3 () = 
    (string_from_list (Cons ((40l), Empty)));;

let rec data_close_bracket3 () = 
    (string_from_list (Cons ((41l), Empty)));;

let rec data_open_block () = 
    (string_from_list (Cons ((123l), Empty)));;

let rec data_close_block () = 
    (string_from_list (Cons ((125l), Empty)));;

let rec data_open_array () = 
    (string_from_list (Cons ((91l), Empty)));;

let rec data_close_array () = 
    (string_from_list (Cons ((93l), Empty)));;

let rec data_comma2 () = 
    (string_from_list (Cons ((44l), Empty)));;

let rec data_match_func () = 
    (string_from_list (Cons ((95l), (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))))));;

let rec data_capture () = 
    (string_from_list (Cons ((36l), Empty)));;

let rec data_question_mark () = 
    (string_from_list (Cons ((63l), Empty)));;

let rec data_colon2 () = 
    (string_from_list (Cons ((58l), Empty)));;

let rec data_lambda_arrow () = 
    (string_from_list (Cons ((32l), (Cons ((61l), (Cons ((62l), (Cons ((32l), Empty)))))))));;

let rec data_single_quote () = 
    (string_from_list (Cons ((39l), Empty)));;

let rec data_dot5 () = 
    (string_from_list (Cons ((46l), Empty)));;

let rec data_exports () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((111l), (Cons ((114l), (Cons ((116l), (Cons ((115l), Empty)))))))))))))));;

let rec data_moduleexports () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), (Cons ((46l), (Cons ((101l), (Cons ((120l), (Cons ((112l), (Cons ((111l), (Cons ((114l), (Cons ((116l), (Cons ((115l), (Cons ((46l), Empty)))))))))))))))))))))))))))))));;

let rec data_21 () = 
    (string_from_list (Cons ((125l), (Cons ((59l), Empty)))));;

let rec reserved_identifiers2 () = 
    (list_flatten (Cons ((Cons (data_var, (Cons (data_import2, (Cons (data_default2, (Cons (data_case2, (Cons (data_class3, (Cons (data_do3, Empty)))))))))))), (Cons ((Cons (data_else3, (Cons (data_false3, (Cons (data_for3, (Cons (data_function4, (Cons (data_if3, (Cons (data_in3, Empty)))))))))))), (Cons ((Cons (data_new3, (Cons (data_true4, (Cons (data_try3, (Cons (data_with3, (Cons (data_while3, (Cons (data_break, Empty)))))))))))), (Cons ((Cons (data_const, (Cons (data_continue, (Cons (data_catch, (Cons (data_debugger, (Cons (data_delete, Empty)))))))))), (Cons ((Cons (data_export, (Cons (data_extends, (Cons (data_enum, (Cons (data_finally, (Cons (data_instanceof, Empty)))))))))), (Cons ((Cons (data_null, (Cons (data_return, (Cons (data_super, (Cons (data_switch, (Cons (data_this, (Cons (data_throw, Empty)))))))))))), (Cons ((Cons (data_typeof, (Cons (data_void, (Cons (data_await, Empty)))))), Empty)))))))))))))));;

let rec escape_identifier2 identifier79 = 
    (SourceStringIdentifier (identifier79, IdentifierTransformationNone));;

let rec translate_constructor_identifier2 identifier80 = 
    (escape_identifier2 identifier80);;

let rec operator_translation_map2 () = 
    (dictionary_of (Cons ((Pair ((data_16 ()), (SourceString ((data_int32_plus2 ()))))), (Cons ((Pair ((data__3 ()), (SourceString ((data_int32_minus2 ()))))), (Cons ((Pair ((data_17 ()), (SourceString ((data_int32_multiply2 ()))))), (Cons ((Pair ((data_18 ()), (SourceString ((data_int32_divide2 ()))))), (Cons ((Pair ((data_19 ()), (SourceString ((data_int32_modulus2 ()))))), (Cons ((Pair ((data_20 ()), (SourceString ((data_int32_and2 ()))))), Empty)))))))))))));;

let rec translate_identifier2 identifier81 = 
    (match (token_is_operator (identifier_token identifier81)) with
         | True -> 
            (match (dictionary_get (identifier_name identifier81) (operator_translation_map2 ())) with
                 | (Some (translation2)) -> 
                    translation2
                 | None -> 
                    (escape_identifier2 identifier81))
         | False -> 
            (escape_identifier2 identifier81));;

let rec translate_less_than2 translate_expression8 expressions38 = 
    (match expressions38 with
         | (Cons (a73, (Cons (b68, (Cons (then_case2, (Cons (else_case2, Empty)))))))) -> 
            (wrap_in_brackets2 (join (Cons ((translate_expression8 a73), (Cons ((SourceString ((data_less_than3 ()))), (Cons ((translate_expression8 b68), (Cons ((SourceString ((data_space3 ()))), (Cons ((SourceString ((data_question_mark ()))), (Cons ((SourceString ((data_space3 ()))), (Cons ((translate_expression8 then_case2), (Cons ((SourceString ((data_space3 ()))), (Cons ((SourceString ((data_colon2 ()))), (Cons ((SourceString ((data_space3 ()))), (Cons ((translate_expression8 else_case2), Empty))))))))))))))))))))))))
         | x547 -> 
            (SourceString ((data_compile_error2 ()))));;

let rec wrap_in_angle_brackets s4 = 
    (join (Cons ((SourceString ((data_open_array ()))), (Cons (s4, (Cons ((SourceString ((data_close_array ()))), Empty)))))));;

let rec translate_constructor2 translator2 identifier82 constructor15 = 
    (wrap_in_angle_brackets ((source_string_join (string_concat (data_comma2 ()) (string_of_char (32l)))) ((list_cons (translate_constructor_identifier2 identifier82)) ((list_map translator2) constructor15))));;

let rec translate_pattern2 pattern15 = 
    (match pattern15 with
         | (Capture (x548)) -> 
            (SourceString ((data_capture ())))
         | (IntegerPattern (integer11, x549)) -> 
            (SourceString ((string_from_int32 integer11)))
         | (ConstructorPattern (identifier83, Empty, x550)) -> 
            (translate_constructor_identifier2 identifier83)
         | (ConstructorPattern (identifier84, patterns6, x551)) -> 
            (translate_constructor2 translate_pattern2 identifier84 patterns6));;

let rec translate_captures pattern16 = 
    (match pattern16 with
         | (Capture (identifier85)) -> 
            (Cons ((escape_identifier2 identifier85), Empty))
         | (IntegerPattern (x552, x553)) -> 
            (list_empty ())
         | (ConstructorPattern (x554, patterns7, x555)) -> 
            (list_flatmap translate_captures patterns7));;

let rec translate_rule2 n15 translate_expression9 rule4 = 
    (match rule4 with
         | (Pair (pattern17, expression67)) -> 
            (join_lines (Cons (((line n15) (Cons ((translate_pattern2 pattern17), (Cons ((SourceString ((data_comma2 ()))), (Cons ((source_space ()), (Cons ((wrap_in_brackets2 (source_string_join (string_concat (data_comma2 ()) (string_of_char (32l))) (translate_captures pattern17))), (Cons ((SourceString ((data_lambda_arrow ()))), Empty))))))))))), (Cons (((line (Int32.add n15 (1l))) (Cons ((translate_expression9 (Int32.add n15 (1l)) expression67), Empty))), Empty))))));;

let rec translate_match_expression2 n16 translate_expression10 translate_rule3 expression68 rules11 = 
    ((source_string_join (string_empty ())) (Cons ((SourceString ((data_match_func ()))), (Cons ((SourceString ((data_open_bracket3 ()))), (Cons ((translate_expression10 n16 expression68), (Cons ((SourceString ((data_comma2 ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_open_array ()))), (Cons ((source_string_join (data_comma2 ()) (list_map (translate_rule3 (Int32.add n16 (1l)) translate_expression10) rules11)), (Cons ((SourceString ((data_close_array ()))), (Cons ((SourceString ((data_close_bracket3 ()))), Empty)))))))))))))))))));;

let rec translate_function_application3 translate_expression11 expressions39 = 
    (match expressions39 with
         | (Cons (function2, Empty)) -> 
            (join (Cons ((translate_expression11 function2), (Cons ((wrap_in_brackets2 (source_string_empty ())), Empty)))))
         | (Cons (function3, args)) -> 
            (join (Cons ((translate_expression11 function3), (Cons ((join (list_map (fun x51 -> (wrap_in_brackets2 (translate_expression11 x51))) args)), Empty)))))
         | Empty -> 
            (SourceString ((data_compile_error2 ()))));;

let rec translate_function_application4 translate_expression12 expressions40 = 
    (match expressions40 with
         | (Cons ((Variable (identifier86)), rest33)) -> 
            (match (x4 (identifier_token identifier86) (identifier_int32_less_than ())) with
                 | True -> 
                    (translate_less_than2 translate_expression12 rest33)
                 | False -> 
                    (translate_function_application3 translate_expression12 expressions40))
         | x556 -> 
            (translate_function_application3 translate_expression12 expressions40));;

let rec translate_argument_list2 arguments27 = 
    (match (list_is_empty arguments27) with
         | True -> 
            (wrap_in_brackets2 (source_string_empty ()))
         | False -> 
            (source_string_join (data_lambda_arrow ()) (list_map escape_identifier2 arguments27)));;

let rec translate_lambda2 translate_expression13 arguments28 expression69 = 
    (join (Cons ((translate_argument_list2 arguments28), (Cons ((SourceString ((data_lambda_arrow ()))), (Cons ((translate_expression13 expression69), Empty)))))));;

let rec translate_expression14 n17 expression70 = 
    (match expression70 with
         | (Lambda (arguments29, expression71, x557)) -> 
            (wrap_in_brackets2 (translate_lambda2 (translate_expression14 n17) arguments29 expression71))
         | (Constructor (identifier87, Empty, x558)) -> 
            (translate_constructor_identifier2 identifier87)
         | (Constructor (identifier88, expressions41, x559)) -> 
            ((translate_constructor2 (translate_expression14 n17) identifier88) expressions41)
         | (FunctionApplication (expressions42, x560)) -> 
            (translate_function_application4 (translate_expression14 n17) expressions42)
         | (IntegerConstant (integer12, x561)) -> 
            (SourceString ((string_from_int32 integer12)))
         | (Variable (identifier89)) -> 
            (translate_identifier2 identifier89)
         | (Match (expression72, rules12, x562)) -> 
            (translate_match_expression2 n17 translate_expression14 translate_rule2 expression72 rules12));;

let rec mark_as_return_value source2 = 
    (join (Cons ((SourceString ((data_open_bracket3 ()))), (Cons ((SourceString ((data_open_block ()))), (Cons ((SourceString ((data_return_value_marker ()))), (Cons (source2, (Cons ((SourceString ((data_close_block ()))), (Cons ((SourceString ((data_close_bracket3 ()))), Empty)))))))))))));;

let rec identifier_in_captures identifier90 rule5 = 
    (list_any (identifier_equal identifier90) (captured_identifiers_from_pattern (pair_left rule5)));;

let rec translate_tail_recursive_match_rule name76 translate_tail_recursive_function n18 translate_expression15 rule6 = 
    (match (identifier_in_captures name76 rule6) with
         | True -> 
            (translate_rule2 n18 translate_expression15 rule6)
         | False -> 
            (translate_rule2 n18 (translate_tail_recursive_function name76) rule6));;

let rec translate_tail_recursive_function2 name77 n19 expression73 = 
    (match expression73 with
         | (FunctionApplication ((Cons ((Variable (applied_name2)), arguments30)), range126)) -> 
            (match (identifier_equal name77 applied_name2) with
                 | True -> 
                    (mark_as_return_value ((source_string_join (string_empty ())) (Cons ((SourceString ((data_open_bracket3 ()))), (Cons ((SourceString ((data_close_bracket3 ()))), (Cons ((SourceString ((data_lambda_arrow ()))), (Cons ((SourceString ((data_tailcall ()))), (Cons ((source_space ()), (Cons ((join (list_map (fun x51 -> (wrap_in_brackets2 ((translate_expression14 n19) x51))) arguments30)), Empty))))))))))))))
                 | False -> 
                    (translate_expression14 n19 expression73))
         | (Match (expression74, rules13, range127)) -> 
            (translate_match_expression2 n19 translate_expression14 (translate_tail_recursive_match_rule name77 translate_tail_recursive_function2) expression74 rules13)
         | x563 -> 
            (translate_expression14 n19 expression73));;

let rec tail_recursive_function identifier91 arguments31 expression75 = 
    (and2 (list_every (fun x51 -> (not ((identifier_equal identifier91) x51))) arguments31) (expression_calls_function_in_tail_position identifier91 expression75));;

let rec translate_main_function_definition identifier92 arguments32 expression76 = 
    (match (tail_recursive_function identifier92 arguments32 expression76) with
         | True -> 
            ((source_string_join (newline ())) (Cons (((line (0l)) (Cons ((SourceString ((data_var ()))), (Cons ((source_space ()), (Cons ((escape_identifier2 identifier92), (Cons ((source_space ()), (Cons ((SourceString ((data_equals2 ()))), (Cons ((source_space ()), (Cons ((translate_argument_list2 arguments32), (Cons ((SourceString ((data_lambda_arrow ()))), (Cons ((SourceString ((data_open_block ()))), Empty))))))))))))))))))), (Cons (((line (1l)) (Cons ((SourceString ((data_var ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_tailcall ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_equals2 ()))), (Cons ((source_space ()), (Cons ((translate_argument_list2 arguments32), (Cons ((SourceString ((data_lambda_arrow ()))), Empty))))))))))))))))), (Cons (((line (2l)) (Cons ((source_string_concat (translate_tail_recursive_function2 identifier92 (2l) expression76) (SourceString ((data_end_statement ())))), Empty))), (Cons (((line (1l)) (Cons ((SourceString ((data_return ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_trampoline ()))), (Cons ((SourceString ((data_open_bracket3 ()))), (Cons ((SourceString ((data_tailcall ()))), (Cons ((source_string_join (string_empty ()) (list_map (fun x51 -> (wrap_in_brackets2 (escape_identifier2 x51))) arguments32)), (Cons ((SourceString ((data_close_bracket3 ()))), (Cons ((SourceString ((data_end_statement ()))), Empty))))))))))))))))), (Cons (((line (0l)) (Cons ((SourceString ((data_21 ()))), Empty))), Empty)))))))))))
         | False -> 
            ((source_string_join (newline ())) (Cons (((line (0l)) (Cons ((SourceString ((data_var ()))), (Cons ((source_space ()), (Cons ((escape_identifier2 identifier92), (Cons ((source_space ()), (Cons ((SourceString ((data_equals2 ()))), (Cons ((source_space ()), (Cons ((translate_argument_list2 arguments32), (Cons ((SourceString ((data_lambda_arrow ()))), Empty))))))))))))))))), (Cons (((line (1l)) (Cons ((translate_expression14 (1l) expression76), (Cons ((SourceString ((data_end_statement ()))), Empty))))), Empty))))));;

let rec translate_export_statement identifier93 arguments33 = 
    ((line (0l)) (Cons ((SourceString ((data_moduleexports ()))), (Cons ((escape_identifier2 identifier93), (Cons ((source_space ()), (Cons ((SourceString ((data_equals2 ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_open_bracket3 ()))), (Cons ((source_string_join (data_comma2 ()) (list_map escape_identifier2 arguments33)), (Cons ((SourceString ((data_close_bracket3 ()))), (Cons ((SourceString ((data_lambda_arrow ()))), (Cons ((escape_identifier2 identifier93), (Cons ((match (list_is_empty arguments33) with
         | True -> 
            (wrap_in_brackets2 SourceStringEmpty)
         | False -> 
            (source_string_join (string_empty ()) (list_map (fun x51 -> (wrap_in_brackets2 (escape_identifier2 x51))) arguments33))), (Cons ((SourceString ((data_end_statement ()))), Empty)))))))))))))))))))))))));;

let rec translate_function_definition2 identifier94 public13 arguments34 expression77 = 
    ((source_string_join (newline ())) (list_flatten (Cons ((Cons ((translate_main_function_definition identifier94 arguments34 expression77), Empty)), (Cons ((match public13 with
         | True -> 
            (Cons ((translate_export_statement identifier94 arguments34), Empty))
         | False -> 
            Empty), Empty))))));;

let rec constructor_identifier2 constructor16 = 
    (match constructor16 with
         | (SimpleConstructor (identifier95)) -> 
            identifier95
         | (ComplexConstructor (identifier96, x564, x565)) -> 
            identifier96);;

let rec translate_constructor_definition2 public14 constructor17 = 
    (match (translate_constructor_identifier2 (constructor_identifier2 constructor17)) with
         | identifier97 -> 
            ((line (0l)) (list_concat (Cons ((SourceString ((data_var ()))), (Cons ((source_space ()), (Cons (identifier97, (Cons ((source_space ()), (Cons ((SourceString ((data_equals2 ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_open_block ()))), (Cons ((source_space ()), (Cons (identifier97, (Cons ((SourceString ((data_colon2 ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_true4 ()))), (Cons ((source_space ()), (Cons ((SourceString ((data_close_block ()))), (Cons ((SourceString ((data_end_statement ()))), Empty)))))))))))))))))))))))))))))) (match public14 with
                 | True -> 
                    (Cons ((SourceString ((newline ()))), (Cons ((SourceString ((data_moduleexports ()))), (Cons (identifier97, (Cons ((source_space ()), (Cons ((SourceString ((data_equals2 ()))), (Cons ((source_space ()), (Cons (identifier97, (Cons ((SourceString ((data_end_statement ()))), Empty))))))))))))))))
                 | False -> 
                    Empty))));;

let rec translate_type_definition2 name78 public15 parameters23 constructors23 = 
    (source_string_join (string_of_char (10l)) (list_map (translate_constructor_definition2 public15) constructors23));;

let rec translate_definition2 definition20 = 
    (match definition20 with
         | (FunctionDefinition (identifier98, public16, arguments35, expression78, x566)) -> 
            (translate_function_definition2 identifier98 public16 arguments35 expression78)
         | (TypeDefinition (name79, public17, parameters24, constructors24, x567)) -> 
            (translate_type_definition2 name79 public17 parameters24 constructors24)
         | (TargetDefinition (x568, data3)) -> 
            (SourceString ((string_from_slice data3))));;

let rec generate_source2 module_name5 definitions20 = 
    ((pair_cons (list_map (pair_cons IdentifierTransformationNone) (public_identifiers definitions20))) ((source_string_join (string_repeat (string_of_char (10l)) (2l))) ((list_map translate_definition2) definitions20)));;

let rec compiler_backend_javascript () = 
    (Backend ((data_javascript_language ()), (Cons ((data_preamble_filename2 ()), Empty)), (Cons ((data_pervasives_filename2 ()), Empty)), generate_source2, (reserved_identifiers2 ()), (fun x51 -> (local_transforms (validate_reserved_identifiers x51)))));;

let rec data_space4 () = 
    (string_from_list (Cons ((32l), Empty)));;

let rec data_fun4 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), Empty)))))));;

let rec data_type4 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_if4 () = 
    (string_from_list (Cons ((105l), (Cons ((102l), Empty)))));;

let rec data_then4 () = 
    (string_from_list (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_else4 () = 
    (string_from_list (Cons ((101l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))));;

let rec data_with4 () = 
    (string_from_list (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((104l), Empty)))))))));;

let rec data_of4 () = 
    (string_from_list (Cons ((111l), (Cons ((102l), Empty)))));;

let rec data_class4 () = 
    (string_from_list (Cons ((99l), (Cons ((108l), (Cons ((97l), (Cons ((115l), (Cons ((115l), Empty)))))))))));;

let rec data_end4 () = 
    (string_from_list (Cons ((101l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_in4 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), Empty)))));;

let rec data_let4 () = 
    (string_from_list (Cons ((108l), (Cons ((101l), (Cons ((116l), Empty)))))));;

let rec data_open4 () = 
    (string_from_list (Cons ((111l), (Cons ((112l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_and4 () = 
    (string_from_list (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_or4 () = 
    (string_from_list (Cons ((111l), (Cons ((114l), Empty)))));;

let rec data_as4 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), Empty)))));;

let rec data_less_than4 () = 
    (string_from_list (Cons ((60l), Empty)));;

let rec data_assert4 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((115l), (Cons ((101l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_asr4 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_begin4 () = 
    (string_from_list (Cons ((98l), (Cons ((101l), (Cons ((103l), (Cons ((105l), (Cons ((110l), Empty)))))))))));;

let rec data_constraint4 () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((97l), (Cons ((105l), (Cons ((110l), (Cons ((116l), Empty)))))))))))))))))))));;

let rec data_do4 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), Empty)))));;

let rec data_done4 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((110l), (Cons ((101l), Empty)))))))));;

let rec data_downto4 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((119l), (Cons ((110l), (Cons ((116l), (Cons ((111l), Empty)))))))))))));;

let rec data_exception4 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((99l), (Cons ((101l), (Cons ((112l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))))));;

let rec data_external4 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((116l), (Cons ((101l), (Cons ((114l), (Cons ((110l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))))));;

let rec data_false4 () = 
    (string_from_list (Cons ((102l), (Cons ((97l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))))));;

let rec data_true5 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))));;

let rec data_for4 () = 
    (string_from_list (Cons ((102l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_function5 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))));;

let rec data_functor4 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), Empty)))))))))))))));;

let rec data_include4 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((99l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), Empty)))))))))))))));;

let rec data_inherit4 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((105l), (Cons ((116l), Empty)))))))))))))));;

let rec data_initializer4 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((97l), (Cons ((108l), (Cons ((105l), (Cons ((122l), (Cons ((101l), (Cons ((114l), Empty)))))))))))))))))))))));;

let rec data_land4 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))));;

let rec data_lazy4 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((122l), (Cons ((121l), Empty)))))))));;

let rec data_lor4 () = 
    (string_from_list (Cons ((108l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_lsl4 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((108l), Empty)))))));;

let rec data_lsr4 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_lxor4 () = 
    (string_from_list (Cons ((108l), (Cons ((120l), (Cons ((111l), (Cons ((114l), Empty)))))))));;

let rec data_method4 () = 
    (string_from_list (Cons ((109l), (Cons ((101l), (Cons ((116l), (Cons ((104l), (Cons ((111l), (Cons ((100l), Empty)))))))))))));;

let rec data_mod4 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), Empty)))))));;

let rec data_module4 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), Empty)))))))))))));;

let rec data_mutable4 () = 
    (string_from_list (Cons ((109l), (Cons ((117l), (Cons ((116l), (Cons ((97l), (Cons ((98l), (Cons ((108l), (Cons ((101l), Empty)))))))))))))));;

let rec data_new4 () = 
    (string_from_list (Cons ((110l), (Cons ((101l), (Cons ((119l), Empty)))))));;

let rec data_nonrec4 () = 
    (string_from_list (Cons ((110l), (Cons ((111l), (Cons ((110l), (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))))))))));;

let rec data_object4 () = 
    (string_from_list (Cons ((111l), (Cons ((98l), (Cons ((106l), (Cons ((101l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_private4 () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((105l), (Cons ((118l), (Cons ((97l), (Cons ((116l), (Cons ((101l), Empty)))))))))))))));;

let rec data_rec4 () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))));;

let rec data_sig4 () = 
    (string_from_list (Cons ((115l), (Cons ((105l), (Cons ((103l), Empty)))))));;

let rec data_struct4 () = 
    (string_from_list (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_try4 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((121l), Empty)))))));;

let rec data_val4 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), Empty)))))));;

let rec data_virtual4 () = 
    (string_from_list (Cons ((118l), (Cons ((105l), (Cons ((114l), (Cons ((116l), (Cons ((117l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))));;

let rec data_when4 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_while4 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((105l), (Cons ((108l), (Cons ((101l), Empty)))))))))));;

let rec data_parser4 () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((101l), (Cons ((114l), Empty)))))))))))));;

let rec data_value4 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), (Cons ((117l), (Cons ((101l), Empty)))))))))));;

let rec data_to4 () = 
    (string_from_list (Cons ((116l), (Cons ((111l), Empty)))));;

let rec data_def6 () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), Empty)))))));;

let rec data_typ6 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), Empty)))))));;

let rec data_fn6 () = 
    (string_from_list (Cons ((102l), (Cons ((110l), Empty)))));;

let rec data_match6 () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_exists6 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((115l), Empty)))))))))))));;

let rec data_pub6 () = 
    (string_from_list (Cons ((112l), (Cons ((117l), (Cons ((98l), Empty)))))));;

let rec data_22 () = 
    (string_from_list (Cons ((43l), Empty)));;

let rec data__4 () = 
    (string_from_list (Cons ((45l), Empty)));;

let rec data_23 () = 
    (string_from_list (Cons ((42l), Empty)));;

let rec data_24 () = 
    (string_from_list (Cons ((47l), Empty)));;

let rec data_25 () = 
    (string_from_list (Cons ((37l), Empty)));;

let rec data_26 () = 
    (string_from_list (Cons ((38l), Empty)));;

let rec data_int32_less_than4 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((45l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((45l), (Cons ((116l), (Cons ((104l), (Cons ((97l), (Cons ((110l), Empty)))))))))))))))))))))))))))))));;

let rec data_pipe5 () = 
    (string_from_list (Cons ((112l), (Cons ((105l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_dot6 () = 
    (string_from_list (Cons ((46l), Empty)));;

let rec data_list5 () = 
    (string_from_list (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), Empty)))))))));;

let rec data_slice_empty4 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((101l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), Empty)))))))))))))))))))))));;

let rec data_slice_of_u84 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((111l), (Cons ((102l), (Cons ((45l), (Cons ((117l), (Cons ((56l), Empty)))))))))))))))))))))));;

let rec data_slice_size4 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((105l), (Cons ((122l), (Cons ((101l), Empty)))))))))))))))))))));;

let rec data_slice_get4 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((103l), (Cons ((101l), (Cons ((116l), Empty)))))))))))))))))));;

let rec data_slice_concat4 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((99l), (Cons ((97l), (Cons ((116l), Empty)))))))))))))))))))))))));;

let rec data_slice_foldl4 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((102l), (Cons ((111l), (Cons ((108l), (Cons ((100l), (Cons ((108l), Empty)))))))))))))))))))))));;

let rec data_slice_subslice4 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((117l), (Cons ((98l), (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))))))))))))))))))))));;

let rec data_slice5 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))));;

let rec data_int325 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), Empty)))))))))));;

let rec data_preamble_filename3 () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((109l), (Cons ((98l), (Cons ((108l), (Cons ((101l), (Cons ((46l), (Cons ((114l), (Cons ((101l), (Cons ((117l), (Cons ((115l), (Cons ((101l), Empty)))))))))))))))))))))))))))));;

let rec data_pervasives_filename3 () = 
    (string_from_list (Cons ((112l), (Cons ((101l), (Cons ((114l), (Cons ((118l), (Cons ((97l), (Cons ((115l), (Cons ((105l), (Cons ((118l), (Cons ((101l), (Cons ((115l), (Cons ((46l), (Cons ((114l), (Cons ((101l), (Cons ((117l), (Cons ((115l), (Cons ((101l), Empty)))))))))))))))))))))))))))))))));;

let rec data_module_language () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), Empty)))))))))))));;

let rec generate_source3 module_name6 definitions21 = 
    ((pair_cons (list_empty ())) (source_string_string ((string_join (string_of_char (10l))) ((list_map (fun x51 -> (stringify_sexp (definition_to_sexp x51)))) ((list_filter (fun x51 -> ((module_equal ModuleSelf) (definition_module x51)))) definitions21)))));;

let rec compiler_backend_module () = 
    (Backend ((data_module_language ()), Empty, Empty, generate_source3, Empty, (result_map id)));;

let rec data_space5 () = 
    (string_from_list (Cons ((32l), Empty)));;

let rec data_fun5 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), Empty)))))));;

let rec data_type5 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_if5 () = 
    (string_from_list (Cons ((105l), (Cons ((102l), Empty)))));;

let rec data_then5 () = 
    (string_from_list (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_else5 () = 
    (string_from_list (Cons ((101l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))));;

let rec data_with5 () = 
    (string_from_list (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((104l), Empty)))))))));;

let rec data_of5 () = 
    (string_from_list (Cons ((111l), (Cons ((102l), Empty)))));;

let rec data_class5 () = 
    (string_from_list (Cons ((99l), (Cons ((108l), (Cons ((97l), (Cons ((115l), (Cons ((115l), Empty)))))))))));;

let rec data_end5 () = 
    (string_from_list (Cons ((101l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_in5 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), Empty)))));;

let rec data_let5 () = 
    (string_from_list (Cons ((108l), (Cons ((101l), (Cons ((116l), Empty)))))));;

let rec data_open5 () = 
    (string_from_list (Cons ((111l), (Cons ((112l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_and5 () = 
    (string_from_list (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))));;

let rec data_or5 () = 
    (string_from_list (Cons ((111l), (Cons ((114l), Empty)))));;

let rec data_as5 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), Empty)))));;

let rec data_less_than5 () = 
    (string_from_list (Cons ((60l), Empty)));;

let rec data_assert5 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((115l), (Cons ((101l), (Cons ((114l), (Cons ((116l), Empty)))))))))))));;

let rec data_asr5 () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_begin5 () = 
    (string_from_list (Cons ((98l), (Cons ((101l), (Cons ((103l), (Cons ((105l), (Cons ((110l), Empty)))))))))));;

let rec data_constraint5 () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((97l), (Cons ((105l), (Cons ((110l), (Cons ((116l), Empty)))))))))))))))))))));;

let rec data_do5 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), Empty)))));;

let rec data_done5 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((110l), (Cons ((101l), Empty)))))))));;

let rec data_downto5 () = 
    (string_from_list (Cons ((100l), (Cons ((111l), (Cons ((119l), (Cons ((110l), (Cons ((116l), (Cons ((111l), Empty)))))))))))));;

let rec data_exception5 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((99l), (Cons ((101l), (Cons ((112l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))))));;

let rec data_external5 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((116l), (Cons ((101l), (Cons ((114l), (Cons ((110l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))))));;

let rec data_false5 () = 
    (string_from_list (Cons ((102l), (Cons ((97l), (Cons ((108l), (Cons ((115l), (Cons ((101l), Empty)))))))))));;

let rec data_true6 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))));;

let rec data_for5 () = 
    (string_from_list (Cons ((102l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_function6 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))));;

let rec data_functor5 () = 
    (string_from_list (Cons ((102l), (Cons ((117l), (Cons ((110l), (Cons ((99l), (Cons ((116l), (Cons ((111l), (Cons ((114l), Empty)))))))))))))));;

let rec data_include5 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((99l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), Empty)))))))))))))));;

let rec data_inherit5 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((104l), (Cons ((101l), (Cons ((114l), (Cons ((105l), (Cons ((116l), Empty)))))))))))))));;

let rec data_initializer5 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((97l), (Cons ((108l), (Cons ((105l), (Cons ((122l), (Cons ((101l), (Cons ((114l), Empty)))))))))))))))))))))));;

let rec data_land5 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))));;

let rec data_lazy5 () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((122l), (Cons ((121l), Empty)))))))));;

let rec data_lor5 () = 
    (string_from_list (Cons ((108l), (Cons ((111l), (Cons ((114l), Empty)))))));;

let rec data_lsl5 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((108l), Empty)))))));;

let rec data_lsr5 () = 
    (string_from_list (Cons ((108l), (Cons ((115l), (Cons ((114l), Empty)))))));;

let rec data_lxor5 () = 
    (string_from_list (Cons ((108l), (Cons ((120l), (Cons ((111l), (Cons ((114l), Empty)))))))));;

let rec data_method5 () = 
    (string_from_list (Cons ((109l), (Cons ((101l), (Cons ((116l), (Cons ((104l), (Cons ((111l), (Cons ((100l), Empty)))))))))))));;

let rec data_mod5 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), Empty)))))));;

let rec data_module5 () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), Empty)))))))))))));;

let rec data_mutable5 () = 
    (string_from_list (Cons ((109l), (Cons ((117l), (Cons ((116l), (Cons ((97l), (Cons ((98l), (Cons ((108l), (Cons ((101l), Empty)))))))))))))));;

let rec data_new5 () = 
    (string_from_list (Cons ((110l), (Cons ((101l), (Cons ((119l), Empty)))))));;

let rec data_nonrec5 () = 
    (string_from_list (Cons ((110l), (Cons ((111l), (Cons ((110l), (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))))))))));;

let rec data_object5 () = 
    (string_from_list (Cons ((111l), (Cons ((98l), (Cons ((106l), (Cons ((101l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_private5 () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((105l), (Cons ((118l), (Cons ((97l), (Cons ((116l), (Cons ((101l), Empty)))))))))))))));;

let rec data_rec5 () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((99l), Empty)))))));;

let rec data_sig5 () = 
    (string_from_list (Cons ((115l), (Cons ((105l), (Cons ((103l), Empty)))))));;

let rec data_struct5 () = 
    (string_from_list (Cons ((115l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((99l), (Cons ((116l), Empty)))))))))))));;

let rec data_try5 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((121l), Empty)))))));;

let rec data_val5 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), Empty)))))));;

let rec data_virtual5 () = 
    (string_from_list (Cons ((118l), (Cons ((105l), (Cons ((114l), (Cons ((116l), (Cons ((117l), (Cons ((97l), (Cons ((108l), Empty)))))))))))))));;

let rec data_when5 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((101l), (Cons ((110l), Empty)))))))));;

let rec data_while5 () = 
    (string_from_list (Cons ((119l), (Cons ((104l), (Cons ((105l), (Cons ((108l), (Cons ((101l), Empty)))))))))));;

let rec data_parser5 () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((101l), (Cons ((114l), Empty)))))))))))));;

let rec data_value5 () = 
    (string_from_list (Cons ((118l), (Cons ((97l), (Cons ((108l), (Cons ((117l), (Cons ((101l), Empty)))))))))));;

let rec data_to5 () = 
    (string_from_list (Cons ((116l), (Cons ((111l), Empty)))));;

let rec data_def7 () = 
    (string_from_list (Cons ((100l), (Cons ((101l), (Cons ((102l), Empty)))))));;

let rec data_typ7 () = 
    (string_from_list (Cons ((116l), (Cons ((121l), (Cons ((112l), Empty)))))));;

let rec data_fn7 () = 
    (string_from_list (Cons ((102l), (Cons ((110l), Empty)))));;

let rec data_match7 () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((99l), (Cons ((104l), Empty)))))))))));;

let rec data_exists7 () = 
    (string_from_list (Cons ((101l), (Cons ((120l), (Cons ((105l), (Cons ((115l), (Cons ((116l), (Cons ((115l), Empty)))))))))))));;

let rec data_pub7 () = 
    (string_from_list (Cons ((112l), (Cons ((117l), (Cons ((98l), Empty)))))));;

let rec data_27 () = 
    (string_from_list (Cons ((43l), Empty)));;

let rec data__5 () = 
    (string_from_list (Cons ((45l), Empty)));;

let rec data_28 () = 
    (string_from_list (Cons ((42l), Empty)));;

let rec data_29 () = 
    (string_from_list (Cons ((47l), Empty)));;

let rec data_30 () = 
    (string_from_list (Cons ((37l), Empty)));;

let rec data_31 () = 
    (string_from_list (Cons ((38l), Empty)));;

let rec data_int32_less_than5 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((45l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((115l), (Cons ((45l), (Cons ((116l), (Cons ((104l), (Cons ((97l), (Cons ((110l), Empty)))))))))))))))))))))))))))))));;

let rec data_pipe6 () = 
    (string_from_list (Cons ((112l), (Cons ((105l), (Cons ((112l), (Cons ((101l), Empty)))))))));;

let rec data_dot7 () = 
    (string_from_list (Cons ((46l), Empty)));;

let rec data_list6 () = 
    (string_from_list (Cons ((108l), (Cons ((105l), (Cons ((115l), (Cons ((116l), Empty)))))))));;

let rec data_slice_empty5 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((101l), (Cons ((109l), (Cons ((112l), (Cons ((116l), (Cons ((121l), Empty)))))))))))))))))))))));;

let rec data_slice_of_u85 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((111l), (Cons ((102l), (Cons ((45l), (Cons ((117l), (Cons ((56l), Empty)))))))))))))))))))))));;

let rec data_slice_size5 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((105l), (Cons ((122l), (Cons ((101l), Empty)))))))))))))))))))));;

let rec data_slice_get5 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((103l), (Cons ((101l), (Cons ((116l), Empty)))))))))))))))))));;

let rec data_slice_concat5 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((99l), (Cons ((97l), (Cons ((116l), Empty)))))))))))))))))))))))));;

let rec data_slice_foldl5 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((102l), (Cons ((111l), (Cons ((108l), (Cons ((100l), (Cons ((108l), Empty)))))))))))))))))))))));;

let rec data_slice_subslice5 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), (Cons ((45l), (Cons ((115l), (Cons ((117l), (Cons ((98l), (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))))))))))))))))))))));;

let rec data_slice6 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))));;

let rec data_int326 () = 
    (string_from_list (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), Empty)))))))))));;

let rec data_compile_error3 () = 
    (string_from_list (Cons ((42l), (Cons ((99l), (Cons ((111l), (Cons ((109l), (Cons ((112l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((32l), (Cons ((101l), (Cons ((114l), (Cons ((114l), (Cons ((111l), (Cons ((114l), (Cons ((42l), Empty)))))))))))))))))))))))))))))));;

let rec data_arrow2 () = 
    (string_from_list (Cons ((32l), (Cons ((45l), (Cons ((62l), (Cons ((32l), Empty)))))))));;

let rec data_equals3 () = 
    (string_from_list (Cons ((32l), (Cons ((61l), (Cons ((32l), Empty)))))));;

let rec data_vertical_bar2 () = 
    (string_from_list (Cons ((32l), (Cons ((124l), (Cons ((32l), Empty)))))));;

let rec data_pipe_operator2 () = 
    (string_from_list (Cons ((32l), (Cons ((124l), (Cons ((62l), (Cons ((32l), Empty)))))))));;

let rec data_colon3 () = 
    (string_from_list (Cons ((32l), (Cons ((58l), (Cons ((32l), Empty)))))));;

let rec data_star2 () = 
    (string_from_list (Cons ((32l), (Cons ((42l), (Cons ((32l), Empty)))))));;

let rec data_unit () = 
    (string_from_list (Cons ((32l), (Cons ((117l), (Cons ((110l), (Cons ((105l), (Cons ((116l), (Cons ((32l), Empty)))))))))))));;

let rec data_int32_plus3 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((46l), (Cons ((97l), (Cons ((100l), (Cons ((100l), Empty)))))))))))))))))));;

let rec data_int32_multiply3 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((46l), (Cons ((109l), (Cons ((117l), (Cons ((108l), Empty)))))))))))))))))));;

let rec data_int32_minus3 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((46l), (Cons ((115l), (Cons ((117l), (Cons ((98l), Empty)))))))))))))))))));;

let rec data_int32_divide3 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((46l), (Cons ((100l), (Cons ((105l), (Cons ((118l), Empty)))))))))))))))))));;

let rec data_int32_modulus3 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((46l), (Cons ((114l), (Cons ((101l), (Cons ((109l), Empty)))))))))))))))))));;

let rec data_int32_and3 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((46l), (Cons ((108l), (Cons ((111l), (Cons ((103l), (Cons ((97l), (Cons ((110l), (Cons ((100l), Empty)))))))))))))))))))))))));;

let rec data_int327 () = 
    (string_from_list (Cons ((73l), (Cons ((110l), (Cons ((116l), (Cons ((51l), (Cons ((50l), (Cons ((46l), (Cons ((111l), (Cons ((102l), (Cons ((95l), (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((32l), Empty)))))))))))))))))))))))))));;

let rec data_comma3 () = 
    (string_from_list (Cons ((44l), Empty)));;

let rec data_with6 () = 
    (string_from_list (Cons ((119l), (Cons ((105l), (Cons ((116l), (Cons ((104l), Empty)))))))));;

let rec data_slice7 () = 
    (string_from_list (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))));;

let rec data_slice_type2 () = 
    (string_from_list (Cons ((95l), (Cons ((115l), (Cons ((108l), (Cons ((105l), (Cons ((99l), (Cons ((101l), Empty)))))))))))));;

let rec data_definition_end () = 
    (string_from_list (Cons ((59l), (Cons ((59l), Empty)))));;

let rec data_let_rec () = 
    (string_from_list (Cons ((108l), (Cons ((101l), (Cons ((116l), (Cons ((32l), (Cons ((114l), (Cons ((101l), (Cons ((99l), (Cons ((32l), Empty)))))))))))))))));;

let rec data_constant2 () = 
    (string_from_list (Cons ((95l), (Cons ((99l), (Cons ((111l), (Cons ((110l), (Cons ((115l), (Cons ((116l), (Cons ((97l), (Cons ((110l), (Cons ((116l), (Cons ((95l), Empty)))))))))))))))))))));;

let rec data_preamble_filename4 () = 
    (string_from_list (Cons ((112l), (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((109l), (Cons ((98l), (Cons ((108l), (Cons ((101l), (Cons ((46l), (Cons ((109l), (Cons ((108l), Empty)))))))))))))))))))))));;

let rec data_pervasives_filename4 () = 
    (string_from_list (Cons ((112l), (Cons ((101l), (Cons ((114l), (Cons ((118l), (Cons ((97l), (Cons ((115l), (Cons ((105l), (Cons ((118l), (Cons ((101l), (Cons ((115l), (Cons ((46l), (Cons ((109l), (Cons ((108l), Empty)))))))))))))))))))))))))));;

let rec data_ocaml_language () = 
    (string_from_list (Cons ((111l), (Cons ((99l), (Cons ((97l), (Cons ((109l), (Cons ((108l), Empty)))))))))));;

let rec reserved_identifiers3 () = 
    (list_flatten (Cons ((Cons (data_assert5, (Cons (data_asr5, (Cons (data_begin5, (Cons (data_constraint5, (Cons (data_do5, (Cons (data_done5, Empty)))))))))))), (Cons ((Cons (data_downto5, (Cons (data_type5, (Cons (data_if5, (Cons (data_then5, (Cons (data_else5, (Cons (data_with6, (Cons (data_of5, Empty)))))))))))))), (Cons ((Cons (data_end5, (Cons (data_in5, (Cons (data_fun5, (Cons (data_let5, (Cons (data_open5, (Cons (data_and5, (Cons (data_or5, (Cons (data_as5, Empty)))))))))))))))), (Cons ((Cons (data_class5, (Cons (data_exception5, (Cons (data_external5, (Cons (data_false5, (Cons (data_true6, (Cons (data_for5, Empty)))))))))))), (Cons ((Cons (data_function6, (Cons (data_functor5, (Cons (data_if5, (Cons (data_include5, (Cons (data_inherit5, Empty)))))))))), (Cons ((Cons (data_initializer5, (Cons (data_land5, (Cons (data_lazy5, (Cons (data_lor5, (Cons (data_lsl5, (Cons (data_lsr5, Empty)))))))))))), (Cons ((Cons (data_lxor5, (Cons (data_method5, (Cons (data_mod5, (Cons (data_module5, (Cons (data_mutable5, (Cons (data_new5, Empty)))))))))))), (Cons ((Cons (data_nonrec5, (Cons (data_object5, (Cons (data_private5, (Cons (data_rec5, (Cons (data_sig5, (Cons (data_struct5, Empty)))))))))))), (Cons ((Cons (data_try5, (Cons (data_val5, (Cons (data_virtual5, (Cons (data_when5, (Cons (data_while5, (Cons (data_parser5, Empty)))))))))))), (Cons ((Cons (data_value5, (Cons (data_to5, (Cons (data_slice7, Empty)))))), Empty)))))))))))))))))))));;

let rec operator_translation_map3 () = 
    (dictionary_of (Cons ((Pair ((data_27 ()), (SourceString ((data_int32_plus3 ()))))), (Cons ((Pair ((data__5 ()), (SourceString ((data_int32_minus3 ()))))), (Cons ((Pair ((data_28 ()), (SourceString ((data_int32_multiply3 ()))))), (Cons ((Pair ((data_29 ()), (SourceString ((data_int32_divide3 ()))))), (Cons ((Pair ((data_30 ()), (SourceString ((data_int32_modulus3 ()))))), (Cons ((Pair ((data_31 ()), (SourceString ((data_int32_and3 ()))))), Empty)))))))))))));;

let rec translate_type_variable identifier99 = 
    (source_string_concat (SourceStringChar ((39l))) (source_string_concat (SourceStringChar ((84l))) (SourceStringIdentifier (identifier99, IdentifierTransformationNone))));;

let rec escape_identifier3 identifier100 = 
    (SourceStringIdentifier (identifier100, IdentifierTransformationNone));;

let rec lowercase_identifier identifier101 = 
    (SourceStringIdentifier (identifier101, IdentifierTransformationLowercase));;

let rec translate_type_identifier identifier102 = 
    (match (identifier_is identifier102 (identifier_slice ())) with
         | True -> 
            (SourceString ((data_slice_type2 ())))
         | False -> 
            (escape_identifier3 identifier102));;

let rec translate_constructor_identifier3 identifier103 = 
    (SourceStringIdentifier (identifier103, IdentifierTransformationCapitalize));;

let rec translate_identifier3 identifier104 = 
    (match (token_is_operator (identifier_token identifier104)) with
         | True -> 
            (match (dictionary_get (identifier_name identifier104) (operator_translation_map3 ())) with
                 | (Some (translation3)) -> 
                    translation3
                 | None -> 
                    (SourceStringIdentifier (identifier104, IdentifierTransformationNone)))
         | False -> 
            (SourceStringIdentifier (identifier104, IdentifierTransformationNone)));;

let rec translate_less_than3 translate_expression16 expressions43 = 
    (match expressions43 with
         | (Cons (a74, (Cons (b69, (Cons (then_case3, (Cons (else_case3, Empty)))))))) -> 
            (join (Cons ((SourceString ((data_if5 ()))), (Cons ((SourceString ((data_space5 ()))), (Cons ((translate_expression16 a74), (Cons ((SourceString ((data_less_than5 ()))), (Cons ((translate_expression16 b69), (Cons ((SourceString ((data_space5 ()))), (Cons ((SourceString ((data_then5 ()))), (Cons ((SourceString ((data_space5 ()))), (Cons ((translate_expression16 then_case3), (Cons ((SourceString ((data_space5 ()))), (Cons ((SourceString ((data_else5 ()))), (Cons ((SourceString ((data_space5 ()))), (Cons ((translate_expression16 else_case3), Empty)))))))))))))))))))))))))))
         | x569 -> 
            (SourceString ((data_compile_error3 ()))));;

let rec translate_constructor3 translator3 identifier105 constructor18 = 
    (wrap_in_brackets2 (join ((fun parameters25 -> (Cons ((translate_constructor_identifier3 identifier105), (Cons ((SourceString ((data_space5 ()))), (Cons (parameters25, Empty))))))) (wrap_in_brackets2 ((source_string_join (string_concat (data_comma3 ()) (string_of_char (32l)))) ((list_map translator3) constructor18))))));;

let rec translate_pattern3 pattern18 = 
    (match pattern18 with
         | (Capture (identifier106)) -> 
            (escape_identifier3 identifier106)
         | (IntegerPattern (integer13, x570)) -> 
            (join (Cons ((SourceString ((string_from_int32 integer13))), (Cons ((SourceStringChar ((108l))), Empty)))))
         | (ConstructorPattern (identifier107, Empty, x571)) -> 
            (translate_constructor_identifier3 identifier107)
         | (ConstructorPattern (identifier108, patterns8, x572)) -> 
            ((translate_constructor3 translate_pattern3 identifier108) patterns8));;

let rec translate_rule4 translate_expression17 n20 rule7 = 
    (match rule7 with
         | (Pair (pattern19, expression79)) -> 
            (join_lines (Cons (((line n20) (Cons ((SourceString ((data_vertical_bar2 ()))), (Cons ((translate_pattern3 pattern19), (Cons ((SourceString ((data_arrow2 ()))), Empty))))))), (Cons (((line (Int32.add n20 (1l))) (Cons ((translate_expression17 (Int32.add n20 (1l)) expression79), Empty))), Empty))))));;

let rec translate_match_expression3 translate_expression18 n21 expression80 rules14 = 
    ((source_string_join (string_empty ())) ((fun rules15 -> (Cons ((SourceString ((data_match7 ()))), (Cons ((source_space ()), (Cons ((translate_expression18 n21 expression80), (Cons ((source_space ()), (Cons ((SourceString ((data_with6 ()))), (Cons (rules15, Empty))))))))))))) ((source_string_join (string_empty ())) ((list_map (translate_rule4 translate_expression18 n21)) rules14))));;

let rec translate_function_application5 translate_expression19 expressions44 = 
    (match expressions44 with
         | (Cons (no_args_function2, Empty)) -> 
            (join (Cons ((translate_expression19 no_args_function2), (Cons ((SourceString ((data_space5 ()))), (Cons ((SourceString ((wrap_in_brackets (string_empty ())))), Empty)))))))
         | x573 -> 
            (source_string_join (data_space5 ()) (list_map translate_expression19 expressions44)));;

let rec translate_function_application6 translate_expression20 expressions45 = 
    (match expressions45 with
         | (Cons ((Variable (identifier109)), rest34)) -> 
            (match (x4 (identifier_token identifier109) (identifier_int32_less_than ())) with
                 | True -> 
                    (translate_less_than3 translate_expression20 rest34)
                 | False -> 
                    (translate_function_application5 translate_expression20 expressions45))
         | x574 -> 
            (translate_function_application5 translate_expression20 expressions45));;

let rec translate_argument_list3 arguments36 = 
    (match (list_is_empty arguments36) with
         | True -> 
            (SourceString ((wrap_in_brackets (string_empty ()))))
         | False -> 
            (source_string_join (data_space5 ()) (list_map lowercase_identifier arguments36)));;

let rec translate_lambda3 translate_expression21 arguments37 expression81 = 
    (join (Cons ((SourceString ((data_fun5 ()))), (Cons ((SourceString ((data_space5 ()))), (Cons ((translate_argument_list3 arguments37), (Cons ((SourceString ((data_arrow2 ()))), (Cons ((translate_expression21 expression81), Empty)))))))))));;

let rec translate_expression22 n22 expression82 = 
    (match expression82 with
         | (Lambda (arguments38, expression83, x575)) -> 
            (wrap_in_brackets2 (translate_lambda3 (translate_expression22 n22) arguments38 expression83))
         | (Constructor (identifier110, Empty, x576)) -> 
            (translate_constructor_identifier3 identifier110)
         | (Constructor (identifier111, expressions46, x577)) -> 
            ((translate_constructor3 (translate_expression22 n22) identifier111) expressions46)
         | (FunctionApplication (expressions47, x578)) -> 
            (wrap_in_brackets2 (translate_function_application6 (translate_expression22 n22) expressions47))
         | (IntegerConstant (integer14, x579)) -> 
            (wrap_in_brackets2 (SourceString ((string_concat (string_from_int32 integer14) (string_of_char (108l))))))
         | (Variable (identifier112)) -> 
            (translate_identifier3 identifier112)
         | (Match (expression84, rules16, x580)) -> 
            (wrap_in_brackets2 (translate_match_expression3 translate_expression22 (Int32.add n22 (1l)) expression84 rules16)));;

let rec translate_function_definition3 identifier113 arguments39 expression85 = 
    (join_lines (Cons (((line (0l)) (Cons ((SourceString ((data_let_rec ()))), (Cons ((lowercase_identifier identifier113), (Cons ((source_space ()), (Cons ((translate_argument_list3 arguments39), (Cons ((SourceString ((data_equals3 ()))), Empty))))))))))), (Cons (((line (1l)) (Cons ((translate_expression22 (1l) expression85), (Cons ((SourceString ((data_definition_end ()))), Empty))))), Empty)))));;

let rec translate_simple_type2 identifier114 parameters26 = 
    (match (list_any (fun x51 -> ((identifier_equal identifier114) (type_parameter_identifier x51))) parameters26) with
         | False -> 
            (translate_type_identifier identifier114)
         | True -> 
            (translate_type_variable identifier114));;

let rec translate_complex_types2 translate_types5 name80 types12 = 
    (join ((fun types13 -> (Cons (types13, (Cons ((SourceString ((data_space5 ()))), (Cons ((translate_type_identifier name80), Empty))))))) (wrap_in_brackets2 ((translate_types5 (data_comma3 ())) types12))));;

let rec translate_function_type2 translate_types6 return_type7 argument_types5 = 
    (match (list_is_empty argument_types5) with
         | True -> 
            (wrap_in_brackets2 (join (Cons ((SourceString ((data_unit ()))), (Cons ((SourceString ((data_arrow2 ()))), (Cons ((translate_types6 (data_arrow2 ()) (Cons (return_type7, Empty))), Empty))))))))
         | False -> 
            (wrap_in_brackets2 (translate_types6 (data_arrow2 ()) (list_concat argument_types5 (Cons (return_type7, Empty))))));;

let rec translate_type2 translate_types7 parameters27 type6 = 
    (match type6 with
         | (SimpleType (identifier115)) -> 
            (translate_simple_type2 identifier115 parameters27)
         | (ComplexType (identifier116, types14, x581)) -> 
            (translate_complex_types2 translate_types7 identifier116 types14)
         | (FunctionType (argument_types6, return_type8, x582)) -> 
            (translate_function_type2 translate_types7 return_type8 argument_types6));;

let rec translate_types8 parameters28 separator6 types15 = 
    ((source_string_join separator6) ((list_map (translate_type2 (translate_types8 parameters28) parameters28)) types15));;

let rec translate_complex_constructor_definition2 name81 type7 types16 parameters29 = 
    (join (Cons ((translate_constructor_identifier3 name81), (Cons ((SourceString ((data_colon3 ()))), (Cons ((translate_types8 parameters29 (data_star2 ()) types16), (Cons ((SourceString ((data_arrow2 ()))), (Cons (type7, Empty)))))))))));;

let rec translate_constructor_definition3 type8 parameters30 constructor19 = 
    (match constructor19 with
         | (SimpleConstructor (identifier117)) -> 
            (translate_constructor_identifier3 identifier117)
         | (ComplexConstructor (identifier118, types17, x583)) -> 
            (translate_complex_constructor_definition2 identifier118 type8 types17 parameters30));;

let rec translate_constructor_definitions2 type9 parameters31 constructors25 = 
    ((source_string_join (string_concat (newline ()) (string_concat (indent (1l)) (data_vertical_bar2 ())))) ((list_map (translate_constructor_definition3 type9 parameters31)) constructors25));;

let rec translate_type_parameter_for_definition parameter8 = 
    (match parameter8 with
         | (UniversalParameter (identifier119)) -> 
            (translate_type_variable identifier119)
         | (ExistentialParameter (x584)) -> 
            SourceStringEmpty);;

let rec translate_type_parameters parameters32 = 
    ((source_string_join (data_comma3 ())) ((list_filter (fun parameter9 -> (match parameter9 with
         | SourceStringEmpty -> 
            False
         | x585 -> 
            True))) ((list_map translate_type_parameter_for_definition) parameters32)));;

let rec translate_type_name name82 parameters33 parameter_string = 
    (match (list_is_empty parameters33) with
         | True -> 
            (lowercase_identifier name82)
         | False -> 
            (join (Cons ((wrap_in_brackets2 parameter_string), (Cons ((source_space ()), (Cons ((lowercase_identifier name82), Empty))))))));;

let rec translate_type_name2 name83 parameters34 = 
    (translate_type_name name83 parameters34 (translate_type_parameters parameters34));;

let rec translate_type_definition3 name84 parameters35 constructors26 = 
    (join_lines (Cons (((line (0l)) (Cons ((SourceString ((data_type5 ()))), (Cons ((source_space ()), (Cons ((translate_type_name2 name84 parameters35), (Cons ((source_space ()), (Cons ((SourceString ((data_equals3 ()))), Empty))))))))))), (Cons (((line (1l)) (Cons ((SourceString ((data_vertical_bar2 ()))), (Cons ((translate_constructor_definitions2 (translate_type_name2 name84 parameters35) parameters35 constructors26), (Cons ((SourceString ((data_definition_end ()))), Empty))))))), Empty)))));;

let rec translate_definition3 definition21 = 
    (match definition21 with
         | (FunctionDefinition (identifier120, x586, arguments40, expression86, x587)) -> 
            (translate_function_definition3 identifier120 arguments40 expression86)
         | (TypeDefinition (name85, x588, parameters36, constructors27, x589)) -> 
            (translate_type_definition3 name85 parameters36 constructors27)
         | (TargetDefinition (x590, data4)) -> 
            (SourceString ((string_from_slice data4))));;

let rec generate_source4 module_name7 definitions22 = 
    ((pair_cons (list_map (pair_cons IdentifierTransformationLowercase) (public_identifiers definitions22))) ((source_string_join (string_of_char (10l))) ((list_map translate_definition3) definitions22)));;

let rec compiler_backend_ocaml () = 
    (Backend ((data_ocaml_language ()), (Cons ((data_preamble_filename4 ()), Empty)), (Cons ((data_pervasives_filename4 ()), Empty)), generate_source4, (reserved_identifiers3 ()), (fun x51 -> (local_transforms (validate_reserved_identifiers x51)))));;

let rec compiler_backends () = 
    (Cons ((compiler_backend_haskell ()), (Cons ((compiler_backend_javascript ()), (Cons ((compiler_backend_module ()), (Cons ((compiler_backend_ocaml ()), Empty))))))));;

let rec data_no_input_files () = 
    (string_from_list (Cons ((78l), (Cons ((111l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((115l), Empty)))))))))))))))))))))))))))));;

let rec data_no_output_path () = 
    (string_from_list (Cons ((78l), (Cons ((111l), (Cons ((32l), (Cons ((111l), (Cons ((117l), (Cons ((116l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((32l), (Cons ((115l), (Cons ((112l), (Cons ((101l), (Cons ((99l), (Cons ((105l), (Cons ((102l), (Cons ((105l), (Cons ((101l), (Cons ((100l), (Cons ((44l), (Cons ((32l), (Cons ((112l), (Cons ((108l), (Cons ((101l), (Cons ((97l), (Cons ((115l), (Cons ((101l), (Cons ((32l), (Cons ((117l), (Cons ((115l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((45l), (Cons ((45l), (Cons ((111l), (Cons ((117l), (Cons ((116l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((91l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((93l), (Cons ((32l), (Cons ((102l), (Cons ((108l), (Cons ((97l), (Cons ((103l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_output_key () = 
    (string_from_list (Cons ((111l), (Cons ((117l), (Cons ((116l), (Cons ((112l), (Cons ((117l), (Cons ((116l), Empty)))))))))))));;

let rec data_stdlib () = 
    (string_from_list (Cons ((115l), (Cons ((116l), (Cons ((100l), (Cons ((108l), (Cons ((105l), (Cons ((98l), Empty)))))))))))));;

let rec data_parser_flag () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((101l), (Cons ((114l), Empty)))))))))))));;

let rec data_module_flag () = 
    (string_from_list (Cons ((109l), (Cons ((111l), (Cons ((100l), (Cons ((117l), (Cons ((108l), (Cons ((101l), Empty)))))))))))));;

let rec data_language_flag () = 
    (string_from_list (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((103l), (Cons ((117l), (Cons ((97l), (Cons ((103l), (Cons ((101l), Empty)))))))))))))))));;

let rec data_diagnostics_flag () = 
    (string_from_list (Cons ((100l), (Cons ((105l), (Cons ((97l), (Cons ((103l), (Cons ((110l), (Cons ((111l), (Cons ((115l), (Cons ((116l), (Cons ((105l), (Cons ((99l), (Cons ((115l), Empty)))))))))))))))))))))));;

let rec data_read_files () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((100l), (Cons ((32l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((32l), (Cons ((40l), (Cons ((206l), (Cons ((188l), (Cons ((115l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))));;

let rec data_write_files () = 
    (string_from_list (Cons ((119l), (Cons ((114l), (Cons ((105l), (Cons ((116l), (Cons ((101l), (Cons ((32l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((32l), (Cons ((40l), (Cons ((206l), (Cons ((188l), (Cons ((115l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))))));;

let rec data_bytes_read () = 
    (string_from_list (Cons ((114l), (Cons ((101l), (Cons ((97l), (Cons ((100l), (Cons ((32l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((32l), (Cons ((40l), (Cons ((98l), (Cons ((121l), (Cons ((116l), (Cons ((101l), (Cons ((115l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))))))));;

let rec data_max_heap_size () = 
    (string_from_list (Cons ((109l), (Cons ((97l), (Cons ((120l), (Cons ((32l), (Cons ((104l), (Cons ((101l), (Cons ((97l), (Cons ((112l), (Cons ((32l), (Cons ((115l), (Cons ((105l), (Cons ((122l), (Cons ((101l), (Cons ((32l), (Cons ((40l), (Cons ((98l), (Cons ((121l), (Cons ((116l), (Cons ((101l), (Cons ((115l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))))))))))))));;

let rec data_parse_time () = 
    (string_from_list (Cons ((112l), (Cons ((97l), (Cons ((114l), (Cons ((115l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((40l), (Cons ((206l), (Cons ((188l), (Cons ((115l), (Cons ((41l), Empty)))))))))))))))))))))))))));;

let rec data_transform_time () = 
    (string_from_list (Cons ((97l), (Cons ((115l), (Cons ((116l), (Cons ((32l), (Cons ((116l), (Cons ((114l), (Cons ((97l), (Cons ((110l), (Cons ((115l), (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((40l), (Cons ((206l), (Cons ((188l), (Cons ((115l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_generate_time () = 
    (string_from_list (Cons ((99l), (Cons ((111l), (Cons ((100l), (Cons ((101l), (Cons ((32l), (Cons ((103l), (Cons ((101l), (Cons ((110l), (Cons ((101l), (Cons ((114l), (Cons ((97l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), (Cons ((32l), (Cons ((40l), (Cons ((206l), (Cons ((188l), (Cons ((115l), (Cons ((41l), Empty)))))))))))))))))))))))))))))))))))))))))));;

let rec data_true7 () = 
    (string_from_list (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))));;

let rec data_usage () = 
    (string_from_list (Cons ((117l), (Cons ((115l), (Cons ((97l), (Cons ((103l), (Cons ((101l), Empty)))))))))));;

let rec data_usage1 () = 
    (string_from_list (Cons ((85l), (Cons ((115l), (Cons ((97l), (Cons ((103l), (Cons ((101l), (Cons ((58l), (Cons ((32l), (Cons ((114l), (Cons ((101l), (Cons ((117l), (Cons ((115l), (Cons ((101l), (Cons ((99l), (Cons ((32l), (Cons ((91l), (Cons ((102l), (Cons ((108l), (Cons ((97l), (Cons ((103l), (Cons ((115l), (Cons ((93l), (Cons ((32l), (Cons ((45l), (Cons ((45l), (Cons ((111l), (Cons ((117l), (Cons ((116l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((91l), (Cons ((79l), (Cons ((85l), (Cons ((84l), (Cons ((80l), (Cons ((85l), (Cons ((84l), (Cons ((32l), (Cons ((70l), (Cons ((73l), (Cons ((76l), (Cons ((69l), (Cons ((93l), (Cons ((32l), (Cons ((91l), (Cons ((70l), (Cons ((73l), (Cons ((76l), (Cons ((69l), (Cons ((93l), (Cons ((46l), (Cons ((46l), (Cons ((46l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage2 () = 
    (string_from_list (Cons ((67l), (Cons ((111l), (Cons ((109l), (Cons ((112l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((114l), (Cons ((32l), (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((82l), (Cons ((101l), (Cons ((117l), (Cons ((115l), (Cons ((101l), (Cons ((32l), (Cons ((112l), (Cons ((114l), (Cons ((111l), (Cons ((103l), (Cons ((114l), (Cons ((97l), (Cons ((109l), (Cons ((109l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((103l), (Cons ((117l), (Cons ((97l), (Cons ((103l), (Cons ((101l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage3 () = 
    (string_from_list (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((45l), (Cons ((45l), (Cons ((115l), (Cons ((116l), (Cons ((100l), (Cons ((108l), (Cons ((105l), (Cons ((98l), (Cons ((32l), (Cons ((91l), (Cons ((66l), (Cons ((79l), (Cons ((79l), (Cons ((76l), (Cons ((93l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((73l), (Cons ((110l), (Cons ((99l), (Cons ((108l), (Cons ((117l), (Cons ((100l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((32l), (Cons ((115l), (Cons ((116l), (Cons ((97l), (Cons ((110l), (Cons ((100l), (Cons ((97l), (Cons ((114l), (Cons ((100l), (Cons ((32l), (Cons ((108l), (Cons ((105l), (Cons ((98l), (Cons ((114l), (Cons ((97l), (Cons ((114l), (Cons ((121l), (Cons ((44l), (Cons ((32l), (Cons ((100l), (Cons ((101l), (Cons ((102l), (Cons ((97l), (Cons ((117l), (Cons ((108l), (Cons ((116l), (Cons ((58l), (Cons ((32l), (Cons ((116l), (Cons ((114l), (Cons ((117l), (Cons ((101l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage4 () = 
    (string_from_list (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((45l), (Cons ((45l), (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((103l), (Cons ((117l), (Cons ((97l), (Cons ((103l), (Cons ((101l), (Cons ((32l), (Cons ((91l), (Cons ((76l), (Cons ((65l), (Cons ((78l), (Cons ((71l), (Cons ((93l), (Cons ((32l), (Cons ((32l), (Cons ((84l), (Cons ((97l), (Cons ((114l), (Cons ((103l), (Cons ((101l), (Cons ((116l), (Cons ((32l), (Cons ((108l), (Cons ((97l), (Cons ((110l), (Cons ((103l), (Cons ((117l), (Cons ((97l), (Cons ((103l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((32l), (Cons ((99l), (Cons ((111l), (Cons ((109l), (Cons ((112l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((32l), (Cons ((116l), (Cons ((111l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage5 () = 
    (string_from_list (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((45l), (Cons ((45l), (Cons ((111l), (Cons ((117l), (Cons ((116l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((91l), (Cons ((70l), (Cons ((73l), (Cons ((76l), (Cons ((69l), (Cons ((93l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((87l), (Cons ((114l), (Cons ((105l), (Cons ((116l), (Cons ((101l), (Cons ((32l), (Cons ((111l), (Cons ((117l), (Cons ((116l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((32l), (Cons ((70l), (Cons ((73l), (Cons ((76l), (Cons ((69l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage6 () = 
    (string_from_list (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((45l), (Cons ((104l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((80l), (Cons ((114l), (Cons ((105l), (Cons ((110l), (Cons ((116l), (Cons ((32l), (Cons ((117l), (Cons ((115l), (Cons ((97l), (Cons ((103l), (Cons ((101l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((102l), (Cons ((111l), (Cons ((114l), (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((105l), (Cons ((111l), (Cons ((110l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage7 () = 
    (string_from_list (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((45l), (Cons ((102l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((32l), (Cons ((70l), (Cons ((111l), (Cons ((114l), (Cons ((109l), (Cons ((97l), (Cons ((116l), (Cons ((32l), (Cons ((105l), (Cons ((110l), (Cons ((112l), (Cons ((117l), (Cons ((116l), (Cons ((32l), (Cons ((102l), (Cons ((105l), (Cons ((108l), (Cons ((101l), (Cons ((115l), (Cons ((32l), (Cons ((98l), (Cons ((121l), (Cons ((32l), (Cons ((119l), (Cons ((114l), (Cons ((105l), (Cons ((116l), (Cons ((105l), (Cons ((110l), (Cons ((103l), (Cons ((32l), (Cons ((100l), (Cons ((105l), (Cons ((114l), (Cons ((101l), (Cons ((99l), (Cons ((116l), (Cons ((108l), (Cons ((121l), (Cons ((32l), (Cons ((116l), (Cons ((111l), (Cons ((32l), (Cons ((116l), (Cons ((104l), (Cons ((101l), (Cons ((109l), Empty)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));;

let rec data_usage8 () = 
    (string_from_list (Cons ((76l), (Cons ((97l), (Cons ((110l), (Cons ((103l), (Cons ((117l), (Cons ((97l), (Cons ((103l), (Cons ((101l), (Cons ((115l), (Cons ((58l), (Cons ((32l), Empty)))))))))))))))))))))));;

let rec data_h () = 
    (string_from_list (Cons ((104l), Empty)));;

let rec data_f () = 
    (string_from_list (Cons ((102l), Empty)));;

let rec usage modules = 
    (string_join (string_of_char (10l)) (Cons ((data_usage1 ()), (Cons ((string_empty ()), (Cons ((data_usage2 ()), (Cons ((string_empty ()), (Cons ((data_usage3 ()), (Cons ((data_usage4 ()), (Cons ((data_usage5 ()), (Cons ((data_usage6 ()), (Cons ((data_usage7 ()), (Cons ((string_empty ()), (Cons ((string_concat (data_usage8 ()) (string_join (string_of_char (32l)) (list_map compiler_backend_name modules))), Empty)))))))))))))))))))))));;

type cli_program  = 
     | CliTime : (int32 -> cli_program) -> cli_program
     | CliMaxHeapSize : (int32 -> cli_program) -> cli_program
     | CliRenderSource : (((identifier_transformation,identifier) pair) list,source_string) pair * (( unit  -> string)) list * (_slice -> cli_program) -> cli_program
     | CliReadFiles : ((module_reference,string) pair) list * ((source_file) list -> cli_program) -> cli_program
     | CliWriteFiles : ((string,_slice) pair) list * ( unit  -> cli_program) -> cli_program
     | CliOutput : string * ( unit  -> cli_program) -> cli_program
     | CliError : string * ( unit  -> cli_program) -> cli_program
     | CliExit : int32 -> cli_program;;

let rec time_bind f54 = 
    (CliTime (f54));;

let rec max_heap_size_bind f55 = 
    (CliMaxHeapSize (f55));;

let rec render_source_bind source3 reserved_identifiers4 f56 = 
    (CliRenderSource (source3, reserved_identifiers4, f56));;

let rec read_files_bind paths2 f57 = 
    (CliReadFiles (paths2, f57));;

let rec write_files_bind files9 f58 = 
    (CliWriteFiles (files9, f58));;

let rec error_bind message f59 = 
    (CliError (message, f59));;

let rec flag_is_true flag default4 arguments41 = 
    (match (dictionary_get flag arguments41) with
         | (Some (value27)) -> 
            (string_equal value27 (data_true7 ()))
         | None -> 
            default4);;

let rec find_backend arguments42 = 
    (maybe_or_else (compiler_backend_ocaml ()) (maybe_bind (dictionary_get (data_language_flag ()) arguments42) (fun language -> (list_find_first (fun x51 -> ((string_equal language) (compiler_backend_name x51))) (compiler_backends ())))));;

let rec modules_from_arguments backend12 data_path5 arguments43 = 
    ((match (flag_is_true (data_stdlib ()) True (dictionary_of arguments43)) with
         | True -> 
            (list_concat (standard_library_module backend12 data_path5))
         | False -> 
            id) ((match (flag_is_true (data_parser_flag ()) False (dictionary_of arguments43)) with
         | True -> 
            (list_cons (parser_module backend12 data_path5))
         | False -> 
            id) ((list_map (fun x51 -> ((module_name_and_path False) (pair_right x51)))) ((list_filter (fun x51 -> ((string_equal (data_module_flag ())) (pair_left x51)))) arguments43))));;

let rec table_to_string table4 = 
    (string_join (string_of_char (10l)) (list_map (string_join (string_of_char (32l))) table4));;

let rec print_diagnostics arguments44 file_entries max_heap_size start_parse end_parse start_transform end_transform start_generate end_generate start_read_files end_read_files start_write_files end_write_files k = 
    (match (flag_is_true (data_diagnostics_flag ()) False arguments44) with
         | True -> 
            (CliError ((table_to_string (Cons ((Cons ((string_from_int32 (list_foldl (fun file17 bytes -> (Int32.add bytes (source_file_size file17))) (0l) file_entries)), (Cons ((data_bytes_read ()), Empty)))), (Cons ((Cons ((string_from_int32 max_heap_size), (Cons ((data_max_heap_size ()), Empty)))), (Cons ((Cons ((string_from_int32 (Int32.sub end_parse start_parse)), (Cons ((data_parse_time ()), Empty)))), (Cons ((Cons ((string_from_int32 (Int32.sub end_transform start_transform)), (Cons ((data_transform_time ()), Empty)))), (Cons ((Cons ((string_from_int32 (Int32.sub end_generate start_generate)), (Cons ((data_generate_time ()), Empty)))), (Cons ((Cons ((string_from_int32 (Int32.sub end_read_files start_read_files)), (Cons ((data_read_files ()), Empty)))), (Cons ((Cons ((string_from_int32 (Int32.sub end_write_files start_write_files)), (Cons ((data_write_files ()), Empty)))), Empty))))))))))))))), k))
         | False -> 
            (k ()));;

let rec format_input_files input_files = 
    (CliReadFiles ((list_map (pair_cons ModuleSelf) input_files), (fun source_files -> (match (format_source_files source_files) with
         | (Result (files_to_write)) -> 
            (CliWriteFiles (files_to_write, (fun () -> (CliExit ((0l))))))
         | (Error (error_message)) -> 
            (error_bind error_message (fun () -> (CliExit ((1l)))))))));;

let rec compile_input_files input_files2 data_path6 arguments45 argument_list = 
    (let_bind (find_backend arguments45) (fun backend13 -> (time_bind (fun start_read_files2 -> (read_files_bind (list_concat (preamble_files backend13 data_path6) (list_concat (modules_from_arguments backend13 data_path6 argument_list) (list_map (pair_cons ModuleSelf) input_files2))) (fun file_entries2 -> (time_bind (fun end_read_files2 -> (match (dictionary_get (data_output_key ()) arguments45) with
         | (Some (output_path)) -> 
            (let_bind (path_filename_without_extension output_path) (fun module_name8 -> (time_bind (fun start_parse2 -> (let_bind (parse_source_files (with_local_transform_keywords (intrinsic_identifiers ())) file_entries2) (fun definitions23 -> (time_bind (fun end_parse2 -> (time_bind (fun start_transform2 -> (let_bind (compiler_backend_transform_definitions backend13 definitions23) (fun definitions24 -> (time_bind (fun end_transform2 -> (time_bind (fun start_generate2 -> (match (generate backend13 module_name8 definitions24) with
                 | (Result (source4)) -> 
                    (time_bind (fun end_generate2 -> (time_bind (fun start_write_files2 -> (render_source_bind source4 (compiler_backend_reserved_identifiers backend13) (fun source5 -> (write_files_bind (Cons ((Pair (output_path, source5)), Empty)) (fun () -> (time_bind (fun end_write_files2 -> (CliMaxHeapSize ((fun max_heap_size2 -> (print_diagnostics arguments45 file_entries2 max_heap_size2 start_parse2 end_parse2 start_transform2 end_transform2 start_generate2 end_generate2 start_read_files2 end_read_files2 start_write_files2 end_write_files2 (fun () -> (CliExit ((0l))))))))))))))))))
                 | (Error (error16)) -> 
                    (error_bind (error_to_string file_entries2 error16) (fun () -> (CliExit ((1l))))))))))))))))))))))
         | None -> 
            (error_bind (data_no_output_path ()) (fun () -> (CliExit ((1l))))))))))))));;

let rec cli_main data_path7 argv = 
    (match (parse_arguments argv) with
         | (CliArguments (Empty, Empty)) -> 
            (error_bind (usage (compiler_backends ())) (fun () -> (CliExit ((1l)))))
         | (CliErrorMissingValue (key9)) -> 
            (error_bind key9 (fun () -> (CliExit ((1l)))))
         | (CliArguments (argument_list2, input_files3)) -> 
            (let_bind (dictionary_of argument_list2) (fun arguments46 -> (match (dictionary_has (data_h ()) arguments46) with
                 | True -> 
                    (error_bind (usage (compiler_backends ())) (fun () -> (CliExit ((1l)))))
                 | False -> 
                    (match (list_is_empty input_files3) with
                         | True -> 
                            (error_bind (data_no_input_files ()) (fun () -> (CliExit ((1l)))))
                         | False -> 
                            (match (dictionary_has (data_f ()) arguments46) with
                                 | True -> 
                                    (format_input_files input_files3)
                                 | False -> 
                                    (compile_input_files input_files3 data_path7 arguments46 argument_list2)))))));;
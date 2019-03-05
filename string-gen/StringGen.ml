type boolean = CTrue | CFalse;;
let rec not = fun a -> (match a with CTrue -> CFalse | CFalse -> CTrue);;
let rec _and = fun a b -> (match a with CTrue -> b | CFalse -> CFalse);;
let rec _or = fun a b -> (match a with CTrue -> CTrue | CFalse -> b);;
let rec _60 = fun a b -> (if a<b then CTrue else CFalse);;
let rec _62 = fun a b -> (_60 b a);;
let rec _61 = fun a b -> (not (_or (_60 a b) (_62 a b)));;
let rec _60_61 = fun a b -> (_or (_60 a b) (_61 a b));;
let rec _62_61 = fun a b -> (_or (_62 a b) (_61 a b));;
type ('Ta,'Tb) pair = CPair : 'Ta * 'Tb -> ('Ta,'Tb) pair;;
let rec pair_45cons = fun a b -> (CPair (a,b));;
let rec pair_45left = fun pair -> (match pair with (CPair (x,_95)) -> x);;
let rec pair_45right = fun pair -> (match pair with (CPair (_95,x)) -> x);;
let rec pair_45map = fun f pair -> (match pair with (CPair (x,y)) -> (f x y));;
let rec pair_45map_45left = fun f pair -> (match pair with (CPair (x,y)) -> (CPair ((f x),y)));;
let rec pair_45map_45right = fun f pair -> (match pair with (CPair (x,y)) -> (CPair (x,(f y))));;
let rec pair_45swap = fun pair -> (match pair with (CPair (x,y)) -> (CPair (y,x)));;
type ('Ta) maybe = CSome : 'Ta -> ('Ta) maybe | CNone;;
let rec maybe_45some = fun _value -> (CSome (_value));;
let rec _constant_maybe_45none = CNone;;let rec maybe_45none = fun () -> _constant_maybe_45none;;
let rec maybe_45map = fun f maybe -> (match maybe with (CSome (x)) -> (CSome ((f x))) | CNone -> CNone);;
let rec maybe_45flatmap = fun f maybe -> (match maybe with (CSome (x)) -> (f x) | CNone -> CNone);;
let rec maybe_45filter = fun f maybe -> (match maybe with (CSome (x)) -> (match (f x) with CTrue -> maybe | CFalse -> CNone) | CNone -> CNone);;
let rec maybe_45else = fun f maybe -> (match maybe with CNone -> (f ()) | (CSome (x)) -> x);;
type ('Telement) indexed_45iterator = CIndexedIterator : 'Tcollection * int32 * ('Tcollection -> int32 -> ('Telement) maybe) * (('Telement) indexed_45iterator -> 'Tcollection -> int32 -> ('Telement) indexed_45iterator) -> ('Telement) indexed_45iterator;;
let rec indexed_45iterator_45next = fun iterator -> (match iterator with (CIndexedIterator (collection,index,_95,next)) -> (next iterator collection index));;
let rec indexed_45iterator_45get = fun iterator -> (match iterator with (CIndexedIterator (collection,index,get,_95)) -> (get collection index));;
let rec indexed_45iterator_45index = fun iterator -> (match iterator with (CIndexedIterator (_95,index,_95_95,_95_95_95)) -> index);;
let rec indexed_45iterator_45foldl = fun f initial iterator -> (match (indexed_45iterator_45get iterator) with CNone -> initial | (CSome (x)) -> (indexed_45iterator_45foldl f (f x initial) (indexed_45iterator_45next iterator)));;
type ('Tm,'Tvalue) chunk = CChunk : 'Tm * ('Tm -> int32) * (int32 -> 'Tm -> 'Tvalue) * (int32 -> int32 -> 'Tm -> ('Tm,'Tvalue) chunk) * ('Tm -> 'Tm -> boolean) -> ('Tm,'Tvalue) chunk;;
let rec chunk_45size = fun chunk -> (match chunk with (CChunk (m,size,_95,_95_95,_95_95_95)) -> (size m));;
let rec chunk_45get = fun index chunk -> (match chunk with (CChunk (m,_95,get,_95_95,_95_95_95)) -> (get index m));;
let rec chunk_45slice = fun offset size chunk -> (match chunk with (CChunk (m,_95,_95_95,slice,_95_95_95)) -> (slice offset size m));;
let rec chunk_45equal_63 = fun chunk other -> (match (chunk ()) with (CChunk (a,_95,_95_95,_95_95_95,equal_63)) -> (match (other ()) with (CChunk (b,_95,_95_95,_95_95_95,_95_95_95_95)) -> (equal_63 a b)));;
let rec chunk_45foldl_39 = fun f accumulator index size chunk -> (match (_60 index size) with CTrue -> (chunk_45foldl_39 f (f (chunk_45get index chunk) accumulator) (Int32.add index (1l)) size chunk) | CFalse -> accumulator);;
let rec chunk_45foldl = fun f initial chunk -> (chunk_45foldl_39 f initial (0l) (chunk_45size chunk) chunk);;
let rec chunk_45indexed_45iterator_45get = fun chunk index -> (match (_62_61 index (chunk_45size chunk)) with CTrue -> CNone | CFalse -> (CSome ((chunk_45get index chunk))));;
let rec chunk_45indexed_45iterator_45next = fun iterator chunk index -> (CIndexedIterator (chunk,(Int32.add index (1l)),chunk_45indexed_45iterator_45get,chunk_45indexed_45iterator_45next));;
let rec chunk_45to_45indexed_45iterator = fun chunk -> (CIndexedIterator (chunk,(0l),chunk_45indexed_45iterator_45get,chunk_45indexed_45iterator_45next));;
type ('Ta) list = CCons : 'Ta * ('Ta) list -> ('Ta) list | CEmpty;;
let rec list_45cons = fun x xs -> (CCons (x,xs));;
let rec list_45from = fun x -> (CCons (x,CEmpty));;
let rec list_45from_45range = fun from _95to -> (match (_60 from _95to) with CTrue -> (CCons (from,(list_45from_45range (Int32.add from (1l)) _95to))) | CFalse -> CEmpty);;
let rec list_45first = fun list -> (match list with (CCons (x,_95)) -> (CSome (x)) | CEmpty -> CNone);;
let rec list_45rest = fun list -> (match list with (CCons (_95,rest)) -> rest | CEmpty -> CEmpty);;
let rec list_45last = fun list -> (match list with CEmpty -> CNone | (CCons (x,CEmpty)) -> (CSome (x)) | (CCons (_95,rest)) -> (list_45last rest));;
let rec list_45empty_63 = fun list -> (match list with (CCons (_95,_95_95)) -> CFalse | CEmpty -> CTrue);;
let rec list_45size_39 = fun list size -> (match list with (CCons (_95,rest)) -> (list_45size_39 rest (Int32.add size (1l))) | CEmpty -> size);;
let rec list_45size = fun list -> (list_45size_39 list (0l));;
let rec list_45foldrk = fun f initial list continue -> (match list with CEmpty -> (continue initial) | (CCons (x,xs)) -> (list_45foldrk f initial xs (fun _value -> (f x _value continue))));;
let rec list_45foldlk = fun f initial list continue -> (match list with CEmpty -> (continue initial) | (CCons (x,xs)) -> (f x initial (fun new_45value -> (list_45foldlk f new_45value xs continue))));;
let rec list_45foldr = fun f initial list -> (list_45foldrk (fun x _value continue -> (continue (f x _value))) initial list (fun x -> x));;
let rec list_45foldl = fun f initial list -> (match list with CEmpty -> initial | (CCons (x,xs)) -> (list_45foldl f (f x initial) xs));;
let rec list_45concat = fun a b -> (list_45foldr list_45cons b a);;
let rec list_45append = fun x list -> (list_45foldr list_45cons (CCons (x,CEmpty)) list);;
let rec list_45reverse = fun list -> (list_45foldl list_45cons CEmpty list);;
let rec list_45map = fun f list -> (list_45foldr (fun head tail -> (list_45cons (f head) tail)) CEmpty list);;
let rec list_45flatmap = fun f list -> (list_45foldr (fun head tail -> (list_45concat (f head) tail)) CEmpty list);;
let rec list_45skip = fun count list -> (match (_62 count (0l)) with CTrue -> (list_45skip (Int32.sub count (1l)) (list_45rest list)) | CFalse -> list);;
let rec list_45take_39 = fun count list taken -> (match (_62 count (0l)) with CTrue -> (match list with (CCons (char,rest)) -> (list_45take_39 (Int32.sub count (1l)) rest (CCons (char,taken))) | CEmpty -> taken) | CFalse -> taken);;
let rec list_45take = fun count list -> (list_45reverse (list_45take_39 count list CEmpty));;
let rec list_45zip_39 = fun xs ys collected -> (match xs with CEmpty -> collected | (CCons (x,xs)) -> (match ys with CEmpty -> collected | (CCons (y,ys)) -> (list_45zip_39 xs ys (CCons ((CPair (x,y)),collected)))));;
let rec list_45zip = fun xs ys -> (list_45reverse (list_45zip_39 xs ys CEmpty));;
let rec list_45pairs = fun xs -> (match xs with (CCons (a,(CCons (b,rest)))) -> (CCons ((CPair (a,b)),(list_45pairs rest))) | _95 -> CEmpty);;
let rec list_45find_45first = fun predicate list -> (match list with CEmpty -> CNone | (CCons (x,xs)) -> (match (predicate x) with CTrue -> (CSome (x)) | CFalse -> (list_45find_45first predicate xs)));;
let rec list_45filter = fun f list -> (list_45foldr (fun head tail -> (match (f head) with CTrue -> (CCons (head,tail)) | CFalse -> tail)) CEmpty list);;
let rec list_45exclude = fun f list -> (list_45filter (fun _226_156_168x -> (not (f _226_156_168x))) list);;
let rec list_45any_63 = fun f list -> (not (list_45empty_63 (list_45filter f list)));;
let rec list_45indexed_45iterator_45get = fun collection _95 -> (match collection with (CCons (x,_95)) -> (CSome (x)) | CEmpty -> CNone);;
let rec list_45indexed_45iterator_45next = fun iterator collection index -> (match collection with (CCons (_95,xs)) -> (CIndexedIterator (xs,(Int32.add index (1l)),list_45indexed_45iterator_45get,list_45indexed_45iterator_45next)) | CEmpty -> iterator);;
let rec list_45to_45indexed_45iterator = fun list -> (CIndexedIterator (list,(0l),list_45indexed_45iterator_45get,list_45indexed_45iterator_45next));;
let rec list_45collect_45from_45indexed_45iterator_39 = fun predicate iterator initial -> (match (indexed_45iterator_45get iterator) with CNone -> (CPair (iterator,initial)) | (CSome (x)) -> (match (predicate x) with CTrue -> (list_45collect_45from_45indexed_45iterator_39 predicate (indexed_45iterator_45next iterator) (CCons (x,initial))) | CFalse -> (CPair (iterator,initial))));;
let rec list_45collect_45from_45indexed_45iterator = fun predicate iterator -> (match (list_45collect_45from_45indexed_45iterator_39 predicate iterator CEmpty) with (CPair (iterator,result)) -> (CPair (iterator,(list_45reverse result))));;
type string_45node = CFTValue : int32 -> string_45node | CFTNode2 : int32 * string_45node * string_45node -> string_45node | CFTNode3 : int32 * string_45node * string_45node * string_45node -> string_45node;;
type string = CFTEmpty | CFTSingle : string_45node -> string | CFTDeep : (string_45node) list * string * (string_45node) list -> string;;
let rec _constant_string_45empty = CFTEmpty;;let rec string_45empty = fun () -> _constant_string_45empty;;
let rec string_45of_45char = fun character -> (CFTSingle ((CFTValue (character))));;
let rec string_45node_45size_39 = fun node -> (match node with (CFTValue (_95)) -> (1l) | (CFTNode2 (size,_95,_95_95)) -> size | (CFTNode3 (size,_95,_95_95,_95_95_95)) -> size);;
let rec string_45node2_39 = fun a b -> (CFTNode2 ((Int32.add (string_45node_45size_39 a) (string_45node_45size_39 b)),a,b));;
let rec string_45node3_39 = fun a b c -> (CFTNode3 ((Int32.add (string_45node_45size_39 a) (Int32.add (string_45node_45size_39 b) (string_45node_45size_39 c))),a,b,c));;
let rec string_45prepend_45node_39 = fun a tree -> (match tree with CFTEmpty -> (CFTSingle (a)) | (CFTSingle (x)) -> (CFTDeep ((CCons (a,CEmpty)),CFTEmpty,(CCons (x,CEmpty)))) | (CFTDeep (first,middle,last)) -> (match first with (CCons (b,(CCons (c,(CCons (d,(CCons (e,CEmpty)))))))) -> (CFTDeep ((CCons (a,(CCons (b,CEmpty)))),(string_45prepend_45node_39 (string_45node3_39 c d e) middle),last)) | _95 -> (CFTDeep ((CCons (a,first)),middle,last))));;
let rec string_45prepend = fun char string -> (string_45prepend_45node_39 (CFTValue (char)) string);;
let rec string_45append_45node_39 = fun a tree -> (match tree with CFTEmpty -> (CFTSingle (a)) | (CFTSingle (x)) -> (CFTDeep ((CCons (x,CEmpty)),CFTEmpty,(CCons (a,CEmpty)))) | (CFTDeep (first,middle,last)) -> (match last with (CCons (b,(CCons (c,(CCons (d,(CCons (e,CEmpty)))))))) -> (CFTDeep (first,(string_45append_45node_39 (string_45node3_39 e d c) middle),(CCons (a,(CCons (b,CEmpty)))))) | _95 -> (CFTDeep (first,middle,(CCons (a,last))))));;
let rec string_45append = fun char string -> (string_45append_45node_39 (CFTValue (char)) string);;
let rec string_45first_45node_39 = fun node -> (match node with (CFTValue (x)) -> x | (CFTNode2 (_95,x,_95_95)) -> (string_45first_45node_39 x) | (CFTNode3 (_95,x,_95_95,_95_95_95)) -> (string_45first_45node_39 x));;
let rec string_45first = fun string -> (match string with CFTEmpty -> CNone | (CFTSingle (node)) -> (CSome ((string_45first_45node_39 node))) | (CFTDeep (first,middle,last)) -> (maybe_45map string_45first_45node_39 (list_45first first)));;
let rec string_45rest_45node_39 = fun node -> (match node with (CFTValue (_95)) -> CNone | (CFTNode2 (_95,a,b)) -> (match (string_45rest_45node_39 a) with (CSome (node)) -> (CSome ((string_45node2_39 node b))) | CNone -> (CSome (b))) | (CFTNode3 (_95,a,b,c)) -> (match (string_45rest_45node_39 a) with (CSome (node)) -> (CSome ((string_45node3_39 node b c))) | CNone -> (CSome ((string_45node2_39 b c)))));;
let rec string_45rest = fun string -> (match string with CFTEmpty -> string | (CFTSingle (node)) -> (match (string_45rest_45node_39 node) with (CSome (node)) -> (CFTSingle (node)) | CNone -> CFTEmpty) | (CFTDeep ((CCons (node,rest)),middle,last)) -> (match (string_45rest_45node_39 node) with (CSome (node)) -> (CFTDeep ((CCons (node,rest)),middle,last)) | CNone -> (match rest with CEmpty -> (list_45foldr string_45append_45node_39 middle last) | _95 -> (CFTDeep (rest,middle,last)))) | _95 -> string);;
let rec string_45foldr_45node_39 = fun f node identity -> (match node with (CFTValue (a)) -> (f a identity) | (CFTNode2 (_95,a,b)) -> (string_45foldr_45node_39 f a (string_45foldr_45node_39 f b identity)) | (CFTNode3 (_95,a,b,c)) -> (string_45foldr_45node_39 f a (string_45foldr_45node_39 f b (string_45foldr_45node_39 f c identity))));;
let rec string_45foldr = fun f identity tree -> (match tree with CFTEmpty -> identity | (CFTSingle (x)) -> (string_45foldr_45node_39 f x identity) | (CFTDeep (first,middle,last)) -> (list_45foldr (string_45foldr_45node_39 f) (string_45foldr f (list_45foldl (string_45foldr_45node_39 f) identity last) middle) first));;
let rec string_45foldl_45node_39 = fun f node identity -> (match node with (CFTValue (a)) -> (f a identity) | (CFTNode2 (_95,b,a)) -> (string_45foldl_45node_39 f a (string_45foldl_45node_39 f b identity)) | (CFTNode3 (_95,c,b,a)) -> (string_45foldl_45node_39 f a (string_45foldl_45node_39 f b (string_45foldl_45node_39 f c identity))));;
let rec string_45foldl = fun f identity tree -> (match tree with CFTEmpty -> identity | (CFTSingle (x)) -> (string_45foldl_45node_39 f x identity) | (CFTDeep (first,middle,last)) -> (list_45foldr (string_45foldl_45node_39 f) (string_45foldl f (list_45foldl (string_45foldl_45node_39 f) identity first) middle) last));;
let rec string_45size = fun string -> (match string with CFTEmpty -> (0l) | (CFTSingle (x)) -> (string_45node_45size_39 x) | (CFTDeep (first,middle,last)) -> (Int32.add (list_45foldr Int32.add (0l) (list_45map string_45node_45size_39 first)) (Int32.add (list_45foldr Int32.add (0l) (list_45map string_45node_45size_39 last)) (string_45size middle))));;
let rec string_45concat_45nodes_39 = fun nodes -> (match nodes with (CCons (a,(CCons (b,CEmpty)))) -> (CCons ((string_45node2_39 a b),CEmpty)) | (CCons (a,(CCons (b,(CCons (c,CEmpty)))))) -> (CCons ((string_45node3_39 a b c),CEmpty)) | (CCons (a,(CCons (b,(CCons (c,(CCons (d,CEmpty)))))))) -> (CCons ((string_45node2_39 a b),(CCons ((string_45node2_39 c d),CEmpty)))) | (CCons (a,(CCons (b,(CCons (c,rest)))))) -> (CCons ((string_45node3_39 a b c),(string_45concat_45nodes_39 rest))) | _95 -> CEmpty);;
type ('Ta,'Tb,'Tc) triple = CTriple : 'Ta * 'Tb * 'Tc -> ('Ta,'Tb,'Tc) triple;;
let rec string_45concat_39 = fun a nodes b -> (match (CTriple (a,nodes,b)) with (CTriple (CFTEmpty,nodes,b)) -> (list_45foldr string_45prepend_45node_39 b nodes) | (CTriple (a,nodes,CFTEmpty)) -> (list_45foldl string_45append_45node_39 a nodes) | (CTriple ((CFTSingle (x)),nodes,b)) -> (string_45prepend_45node_39 x (list_45foldr string_45prepend_45node_39 b nodes)) | (CTriple (a,nodes,(CFTSingle (x)))) -> (string_45append_45node_39 x (list_45foldl string_45append_45node_39 a nodes)) | (CTriple ((CFTDeep (first1,middle1,last1)),nodes,(CFTDeep (first2,middle2,last2)))) -> (CFTDeep (first1,(string_45concat_39 middle1 (string_45concat_45nodes_39 (list_45concat (list_45reverse last1) (list_45concat nodes first2))) middle2),last2)));;
let rec string_45concat = fun a b -> (string_45concat_39 a CEmpty b);;
let rec string_45to_45list = fun string -> (string_45foldr list_45cons CEmpty string);;
let rec string_45from_45list = fun list -> (list_45foldr string_45prepend (string_45empty ()) list);;
let rec string_45skip = fun count string -> (match (_62 count (0l)) with CTrue -> (string_45skip (Int32.sub count (1l)) (string_45rest string)) | CFalse -> string);;
let rec string_45take_39 = fun count string taken -> (match (_62 count (0l)) with CTrue -> (match (string_45first string) with (CSome (char)) -> (string_45take_39 (Int32.sub count (1l)) (string_45rest string) (string_45append char taken)) | CNone -> taken) | CFalse -> taken);;
let rec string_45take = fun count string -> (string_45take_39 count string (string_45empty ()));;
let rec string_45reverse = fun string -> (string_45foldl string_45prepend (string_45empty ()) string);;
let rec string_45substring = fun start size string -> (string_45take size (string_45skip start string));;
let rec string_45join = fun separator strings -> (match strings with (CCons (first,rest)) -> (list_45foldl (fun string joined -> (string_45concat joined (string_45concat separator string))) first rest) | CEmpty -> (string_45empty ()));;
let rec string_45flatmap = fun f string -> (string_45join (string_45empty ()) (list_45map f (string_45to_45list string)));;
let rec string_45split_39 = fun separator list current parts -> (match list with CEmpty -> (list_45reverse (CCons ((list_45reverse current),parts))) | (CCons (c,rest)) -> (match (_61 separator c) with CTrue -> (string_45split_39 separator rest CEmpty (CCons ((list_45reverse current),parts))) | CFalse -> (string_45split_39 separator rest (CCons (c,current)) parts)));;
let rec string_45split = fun separator string -> (list_45map string_45from_45list (string_45split_39 separator (string_45to_45list string) CEmpty CEmpty));;
let rec string_45trim_45start_39 = fun list -> (match list with (CCons (x,xs)) -> (match (_61 x (32l)) with CTrue -> (string_45trim_45start_39 xs) | CFalse -> list) | CEmpty -> list);;
let rec string_45trim_45start = fun string -> (string_45from_45list (string_45trim_45start_39 (string_45to_45list string)));;
let rec string_45trim_45end = fun string -> (string_45reverse (string_45trim_45start (string_45reverse string)));;
let rec string_45trim = fun string -> (string_45trim_45start (string_45trim_45end string));;
let rec string_45empty_63 = fun string -> (match (string_45first string) with (CSome (_95)) -> CFalse | CNone -> CTrue);;
let rec string_45equal_63 = fun a b -> (match (string_45first a) with (CSome (xa)) -> (match (string_45first b) with (CSome (xb)) -> (_and (_61 xa xb) (string_45equal_63 (string_45rest a) (string_45rest b))) | CNone -> (string_45empty_63 a)) | CNone -> (string_45empty_63 b));;
let rec string_45point_45is_45digit = fun point -> (_and (_62 point (47l)) (_60 point (58l)));;
let rec string_45to_45int32_39_39_39 = fun string_45to_45int32_39_39 string accumulator x -> (string_45to_45int32_39_39 string (CSome ((Int32.add (Int32.mul (10l) accumulator) (Int32.sub x (48l))))));;
let rec string_45to_45int32_39_39 = fun string accumulator -> (match string with CEmpty -> accumulator | (CCons (x,rest)) -> (maybe_45flatmap (fun accumulator -> ((fun _226_156_168x -> ((maybe_45flatmap (string_45to_45int32_39_39_39 string_45to_45int32_39_39 rest accumulator)) ((maybe_45filter string_45point_45is_45digit) _226_156_168x))) (CSome (x)))) accumulator));;
let rec string_45to_45int32_39 = fun string -> (match string with (CCons (45l,string)) -> (match (list_45empty_63 string) with CTrue -> CNone | CFalse -> (maybe_45map (fun x -> (Int32.mul (-1l) x)) (string_45to_45int32_39 string))) | _95 -> (string_45to_45int32_39_39 string (CSome ((0l)))));;
let rec string_45to_45int32 = fun string -> (string_45to_45int32_39 (string_45to_45list string));;
let rec string_45from_45int32_39_39 = fun integer string -> (match (_62 integer (9l)) with CTrue -> (string_45from_45int32_39_39 (Int32.div integer (10l)) (CCons ((Int32.add (Int32.rem integer (10l)) (48l)),string))) | CFalse -> (CCons ((Int32.add integer (48l)),string)));;
let rec string_45from_45int32_39 = fun integer -> (match (_60 integer (0l)) with CTrue -> (match (_61 integer (-2147483648l)) with CTrue -> (CCons ((45l),(CCons ((50l),(CCons ((49l),(CCons ((52l),(CCons ((55l),(CCons ((52l),(CCons ((56l),(CCons ((51l),(CCons ((54l),(CCons ((52l),(CCons ((56l),CEmpty)))))))))))))))))))))) | CFalse -> (CCons ((45l),(string_45from_45int32_39 (Int32.mul integer (-1l)))))) | CFalse -> (string_45from_45int32_39_39 integer CEmpty));;
let rec string_45from_45int32 = fun integer -> (string_45from_45list (string_45from_45int32_39 integer));;
let rec string_45collect_45from_45indexed_45iterator = fun predicate iterator -> (pair_45map_45right string_45from_45list (list_45collect_45from_45indexed_45iterator predicate iterator));;
let rec string_45from_45boolean = fun boolean -> (match boolean with CTrue -> (string_45from_45list (CCons ((84l),(CCons ((114l),(CCons ((117l),(CCons ((101l),CEmpty))))))))) | CFalse -> (string_45from_45list (CCons ((70l),(CCons ((97l),(CCons ((108l),(CCons ((115l),(CCons ((101l),CEmpty))))))))))));;
let rec string_45from_45chunk = fun chunk -> (chunk_45foldl string_45append (string_45empty ()) chunk);;
type ('Tv,'Te) result = CResult : 'Tv -> ('Tv,'Te) result | CError : 'Te -> ('Tv,'Te) result;;
let rec result_45lift = fun result -> (CResult (result));;
let rec result_45error = fun error -> (CError (error));;
let rec result_45map = fun f result -> (match result with (CResult (x)) -> (CResult ((f x))) | (CError (error)) -> (CError (error)));;
let rec result_45map_45error = fun f result -> (match result with (CResult (x)) -> (CResult (x)) | (CError (error)) -> (CError ((f error))));;
let rec result_45flatmap = fun f result -> (match result with (CResult (x)) -> (f x) | (CError (error)) -> (CError (error)));;
let rec result_45either = fun f g result -> (match result with (CResult (x)) -> (f x) | (CError (x)) -> (g x));;
let rec result_45or_45else = fun _value result -> (match result with (CResult (x)) -> x | (CError (x)) -> _value);;
let rec result_45error_63 = fun result -> (match result with (CError (_95)) -> CTrue | _95 -> CFalse);;
let rec result_45filter_45list = fun list -> (list_45foldr (fun result new_45list -> (match result with (CResult (x)) -> (CCons (x,new_45list)) | _95 -> new_45list)) CEmpty list);;
let rec result_45concat = fun list -> (match (list_45filter result_45error_63 list) with (CCons ((CError (error)),_95)) -> (CError (error)) | (CCons ((CResult (_95)),_95_95)) -> (CResult (CEmpty)) | CEmpty -> (CResult ((result_45filter_45list list))));;
let rec result_45of_45maybe = fun error maybe -> (match maybe with (CSome (x)) -> (CResult (x)) | CNone -> (CError (error)));;
let rec result_45bind = fun result f -> (result_45flatmap f result);;
let rec result_45return = fun _value -> (result_45lift _value);;
type ('Ta,'Ti) _parser = CParser : ('Ti -> (('Ta,'Ti) pair) maybe) -> ('Ta,'Ti) _parser;;
let rec parser_45result = fun x -> (CParser ((fun input -> (CSome ((CPair (x,input)))))));;
let rec _constant_parser_45fail = (CParser ((fun _95 -> CNone)));;let rec parser_45fail = fun () -> _constant_parser_45fail;;
let rec parser_45apply = fun _parser input -> (match _parser with (CParser (p)) -> (p input));;
let rec parser_45run = fun _parser input -> (maybe_45map pair_45left (parser_45apply _parser input));;
let rec parser_45bind = fun f _parser -> (CParser ((fun input -> (match (parser_45apply _parser input) with CNone -> CNone | (CSome ((CPair (_value,rest)))) -> (parser_45apply (f _value) rest)))));;
let rec parser_45if = fun predicate _parser -> (parser_45bind (fun _value -> (match (predicate _value) with CTrue -> (parser_45result _value) | CFalse -> (parser_45fail ()))) _parser);;
let rec parser_45and = fun f parser_45a parser_45b -> (parser_45bind (fun a -> (parser_45bind (fun b -> (f a b)) parser_45b)) parser_45a);;
let rec parser_45or = fun parser_45a parser_45b -> (CParser ((fun input -> (match (parser_45apply parser_45a input) with (CSome (x)) -> (CSome (x)) | CNone -> (parser_45apply parser_45b input)))));;
let rec parser_45zero_45or_45more_39 = fun parser_45zero_45or_45more _parser f -> (parser_45bind (fun first -> (parser_45bind (fun rest -> (parser_45result (f first rest))) (parser_45zero_45or_45more _parser))) _parser);;
let rec parser_45zero_45or_45more = fun f initial _parser -> (parser_45or (parser_45zero_45or_45more_39 (parser_45zero_45or_45more f initial) _parser f) (parser_45result initial));;
let rec parser_45one_45or_45more = fun f initial _parser -> (parser_45and (fun first rest -> (parser_45result (f first rest))) _parser (parser_45zero_45or_45more f initial _parser));;
type ('Ts,'Tv) state = COperation : ('Ts -> ('Ts,'Tv) pair) -> ('Ts,'Tv) state;;
let rec state_45run = fun state operation -> (match operation with (COperation (f)) -> (f state));;
let rec state_45final_45value = fun initial_45state operation -> (match (state_45run initial_45state operation) with (CPair (_95,_value)) -> _value);;
let rec state_45return = fun _value -> (COperation ((fun state -> (CPair (state,_value)))));;
let rec state_45bind = fun operation f -> (COperation ((fun state -> (match (state_45run state operation) with (CPair (new_45state,new_45value)) -> (state_45run new_45state (f new_45value))))));;
let rec _constant_state_45get = (COperation ((fun state -> (CPair (state,state)))));;let rec state_45get = fun () -> _constant_state_45get;;
let rec state_45set = fun state -> (COperation ((fun _95 -> (CPair (state,state)))));;
let rec state_45modify = fun f -> (state_45bind (state_45get ()) (fun state -> (state_45set (f state))));;
let rec state_45let = fun _value f -> (state_45bind (state_45return _value) f);;
let rec state_45foldr = fun f initial_45value operations -> (list_45foldr (fun operation chain -> (state_45bind operation (fun x -> (state_45bind chain (fun xs -> (state_45return (f x xs))))))) (state_45return initial_45value) operations);;
let rec state_45foreach = fun f xs -> (state_45foldr list_45cons CEmpty (list_45map f xs));;
let rec state_45flatmap = fun f operation -> (state_45bind operation f);;
let rec state_45map = fun f operation -> (state_45flatmap (fun _226_156_168x -> (state_45return (f _226_156_168x))) operation);;
let rec state_45lift = fun _value -> (state_45return _value);;
type ('Tvalue) dictionary = CTrieNode : ('Tvalue) maybe * ((int32,('Tvalue) dictionary) pair) list -> ('Tvalue) dictionary;;
let rec _constant_dictionary_45empty = (CTrieNode (CNone,CEmpty));;let rec dictionary_45empty = fun () -> _constant_dictionary_45empty;;
let rec _39dictionary_45value = fun dictionary -> (match dictionary with (CTrieNode (_value,_95)) -> _value);;
let rec _39dictionary_45children = fun dictionary -> (match dictionary with (CTrieNode (_95,children)) -> children);;
let rec _39dictionary_45find_45child = fun char dictionary -> (maybe_45map pair_45right (list_45find_45first (fun _226_156_168x -> ((_61 char) (pair_45left _226_156_168x))) (_39dictionary_45children dictionary)));;
let rec _39dictionary_45remove_45child = fun char dictionary -> (match dictionary with (CTrieNode (_value,children)) -> (CTrieNode (_value,(list_45exclude (fun _226_156_168x -> ((_61 char) (pair_45left _226_156_168x))) children))));;
let rec dictionary_45entries_39_39 = fun dictionary_45entries_39 dictionary -> (list_45flatmap (fun _226_156_168x -> (dictionary_45entries_39 (pair_45right _226_156_168x))) (_39dictionary_45children dictionary));;
let rec dictionary_45entries_39 = fun key dictionary -> (match (_39dictionary_45value dictionary) with (CSome (_value)) -> (CCons ((CPair (CEmpty,_value)),(dictionary_45entries_39_39 (dictionary_45entries_39 key) dictionary))) | CNone -> (dictionary_45entries_39_39 (dictionary_45entries_39 key) dictionary));;
let rec dictionary_45entries = fun dictionary -> (dictionary_45entries_39 CEmpty dictionary);;
let rec dictionary_45set = fun key new_45value dictionary -> (match (string_45first key) with CNone -> (CTrieNode ((CSome (new_45value)),(_39dictionary_45children dictionary))) | (CSome (char)) -> ((fun _226_156_168x -> ((fun child -> (CTrieNode ((_39dictionary_45value dictionary),(CCons ((CPair (char,child)),(_39dictionary_45children (_39dictionary_45remove_45child char dictionary))))))) ((dictionary_45set (string_45rest key) new_45value) ((maybe_45else dictionary_45empty) ((_39dictionary_45find_45child char) _226_156_168x))))) dictionary));;
let rec dictionary_45get = fun key dictionary -> (match (string_45first key) with (CSome (char)) -> (maybe_45flatmap (dictionary_45get (string_45rest key)) (_39dictionary_45find_45child char dictionary)) | CNone -> (_39dictionary_45value dictionary));;
let rec dictionary_45of = fun entries -> (list_45foldl (pair_45map dictionary_45set) (dictionary_45empty ()) entries);;
let rec dictionary_45singleton = fun key _value -> (dictionary_45set key _value (dictionary_45empty ()));;
let rec dictionary_45get_45or = fun key default dictionary -> (match (dictionary_45get key dictionary) with (CSome (_value)) -> _value | CNone -> default);;
let rec parts_45are_45empty_63 = fun parts -> (match parts with CEmpty -> CTrue | (CCons (part,CEmpty)) -> (string_45empty_63 part) | _95 -> CFalse);;
let rec transform_45line = fun line -> (match (string_45split (124l) line) with (CCons (name,parts)) -> (string_45concat (string_45from_45list (CCons ((40l),(CCons ((100l),(CCons ((101l),(CCons ((102l),(CCons ((32l),(CCons ((100l),(CCons ((97l),(CCons ((116l),(CCons ((97l),(CCons ((45l),CEmpty))))))))))))))))))))) (string_45concat (string_45trim name) (string_45concat (string_45from_45list (CCons ((32l),(CCons ((40l),(CCons ((41l),(CCons ((32l),(CCons ((40l),(CCons ((115l),(CCons ((116l),(CCons ((114l),(CCons ((105l),(CCons ((110l),(CCons ((103l),(CCons ((45l),(CCons ((102l),(CCons ((114l),(CCons ((111l),(CCons ((109l),(CCons ((45l),(CCons ((108l),(CCons ((105l),(CCons ((115l),(CCons ((116l),(CCons ((32l),CEmpty))))))))))))))))))))))))))))))))))))))))))))) (match (parts_45are_45empty_63 parts) with CTrue -> (string_45from_45list (CCons ((69l),(CCons ((109l),(CCons ((112l),(CCons ((116l),(CCons ((121l),(CCons ((41l),(CCons ((41l),CEmpty))))))))))))))) | CFalse -> (string_45concat (string_45from_45list (CCons ((40l),(CCons ((108l),(CCons ((105l),(CCons ((115l),(CCons ((116l),(CCons ((32l),CEmpty))))))))))))) (string_45concat (string_45join (string_45of_45char (32l)) (list_45map string_45from_45int32 (string_45to_45list (string_45join (string_45of_45char (124l)) parts)))) (string_45from_45list (CCons ((41l),(CCons ((41l),(CCons ((41l),CEmpty))))))))))))) | CEmpty -> (string_45empty ()));;
let rec string_gen = fun stdin -> (match (string_45collect_45from_45indexed_45iterator (fun _95 -> CTrue) (chunk_45to_45indexed_45iterator stdin)) with (CPair (_95,stdin)) -> (CResult ((string_45join (string_45of_45char (10l)) (list_45map transform_45line (string_45split (10l) stdin))))));;
let getenv name = try (Sys.getenv name) with Not_found -> ""
let performance = getenv "REUSE_TIME" = "true";;


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
let _chunk_equal a b =
        match String.equal a b with
                | true -> CTrue
                | false -> CFalse;;
let rec _chunk_slice offset size s =
        let string_size = String.length s in
        let offset = Int32.to_int offset in
        let size = Int32.to_int size in
        if offset < 0 || size < 0 || offset + size > string_size then
                CChunk (s, _chunk_size, _chunk_get, _chunk_slice, _chunk_equal)
        else
                CChunk (String.sub s offset size, _chunk_size, _chunk_get, _chunk_slice, _chunk_equal);;

let _stdin_list =
        CChunk (_stdin_string, _chunk_size, _chunk_get, _chunk_slice, _chunk_equal);;

let string_gen_start = Unix.gettimeofday ();;
let string_gen_output = string_gen _stdin_list;;
let string_gen_end = Unix.gettimeofday ();;
let string_gen_time = string_gen_end -. string_gen_start;;

if performance then
    (Printf.printf "%f" string_gen_time ; exit 0)
else
    match string_gen_output with
          CResult (result) -> Printf.printf "%s" (_list_to_string result) ; exit 0
        | CError (error) -> Printf.eprintf "%s" (_list_to_string error) ; exit 1;;


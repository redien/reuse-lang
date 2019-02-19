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
let rec maybe_45map = fun f maybe -> (match maybe with (CSome (x)) -> (CSome ((f x))) | CNone -> CNone);;
let rec maybe_45flatmap = fun f maybe -> (match maybe with (CSome (x)) -> (f x) | CNone -> CNone);;
let rec maybe_45filter = fun f maybe -> (match maybe with (CSome (x)) -> (match (f x) with CTrue -> maybe | CFalse -> CNone) | CNone -> CNone);;
let rec maybe_45else = fun f maybe -> (match maybe with CNone -> (f ()) | (CSome (x)) -> x);;
type ('Telement) indexed_45iterator = CIndexedIterator : 'Tcollection * int32 * ('Tcollection -> int32 -> ('Telement) maybe) * (('Telement) indexed_45iterator -> 'Tcollection -> int32 -> ('Telement) indexed_45iterator) -> ('Telement) indexed_45iterator;;
let rec indexed_45iterator_45next = fun iterator -> (match iterator with (CIndexedIterator (collection,index,_95,next)) -> (next iterator collection index));;
let rec indexed_45iterator_45get = fun iterator -> (match iterator with (CIndexedIterator (collection,index,get,_95)) -> (get collection index));;
let rec indexed_45iterator_45index = fun iterator -> (match iterator with (CIndexedIterator (_95,index,_95_95,_95_95_95)) -> index);;
let rec indexed_45iterator_45foldl = fun f initial iterator -> (match (indexed_45iterator_45get iterator) with CNone -> initial | (CSome (x)) -> (indexed_45iterator_45foldl f (f x initial) (indexed_45iterator_45next iterator)));;
type ('Ta) list = CCons : 'Ta * ('Ta) list -> ('Ta) list | CEmpty;;
let rec list_45cons = fun x xs -> (CCons (x,xs));;
let rec list_45from = fun x -> (CCons (x,CEmpty));;
let rec list_45from_45range = fun _95from _95to -> (match (_60 _95from _95to) with CTrue -> (CCons (_95from,(list_45from_45range (Int32.add _95from (1l)) _95to))) | CFalse -> CEmpty);;
let rec list_45first = fun list -> (match list with (CCons (x,_95)) -> (CSome (x)) | CEmpty -> CNone);;
let rec list_45rest = fun list -> (match list with (CCons (_95,rest)) -> rest | CEmpty -> CEmpty);;
let rec list_45empty_63 = fun list -> (match list with (CCons (_95,_95_95)) -> CFalse | CEmpty -> CTrue);;
let rec list_45size_39 = fun list size -> (match list with (CCons (_95,rest)) -> (list_45size_39 rest (Int32.add size (1l))) | CEmpty -> size);;
let rec list_45size = fun list -> (list_45size_39 list (0l));;
let rec list_45foldrk = fun f initial list continue -> (match list with CEmpty -> (continue initial) | (CCons (x,xs)) -> (list_45foldrk f initial xs (fun _value -> (f x _value continue))));;
let rec list_45foldlk = fun f initial list continue -> (match list with CEmpty -> (continue initial) | (CCons (x,xs)) -> (f x initial (fun new_45value -> (list_45foldlk f new_45value xs continue))));;
let rec list_45foldr = fun f initial list -> (list_45foldrk (fun x _value continue -> (continue (f x _value))) initial list (fun x -> x));;
let rec list_45foldl = fun f initial list -> (match list with CEmpty -> initial | (CCons (x,xs)) -> (list_45foldl f (f x initial) xs));;
let rec list_45concat = fun a b -> (list_45foldr list_45cons b a);;
let rec list_45append = fun l x -> (list_45foldr list_45cons (CCons (x,CEmpty)) l);;
let rec list_45reverse = fun list -> (list_45foldl list_45cons CEmpty list);;
let rec list_45map = fun f list -> (list_45foldr (fun head tail -> (list_45cons (f head) tail)) CEmpty list);;
let rec list_45flatmap = fun f list -> (list_45foldr (fun head tail -> (list_45concat (f head) tail)) CEmpty list);;
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
let rec string_45of_45char = fun character -> (CCons (character,CEmpty));;
let rec string_45first = fun string -> (list_45first string);;
let rec string_45rest = fun string -> (list_45rest string);;
let rec string_45concat = fun a b -> (match a with CEmpty -> b | (CCons (x,xs)) -> (CCons (x,(string_45concat xs b))));;
let rec string_45append = fun a b -> (string_45concat b a);;
let rec string_45join = fun separator list -> (match list with (CCons (first,rest)) -> (list_45foldl (fun string joined -> (string_45concat joined (string_45concat separator string))) first rest) | CEmpty -> CEmpty);;
let rec string_45split_39 = fun separator string current parts -> (match string with CEmpty -> (list_45reverse (CCons ((list_45reverse current),parts))) | (CCons (c,rest)) -> (match (_61 separator c) with CTrue -> (string_45split_39 separator rest CEmpty (CCons ((list_45reverse current),parts))) | CFalse -> (string_45split_39 separator rest (CCons (c,current)) parts)));;
let rec string_45split = fun separator string -> (string_45split_39 separator string CEmpty CEmpty);;
let rec string_45trim_45start = fun string -> (match string with (CCons (x,xs)) -> (match (_61 x (32l)) with CTrue -> (string_45trim_45start xs) | CFalse -> string) | CEmpty -> string);;
let rec string_45trim_45end = fun string -> (list_45reverse (string_45trim_45start (list_45reverse string)));;
let rec string_45trim = fun string -> (string_45trim_45start (string_45trim_45end string));;
let rec string_45empty_63 = fun string -> (match string with CEmpty -> CTrue | _95 -> CFalse);;
let rec string_45equal_63 = fun a b -> (match a with (CCons (xa,xas)) -> (match b with (CCons (xb,xbs)) -> (_and (_61 xa xb) (string_45equal_63 xas xbs)) | CEmpty -> (string_45empty_63 a)) | CEmpty -> (string_45empty_63 b));;
let rec string_45point_45is_45digit = fun point -> (_and (_62 point (47l)) (_60 point (58l)));;
let rec string_45to_45int32_39_39 = fun string_45to_45int32_39 string accumulator x -> (string_45to_45int32_39 string (CSome ((Int32.add (Int32.mul (10l) accumulator) (Int32.sub x (48l))))));;
let rec string_45to_45int32_39 = fun string accumulator -> (match string with CEmpty -> accumulator | (CCons (x,rest)) -> (maybe_45flatmap (fun accumulator -> ((fun _226_156_168x -> ((maybe_45flatmap (string_45to_45int32_39_39 string_45to_45int32_39 rest accumulator)) ((maybe_45filter string_45point_45is_45digit) _226_156_168x))) (CSome (x)))) accumulator));;
let rec string_45to_45int32 = fun string -> (match string with (CCons (45l,string)) -> (match (string_45empty_63 string) with CTrue -> CNone | CFalse -> (maybe_45map (fun x -> (Int32.mul (-1l) x)) (string_45to_45int32 string))) | _95 -> (string_45to_45int32_39 string (CSome ((0l)))));;
let rec string_45from_45int32_39 = fun integer string -> (match (_62 integer (9l)) with CTrue -> (string_45from_45int32_39 (Int32.div integer (10l)) (CCons ((Int32.add (Int32.rem integer (10l)) (48l)),string))) | CFalse -> (CCons ((Int32.add integer (48l)),string)));;
let rec string_45from_45int32 = fun integer -> (match (_60 integer (0l)) with CTrue -> (match (_61 integer (-2147483648l)) with CTrue -> (CCons ((45l),(CCons ((50l),(CCons ((49l),(CCons ((52l),(CCons ((55l),(CCons ((52l),(CCons ((56l),(CCons ((51l),(CCons ((54l),(CCons ((52l),(CCons ((56l),CEmpty)))))))))))))))))))))) | CFalse -> (CCons ((45l),(string_45from_45int32 (Int32.mul integer (-1l)))))) | CFalse -> (string_45from_45int32_39 integer CEmpty));;
type ('Tv,'Te) result = CResult : 'Tv -> ('Tv,'Te) result | CError : 'Te -> ('Tv,'Te) result;;
let rec result_45lift = fun result -> (CResult (result));;
let rec result_45error = fun error -> (CError (error));;
let rec result_45map = fun f result -> (match result with (CResult (x)) -> (CResult ((f x))) | (CError (error)) -> (CError (error)));;
let rec result_45map_45error = fun f result -> (match result with (CResult (x)) -> (CResult (x)) | (CError (error)) -> (CError ((f error))));;
let rec result_45flatmap = fun f result -> (match result with (CResult (x)) -> (f x) | (CError (error)) -> (CError (error)));;
let rec result_45either = fun f g result -> (match result with (CResult (x)) -> (f x) | (CError (x)) -> (g x));;
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
let rec dictionary_45set = fun key new_45value dictionary -> (match key with CEmpty -> (CTrieNode ((CSome (new_45value)),(_39dictionary_45children dictionary))) | (CCons (char,rest)) -> ((fun _226_156_168x -> ((fun child -> (CTrieNode ((_39dictionary_45value dictionary),(CCons ((CPair (char,child)),(_39dictionary_45children (_39dictionary_45remove_45child char dictionary))))))) ((dictionary_45set rest new_45value) ((maybe_45else dictionary_45empty) ((_39dictionary_45find_45child char) _226_156_168x))))) dictionary));;
let rec dictionary_45get = fun key dictionary -> (match key with (CCons (char,rest)) -> (maybe_45flatmap (dictionary_45get rest) (_39dictionary_45find_45child char dictionary)) | CEmpty -> (_39dictionary_45value dictionary));;
let rec dictionary_45of = fun entries -> (list_45foldl (pair_45map dictionary_45set) (dictionary_45empty ()) entries);;
let rec dictionary_45singleton = fun key _value -> (dictionary_45set key _value (dictionary_45empty ()));;
let rec dictionary_45get_45or = fun key default dictionary -> (match (dictionary_45get key dictionary) with (CSome (_value)) -> _value | CNone -> default);;
let rec transform_45line = fun line -> (match (string_45split (124l) line) with (CCons (name,parts)) -> (string_45concat (CCons ((40l),(CCons ((100l),(CCons ((101l),(CCons ((102l),(CCons ((32l),(CCons ((100l),(CCons ((97l),(CCons ((116l),(CCons ((97l),(CCons ((45l),CEmpty)))))))))))))))))))) (string_45concat (string_45trim name) (string_45concat (CCons ((32l),(CCons ((40l),(CCons ((41l),(CCons ((32l),CEmpty)))))))) (match parts with (CCons (CEmpty,CEmpty)) -> (CCons ((69l),(CCons ((109l),(CCons ((112l),(CCons ((116l),(CCons ((121l),(CCons ((41l),CEmpty)))))))))))) | _95 -> (string_45concat (CCons ((40l),(CCons ((108l),(CCons ((105l),(CCons ((115l),(CCons ((116l),(CCons ((32l),CEmpty)))))))))))) (string_45concat (string_45join (CCons ((32l),CEmpty)) (list_45map string_45from_45int32 (string_45join (CCons ((124l),CEmpty)) parts))) (CCons ((41l),(CCons ((41l),CEmpty)))))))))) | CEmpty -> CEmpty);;
let rec string_gen = fun stdin_45iterator -> (match (list_45collect_45from_45indexed_45iterator (fun _95 -> CTrue) stdin_45iterator) with (CPair (_95,stdin)) -> (CResult ((string_45join (CCons ((10l),CEmpty)) (list_45map transform_45line (string_45split (10l) stdin))))));;

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

let _list_to_string = fun input -> (_list_to_string_r input "");;

let _stdin_list = CIndexedIterator (
        _stdin_string,
        0l,
        (fun s index ->
                let i = (Int32.to_int index) in
                if i < (String.length s) && i >= 0 then
                        CSome (Int32.of_int (Char.code (String.get s i)))
                else
                        CNone),
        (fun iter _ __ ->
                match iter with
                | CIndexedIterator (s, i, get, next) -> CIndexedIterator (s, Int32.succ i, get, next)));;

let output = string_gen _stdin_list in
    match output with
        CResult (result) -> Printf.printf "%s" (_list_to_string result) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (_list_to_string error) ; exit 1;;


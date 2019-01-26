type boolean = CTrue | CFalse;;
let rec not = fun a -> (match a with CTrue -> CFalse | CFalse -> CTrue);;
let rec _and = fun a b -> (match a with CTrue -> b | CFalse -> CFalse);;
let rec _or = fun a b -> (match a with CTrue -> CTrue | CFalse -> b);;
let rec _60 = fun a b -> (if a<b then CTrue else CFalse);;
let rec _62 = fun a b -> (_60 b a);;
let rec _61 = fun a b -> (not (_or (_60 a b) (_62 a b)));;
let rec _60_61 = fun a b -> (_or (_60 a b) (_61 a b));;
let rec _62_61 = fun a b -> (_or (_62 a b) (_61 a b));;
type ('a,'b) pair = CPair : 'a * 'b -> ('a,'b) pair;;
let rec pair_45cons = fun a b -> (CPair (a,b));;
let rec pair_45left = fun pair -> (match pair with (CPair (x,_95)) -> x);;
let rec pair_45right = fun pair -> (match pair with (CPair (_95,x)) -> x);;
let rec pair_45map_45left = fun f pair -> (match pair with (CPair (x,y)) -> (CPair ((f x),y)));;
let rec pair_45map_45right = fun f pair -> (match pair with (CPair (x,y)) -> (CPair (x,(f y))));;
type ('a) maybe = CSome : 'a -> ('a) maybe | CNone;;
let rec maybe_45map = fun f maybe -> (match maybe with (CSome (x)) -> (CSome ((f x))) | CNone -> CNone);;
let rec maybe_45flatmap = fun f maybe -> (match maybe with (CSome (x)) -> (f x) | CNone -> CNone);;
let rec maybe_45filter = fun f maybe -> (match maybe with (CSome (x)) -> (match (f x) with CTrue -> maybe | CFalse -> CNone) | CNone -> CNone);;
let rec maybe_45else = fun f maybe -> (match maybe with CNone -> (f ()) | (CSome (x)) -> x);;
type ('element) indexed_45iterator = CIndexedIterator : 'collection * int32 * ('collection -> int32 -> ('element) maybe) * (('element) indexed_45iterator -> 'collection -> int32 -> ('element) indexed_45iterator) -> ('element) indexed_45iterator;;
let rec indexed_45iterator_45next = fun iterator -> (match iterator with (CIndexedIterator (collection,index,_95,next)) -> (next iterator collection index));;
let rec indexed_45iterator_45get = fun iterator -> (match iterator with (CIndexedIterator (collection,index,get,_95)) -> (get collection index));;
let rec indexed_45iterator_45index = fun iterator -> (match iterator with (CIndexedIterator (_95,index,_95_95,_95_95_95)) -> index);;
let rec indexed_45iterator_45foldl = fun f initial iterator -> (match (indexed_45iterator_45get iterator) with CNone -> initial | (CSome (x)) -> (indexed_45iterator_45foldl f (f x initial) (indexed_45iterator_45next iterator)));;
type ('a) list = CCons : 'a * ('a) list -> ('a) list | CEmpty;;
let rec list_45cons = fun x xs -> (CCons (x,xs));;
let rec list_45from = fun x -> (CCons (x,CEmpty));;
let rec list_45from_45range = fun _95from _95to -> (match (_60 _95from _95to) with CTrue -> (CCons (_95from,(list_45from_45range (Int32.add _95from (Int32.of_int  (1))) _95to))) | CFalse -> CEmpty);;
let rec list_45first = fun list -> (match list with (CCons (x,_95)) -> (CSome (x)) | CEmpty -> CNone);;
let rec list_45rest = fun list -> (match list with (CCons (_95,rest)) -> rest | CEmpty -> CEmpty);;
let rec list_45empty_63 = fun list -> (match list with (CCons (_95,_95_95)) -> CFalse | CEmpty -> CTrue);;
let rec list_45size_39 = fun list size -> (match list with (CCons (_95,rest)) -> (list_45size_39 rest (Int32.add size (Int32.of_int  (1)))) | CEmpty -> size);;
let rec list_45size = fun list -> (list_45size_39 list (Int32.of_int  (0)));;
let rec list_45foldrk = fun f initial list continue -> (match list with CEmpty -> (continue initial) | (CCons (x,xs)) -> (list_45foldrk f initial xs (fun value -> (f x value continue))));;
let rec list_45foldlk = fun f initial list continue -> (match list with CEmpty -> (continue initial) | (CCons (x,xs)) -> (f x initial (fun new_45value -> (list_45foldlk f new_45value xs continue))));;
let rec list_45foldr = fun f initial list -> (list_45foldrk (fun x value continue -> (continue (f x value))) initial list (fun x -> x));;
let rec list_45foldl = fun f initial list -> (match list with CEmpty -> initial | (CCons (x,xs)) -> (list_45foldl f (f x initial) xs));;
let rec list_45concat = fun a b -> (list_45foldr list_45cons b a);;
let rec list_45append = fun l x -> (list_45foldr list_45cons (CCons (x,CEmpty)) l);;
let rec list_45reverse = fun list -> (list_45foldl list_45cons CEmpty list);;
let rec list_45map = fun f list -> (list_45foldr (fun head tail -> (list_45cons (f head) tail)) CEmpty list);;
let rec list_45flatmap = fun f list -> (list_45foldr (fun head tail -> (list_45concat (f head) tail)) CEmpty list);;
let rec list_45zip_39 = fun xs ys collected -> (match xs with CEmpty -> collected | (CCons (x,xs)) -> (match ys with CEmpty -> collected | (CCons (y,ys)) -> (list_45zip_39 xs ys (CCons ((CPair (x,y)),collected)))));;
let rec list_45zip = fun xs ys -> (list_45reverse (list_45zip_39 xs ys CEmpty));;
let rec list_45find_45first = fun predicate list -> (match list with CEmpty -> CNone | (CCons (x,xs)) -> (match (predicate x) with CTrue -> (CSome (x)) | CFalse -> (list_45find_45first predicate xs)));;
let rec list_45filter = fun f list -> (list_45foldr (fun head tail -> (match (f head) with CTrue -> (CCons (head,tail)) | CFalse -> tail)) CEmpty list);;
let rec list_45any_63 = fun f list -> (not (list_45empty_63 (list_45filter f list)));;
let rec list_45indexed_45iterator_45get = fun collection _95 -> (match collection with (CCons (x,_95)) -> (CSome (x)) | CEmpty -> CNone);;
let rec list_45indexed_45iterator_45next = fun iterator collection index -> (match collection with (CCons (_95,xs)) -> (CIndexedIterator (xs,(Int32.add index (Int32.of_int  (1))),list_45indexed_45iterator_45get,list_45indexed_45iterator_45next)) | CEmpty -> iterator);;
let rec list_45to_45indexed_45iterator = fun list -> (CIndexedIterator (list,(Int32.of_int  (0)),list_45indexed_45iterator_45get,list_45indexed_45iterator_45next));;
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
let rec string_45trim_45start = fun string -> (match string with (CCons (x,xs)) -> (match (_61 x (Int32.of_int  (32))) with CTrue -> (string_45trim_45start xs) | CFalse -> string) | CEmpty -> string);;
let rec string_45trim_45end = fun string -> (list_45reverse (string_45trim_45start (list_45reverse string)));;
let rec string_45trim = fun string -> (string_45trim_45start (string_45trim_45end string));;
let rec string_45empty_63 = fun string -> (match string with CEmpty -> CTrue | _95 -> CFalse);;
let rec string_45equal_63 = fun a b -> (match a with (CCons (xa,xas)) -> (match b with (CCons (xb,xbs)) -> (_and (_61 xa xb) (string_45equal_63 xas xbs)) | CEmpty -> (string_45empty_63 a)) | CEmpty -> (string_45empty_63 b));;
let rec string_45point_45is_45digit = fun point -> (_and (_62 point (Int32.of_int  (47))) (_60 point (Int32.of_int  (58))));;
let rec string_45to_45int32_39_39 = fun string_45to_45int32_39 string accumulator x -> (string_45to_45int32_39 string (CSome ((Int32.add (Int32.mul (Int32.of_int  (10)) accumulator) (Int32.sub x (Int32.of_int  (48)))))));;
let rec string_45to_45int32_39 = fun string accumulator -> (match string with CEmpty -> accumulator | (CCons (x,rest)) -> (maybe_45flatmap (fun accumulator -> ((fun (_x) -> _x |> (maybe_45filter string_45point_45is_45digit) |> (maybe_45flatmap (string_45to_45int32_39_39 string_45to_45int32_39 rest accumulator))) (CSome (x)))) accumulator));;
let rec string_45to_45int32 = fun string -> (match string with (CCons (45l,string)) -> (match (string_45empty_63 string) with CTrue -> CNone | CFalse -> (maybe_45map (fun x -> (Int32.mul (Int32.of_int  (-1)) x)) (string_45to_45int32 string))) | _95 -> (string_45to_45int32_39 string (CSome ((Int32.of_int  (0))))));;
let rec string_45from_45int32_39 = fun integer string -> (match (_62 integer (Int32.of_int  (9))) with CTrue -> (string_45from_45int32_39 (Int32.div integer (Int32.of_int  (10))) (CCons ((Int32.add (Int32.rem integer (Int32.of_int  (10))) (Int32.of_int  (48))),string))) | CFalse -> (CCons ((Int32.add integer (Int32.of_int  (48))),string)));;
let rec string_45from_45int32 = fun integer -> (match (_60 integer (Int32.of_int  (0))) with CTrue -> (match (_61 integer (Int32.of_int  (-2147483648))) with CTrue -> (CCons ((Int32.of_int  (45)),CCons ((Int32.of_int  (50)),CCons ((Int32.of_int  (49)),CCons ((Int32.of_int  (52)),CCons ((Int32.of_int  (55)),CCons ((Int32.of_int  (52)),CCons ((Int32.of_int  (56)),CCons ((Int32.of_int  (51)),CCons ((Int32.of_int  (54)),CCons ((Int32.of_int  (52)),CCons ((Int32.of_int  (56)),CEmpty)))))))))))) | CFalse -> (CCons ((Int32.of_int  (45)),(string_45from_45int32 (Int32.mul integer (Int32.of_int  (-1))))))) | CFalse -> (string_45from_45int32_39 integer CEmpty));;
type ('v,'e) result = CResult : 'v -> ('v,'e) result | CError : 'e -> ('v,'e) result;;
let rec result_45lift = fun result -> (CResult (result));;
let rec result_45error = fun error -> (CError (error));;
let rec result_45map = fun f result -> (match result with (CResult (x)) -> (CResult ((f x))) | (CError (error)) -> (CError (error)));;
let rec result_45map_45error = fun f result -> (match result with (CResult (x)) -> (CResult (x)) | (CError (error)) -> (CError ((f error))));;
let rec result_45flatmap = fun f result -> (match result with (CResult (x)) -> (f x) | (CError (error)) -> (CError (error)));;
let rec result_45error_63 = fun result -> (match result with (CError (_95)) -> CTrue | _95 -> CFalse);;
let rec result_45filter_45list = fun list -> (list_45foldr (fun result new_45list -> (match result with (CResult (x)) -> (CCons (x,new_45list)) | _95 -> new_45list)) CEmpty list);;
let rec result_45concat = fun list -> (match (list_45filter result_45error_63 list) with (CCons ((CError (error)),_95)) -> (CError (error)) | (CCons ((CResult (_95)),_95_95)) -> (CResult (CEmpty)) | CEmpty -> (CResult ((result_45filter_45list list))));;
let rec result_45of_45maybe = fun error maybe -> (match maybe with (CSome (x)) -> (CResult (x)) | CNone -> (CError (error)));;
type ('a,'i) parser = CParser : ('i -> (('a,'i) pair) maybe) -> ('a,'i) parser;;
let rec parser_45result = fun x -> (CParser ((fun input -> (CSome ((CPair (x,input)))))));;
let rec parser_45fail = fun () -> (CParser ((fun _95 -> CNone)));;
let rec parser_45apply = fun parser input -> (match parser with (CParser (p)) -> (p input));;
let rec parser_45run = fun parser input -> (maybe_45map pair_45left (parser_45apply parser input));;
let rec parser_45bind = fun f parser -> (CParser ((fun input -> (match (parser_45apply parser input) with CNone -> CNone | (CSome ((CPair (value,rest)))) -> (parser_45apply (f value) rest)))));;
let rec parser_45if = fun predicate parser -> (parser_45bind (fun value -> (match (predicate value) with CTrue -> (parser_45result value) | CFalse -> (parser_45fail ()))) parser);;
let rec parser_45and = fun f parser_45a parser_45b -> (parser_45bind (fun a -> (parser_45bind (fun b -> (f a b)) parser_45b)) parser_45a);;
let rec parser_45or = fun parser_45a parser_45b -> (CParser ((fun input -> (match (parser_45apply parser_45a input) with (CSome (x)) -> (CSome (x)) | CNone -> (parser_45apply parser_45b input)))));;
let rec parser_45zero_45or_45more_39 = fun parser_45zero_45or_45more parser f -> (parser_45bind (fun first -> (parser_45bind (fun rest -> (parser_45result (f first rest))) (parser_45zero_45or_45more parser))) parser);;
let rec parser_45zero_45or_45more = fun f initial parser -> (parser_45or (parser_45zero_45or_45more_39 (parser_45zero_45or_45more f initial) parser f) (parser_45result initial));;
let rec parser_45one_45or_45more = fun f initial parser -> (parser_45and (fun first rest -> (parser_45result (f first rest))) parser (parser_45zero_45or_45more f initial parser));;
type ('s,'v) state = COperation : ('s -> ('s,'v) pair) -> ('s,'v) state;;
let rec state_45run = fun state operation -> (match operation with (COperation (f)) -> (f state));;
let rec state_45final_45value = fun initial_45state operation -> (match (state_45run initial_45state operation) with (CPair (_95,value)) -> value);;
let rec state_45return = fun value -> (COperation ((fun state -> (CPair (state,value)))));;
let rec state_45bind = fun operation f -> (COperation ((fun state -> (match (state_45run state operation) with (CPair (new_45state,new_45value)) -> (state_45run new_45state (f new_45value))))));;
let rec state_45get = fun () -> (COperation ((fun state -> (CPair (state,state)))));;
let rec state_45set = fun state -> (COperation ((fun _95 -> (CPair (state,state)))));;
let rec state_45modify = fun f -> (state_45bind (state_45get ()) (fun state -> (state_45set (f state))));;
let rec state_45let = fun value f -> (state_45bind (state_45return value) f);;
let rec state_45foldr = fun f initial_45value operations -> (list_45foldr (fun operation chain -> (state_45bind operation (fun x -> (state_45bind chain (fun xs -> (state_45return (f x xs))))))) (state_45return initial_45value) operations);;
let rec state_45foreach = fun f xs -> (state_45foldr list_45cons CEmpty (list_45map f xs));;
let rec state_45flatmap = fun f operation -> (state_45bind operation f);;
let rec state_45map = fun f operation -> (state_45flatmap (fun (_x) -> _x |> f |> state_45return) operation);;
let rec state_45lift = fun value -> (state_45return value);;
type ('value) dictionary = CDictionary : (((int32) list,'value) pair) list -> ('value) dictionary;;
let rec dictionary_45new = fun () -> (CDictionary (CEmpty));;
let rec dictionary_45entries = fun dictionary -> (match dictionary with (CDictionary (entries)) -> entries);;
let rec entry_45get_45key_39 = fun entry -> (match entry with (CPair (key,_95)) -> key);;
let rec entry_45get_45value_39 = fun entry -> (match entry with (CPair (_95,value)) -> value);;
let rec entry_45matches_45key_39 = fun key entry -> (string_45equal_63 key (entry_45get_45key_39 entry));;
let rec entries_45matching_45key_39 = fun key dictionary -> ((fun (_x) -> _x |> dictionary_45entries |> (list_45filter (entry_45matches_45key_39 key))) dictionary);;
let rec dictionary_45lookup = fun key dictionary -> ((fun (_x) -> _x |> (entries_45matching_45key_39 key) |> list_45first |> (maybe_45map entry_45get_45value_39)) dictionary);;
let rec dictionary_45add = fun key value dictionary -> (CDictionary ((CCons ((CPair (key,value)),(dictionary_45entries dictionary)))));;
let rec transform_45line = fun line -> (match (string_45split (Int32.of_int  (124)) line) with (CCons (name,parts)) -> (string_45concat (CCons ((Int32.of_int  (40)),CCons ((Int32.of_int  (100)),CCons ((Int32.of_int  (101)),CCons ((Int32.of_int  (102)),CCons ((Int32.of_int  (32)),CCons ((Int32.of_int  (100)),CCons ((Int32.of_int  (97)),CCons ((Int32.of_int  (116)),CCons ((Int32.of_int  (97)),CCons ((Int32.of_int  (45)),CEmpty))))))))))) (string_45concat (string_45trim name) (string_45concat (CCons ((Int32.of_int  (32)),CCons ((Int32.of_int  (40)),CCons ((Int32.of_int  (41)),CCons ((Int32.of_int  (32)),CEmpty))))) (match parts with (CCons (CEmpty,CEmpty)) -> (CCons ((Int32.of_int  (69)),CCons ((Int32.of_int  (109)),CCons ((Int32.of_int  (112)),CCons ((Int32.of_int  (116)),CCons ((Int32.of_int  (121)),CCons ((Int32.of_int  (41)),CEmpty))))))) | _95 -> (string_45concat (CCons ((Int32.of_int  (40)),CCons ((Int32.of_int  (108)),CCons ((Int32.of_int  (105)),CCons ((Int32.of_int  (115)),CCons ((Int32.of_int  (116)),CCons ((Int32.of_int  (32)),CEmpty))))))) (string_45concat (string_45join (CCons ((Int32.of_int  (32)),CEmpty)) (list_45map string_45from_45int32 (string_45join (CCons ((Int32.of_int  (124)),CEmpty)) parts))) (CCons ((Int32.of_int  (41)),CCons ((Int32.of_int  (41)),CEmpty))))))))) | CEmpty -> CEmpty);;
let rec string_gen = fun stdin -> (CResult ((string_45join (CCons ((Int32.of_int  (13)),CEmpty)) (list_45map transform_45line (string_45split (Int32.of_int  (13)) stdin)))));;

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

let rec _string_to_list_i = fun input i result ->
    if i > 0 then
        let sub_input = (String.sub input 0 ((String.length input) - 1)) in
            _string_to_list_i sub_input (i - 1) (CCons ((Int32.of_int (Char.code (String.get input i))), result))
    else
        CCons ((Int32.of_int (Char.code (String.get input i))), result);;

let _string_to_list = fun input ->
    if String.length input == 0
    then CEmpty
    else _string_to_list_i input ((String.length input) - 1) CEmpty;;

let rec _list_to_string_r = fun input result ->
    match input with
          CCons(x, rest) ->
            let string_from_int = (String.make 1 (Char.chr (Int32.to_int x))) in
            let new_result = (String.concat "" (result :: string_from_int :: [])) in
                (_list_to_string_r rest new_result)
        | CEmpty -> result;;

let _list_to_string = fun input -> (_list_to_string_r input "");;

let _stdin_list = _string_to_list _stdin_string;;

let output = string_gen _stdin_list in
    match output with
        CResult (result) -> Printf.printf "%s" (_list_to_string result) ; exit 0
      | CError (error) -> Printf.eprintf "%s" (_list_to_string error) ; exit 1;;


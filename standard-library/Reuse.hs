{-# LANGUAGE ExistentialQuantification, BangPatterns #-}
module Reuse where
import Data.Int ; import Prelude hiding (not, and, or, mod)

_int32_add :: Int32 -> Int32 -> Int32 ; _int32_add a b = a + b ; _int32_mul :: Int32 -> Int32 -> Int32 ; _int32_mul a b = a * b ; _int32_sub :: Int32 -> Int32 -> Int32 ; _int32_sub a b = a - b ;
data Tboolean = CTrue | CFalse
not = \ !a -> (case a of CTrue -> CFalse ; CFalse -> CTrue)
and = \ !a !b -> (case a of CTrue -> b ; CFalse -> CFalse)
or = \ !a !b -> (case a of CTrue -> CTrue ; CFalse -> b)
_60 = \ !a !b -> (if a<b then CTrue else CFalse)
_62 = \ !a !b -> (_60 b a)
_61 = \ !a !b -> (not (or (_60 a b) (_62 a b)))
_60_61 = \ !a !b -> (or (_60 a b) (_61 a b))
_62_61 = \ !a !b -> (or (_62 a b) (_61 a b))
data Tpair a b = CPair !a !b
pair_45cons = \ !a !b -> (CPair a b)
pair_45left = \ !pair -> (case pair of (CPair !x !_95) -> x)
pair_45right = \ !pair -> (case pair of (CPair !_95 !x) -> x)
pair_45map = \ !f !pair -> (case pair of (CPair !x !y) -> (f x y))
pair_45map_45left = \ !f !pair -> (case pair of (CPair !x !y) -> (CPair (f x) y))
pair_45map_45right = \ !f !pair -> (case pair of (CPair !x !y) -> (CPair x (f y)))
pair_45swap = \ !pair -> (case pair of (CPair !x !y) -> (CPair y x))
data Tmaybe a = CSome !a | CNone
maybe_45map = \ !f !maybe -> (case maybe of (CSome !x) -> (CSome (f x)) ; CNone -> CNone)
maybe_45flatmap = \ !f !maybe -> (case maybe of (CSome !x) -> (f x) ; CNone -> CNone)
maybe_45filter = \ !f !maybe -> (case maybe of (CSome !x) -> (case (f x) of CTrue -> maybe ; CFalse -> CNone) ; CNone -> CNone)
maybe_45else = \ !f !maybe -> (case maybe of CNone -> (f) ; (CSome !x) -> x)
maybe_45or_45else = \ !value !maybe -> (case maybe of CNone -> value ; (CSome !x) -> x)
data Titerable_45class collection element = CIterableClass !(collection -> (Tpair (Tmaybe element) collection))
iterable_45next = \ !_class !collection -> (case _class of (CIterableClass !next) -> (next collection))
data Tindexed_45iterator element = forall iterable. CIndexedIterator !(Titerable_45class iterable element) !iterable !Int32
indexed_45iterator_45from_45iterable = \ !i !iterable -> (CIndexedIterator i iterable 0)
indexed_45iterator_45next = \ !iterator -> (case iterator of (CIndexedIterator !i !iterable !index) -> (case (iterable_45next i iterable) of (CPair !value !next_45iterable) -> (CPair value (CIndexedIterator i next_45iterable (_int32_add index 1)))))
indexed_45iterator_45index = \ !iterator -> (case iterator of (CIndexedIterator !_95 !_95_95 !index) -> index)
data Tlist a = CCons !a !(Tlist a) | CEmpty
list_45cons = \ !x !xs -> (CCons x xs)
list_45from = \ !x -> (CCons x CEmpty)
list_45from_45range = \ !from !_95to -> (case (_60 from _95to) of CTrue -> (CCons from (list_45from_45range (_int32_add from 1) _95to)) ; CFalse -> CEmpty)
list_45first = \ !list -> (case list of (CCons !x !_95) -> (CSome x) ; CEmpty -> CNone)
list_45rest = \ !list -> (case list of (CCons !_95 !rest) -> rest ; CEmpty -> CEmpty)
list_45last = \ !list -> (case list of CEmpty -> CNone ; (CCons !x CEmpty) -> (CSome x) ; (CCons !_95 !rest) -> (list_45last rest))
list_45empty_63 = \ !list -> (case list of (CCons !_95 !_95_95) -> CFalse ; CEmpty -> CTrue)
list_45size_39 = \ !list !size -> (case list of (CCons !_95 !rest) -> (list_45size_39 rest (_int32_add size 1)) ; CEmpty -> size)
list_45size = \ !list -> (list_45size_39 list 0)
list_45foldrk = \ !f !initial !list !continue -> (case list of CEmpty -> (continue initial) ; (CCons !x !xs) -> (list_45foldrk f initial xs (\ !value -> (f x value continue))))
list_45foldlk = \ !f !initial !list !continue -> (case list of CEmpty -> (continue initial) ; (CCons !x !xs) -> (f x initial (\ !new_45value -> (list_45foldlk f new_45value xs continue))))
list_45foldr = \ !f !initial !list -> (list_45foldrk (\ !x !value !continue -> (continue (f x value))) initial list (\ !x -> x))
list_45foldl = \ !f !initial !list -> (case list of CEmpty -> initial ; (CCons !x !xs) -> (list_45foldl f (f x initial) xs))
list_45concat = \ !a !b -> (list_45foldr list_45cons b a)
list_45reverse = \ !list -> (list_45foldl list_45cons CEmpty list)
list_45map = \ !f !list -> (list_45foldr (\ !head !tail -> (list_45cons (f head) tail)) CEmpty list)
list_45flatmap = \ !f !list -> (list_45foldr (\ !head !tail -> (list_45concat (f head) tail)) CEmpty list)
list_45flatten = \ !list -> (list_45foldr list_45concat CEmpty list)
list_45skip = \ !count !list -> (case (_62 count 0) of CTrue -> (list_45skip (_int32_sub count 1) (list_45rest list)) ; CFalse -> list)
list_45take_39 = \ !count !list !taken -> (case (_62 count 0) of CTrue -> (case list of (CCons !char !rest) -> (list_45take_39 (_int32_sub count 1) rest (CCons char taken)) ; CEmpty -> taken) ; CFalse -> taken)
list_45take = \ !count !list -> (list_45reverse (list_45take_39 count list CEmpty))
list_45zip_39 = \ !xs !ys !collected -> (case xs of CEmpty -> collected ; (CCons !x !xs) -> (case ys of CEmpty -> collected ; (CCons !y !ys) -> (list_45zip_39 xs ys (CCons (CPair x y) collected))))
list_45zip = \ !xs !ys -> (list_45reverse (list_45zip_39 xs ys CEmpty))
list_45pairs = \ !xs -> (case xs of (CCons !a (CCons !b !rest)) -> (CCons (CPair a b) (list_45pairs rest)) ; !_95 -> CEmpty)
list_45find_45first = \ !predicate !list -> (case list of CEmpty -> CNone ; (CCons !x !xs) -> (case (predicate x) of CTrue -> (CSome x) ; CFalse -> (list_45find_45first predicate xs)))
list_45filter = \ !f !list -> (list_45foldr (\ !head !tail -> (case (f head) of CTrue -> (CCons head tail) ; CFalse -> tail)) CEmpty list)
list_45exclude = \ !f !list -> (list_45filter (\ !_226_156_168x -> (not (f _226_156_168x))) list)
list_45any_63 = \ !f !list -> (case (list_45find_45first f list) of (CSome !_95) -> CTrue ; !_95 -> CFalse)
list_45every_63 = \ !f !list -> (case (list_45find_45first (\ !x -> (not (f x))) list) of (CSome !_95) -> CFalse ; !_95 -> CTrue)
list_45collect_45from_45indexed_45iterator_39 = \ !predicate !iterator !initial -> (case (indexed_45iterator_45next iterator) of (CPair CNone !_95) -> (CPair iterator initial) ; (CPair (CSome !x) !next) -> (case (predicate x) of CTrue -> (list_45collect_45from_45indexed_45iterator_39 predicate next (CCons x initial)) ; CFalse -> (CPair iterator initial)))
list_45collect_45from_45indexed_45iterator = \ !predicate !iterator -> (case (list_45collect_45from_45indexed_45iterator_39 predicate iterator CEmpty) of (CPair !iterator !result) -> (CPair iterator (list_45reverse result)))
data Tstring_45node = CFTValue !Int32 | CFTNode2 !Int32 !Tstring_45node !Tstring_45node | CFTNode3 !Int32 !Tstring_45node !Tstring_45node !Tstring_45node
data Tstring = CFTEmpty | CFTSingle !Tstring_45node | CFTDeep !(Tlist Tstring_45node) !Tstring !(Tlist Tstring_45node)
string_45empty = CFTEmpty
string_45of_45char = \ !character -> (CFTSingle (CFTValue character))
string_45node_45size_39 = \ !node -> (case node of (CFTValue !_95) -> 1 ; (CFTNode2 !size !_95 !_95_95) -> size ; (CFTNode3 !size !_95 !_95_95 !_95_95_95) -> size)
string_45node2_39 = \ !a !b -> (CFTNode2 (_int32_add (string_45node_45size_39 a) (string_45node_45size_39 b)) a b)
string_45node3_39 = \ !a !b !c -> (CFTNode3 (_int32_add (string_45node_45size_39 a) (_int32_add (string_45node_45size_39 b) (string_45node_45size_39 c))) a b c)
string_45prepend_45node_39 = \ !a !tree -> (case tree of CFTEmpty -> (CFTSingle a) ; (CFTSingle !x) -> (CFTDeep (CCons a CEmpty) CFTEmpty (CCons x CEmpty)) ; (CFTDeep !first !middle !last) -> (case first of (CCons !b (CCons !c (CCons !d (CCons !e CEmpty)))) -> (CFTDeep (CCons a (CCons b CEmpty)) (string_45prepend_45node_39 (string_45node3_39 c d e) middle) last) ; !_95 -> (CFTDeep (CCons a first) middle last)))
string_45prepend = \ !char !string -> (string_45prepend_45node_39 (CFTValue char) string)
string_45append_45node_39 = \ !a !tree -> (case tree of CFTEmpty -> (CFTSingle a) ; (CFTSingle !x) -> (CFTDeep (CCons x CEmpty) CFTEmpty (CCons a CEmpty)) ; (CFTDeep !first !middle !last) -> (case last of (CCons !b (CCons !c (CCons !d (CCons !e CEmpty)))) -> (CFTDeep first (string_45append_45node_39 (string_45node3_39 e d c) middle) (CCons a (CCons b CEmpty))) ; !_95 -> (CFTDeep first middle (CCons a last))))
string_45append = \ !char !string -> (string_45append_45node_39 (CFTValue char) string)
string_45first_45node_39 = \ !node -> (case node of (CFTValue !x) -> x ; (CFTNode2 !_95 !x !_95_95) -> (string_45first_45node_39 x) ; (CFTNode3 !_95 !x !_95_95 !_95_95_95) -> (string_45first_45node_39 x))
string_45first = \ !string -> (case string of CFTEmpty -> CNone ; (CFTSingle !node) -> (CSome (string_45first_45node_39 node)) ; (CFTDeep !first !middle !last) -> (maybe_45map string_45first_45node_39 (list_45first first)))
string_45rest_45node_39 = \ !node -> (case node of (CFTValue !_95) -> CNone ; (CFTNode2 !_95 !a !b) -> (case (string_45rest_45node_39 a) of (CSome !node) -> (CSome (string_45node2_39 node b)) ; CNone -> (CSome b)) ; (CFTNode3 !_95 !a !b !c) -> (case (string_45rest_45node_39 a) of (CSome !node) -> (CSome (string_45node3_39 node b c)) ; CNone -> (CSome (string_45node2_39 b c))))
string_45rest = \ !string -> (case string of CFTEmpty -> string ; (CFTSingle !node) -> (case (string_45rest_45node_39 node) of (CSome !node) -> (CFTSingle node) ; CNone -> CFTEmpty) ; (CFTDeep (CCons !node !rest) !middle !last) -> (case (string_45rest_45node_39 node) of (CSome !node) -> (CFTDeep (CCons node rest) middle last) ; CNone -> (case rest of CEmpty -> (list_45foldr string_45append_45node_39 middle last) ; !_95 -> (CFTDeep rest middle last))) ; !_95 -> string)
string_45foldr_45node_39 = \ !f !node !identity -> (case node of (CFTValue !a) -> (f a identity) ; (CFTNode2 !_95 !a !b) -> (string_45foldr_45node_39 f a (string_45foldr_45node_39 f b identity)) ; (CFTNode3 !_95 !a !b !c) -> (string_45foldr_45node_39 f a (string_45foldr_45node_39 f b (string_45foldr_45node_39 f c identity))))
string_45foldr = \ !f !identity !tree -> (case tree of CFTEmpty -> identity ; (CFTSingle !x) -> (string_45foldr_45node_39 f x identity) ; (CFTDeep !first !middle !last) -> (list_45foldr (string_45foldr_45node_39 f) (string_45foldr f (list_45foldl (string_45foldr_45node_39 f) identity last) middle) first))
string_45foldl_45node_39 = \ !f !node !identity -> (case node of (CFTValue !a) -> (f a identity) ; (CFTNode2 !_95 !b !a) -> (string_45foldl_45node_39 f a (string_45foldl_45node_39 f b identity)) ; (CFTNode3 !_95 !c !b !a) -> (string_45foldl_45node_39 f a (string_45foldl_45node_39 f b (string_45foldl_45node_39 f c identity))))
string_45foldl = \ !f !identity !tree -> (case tree of CFTEmpty -> identity ; (CFTSingle !x) -> (string_45foldl_45node_39 f x identity) ; (CFTDeep !first !middle !last) -> (list_45foldr (string_45foldl_45node_39 f) (string_45foldl f (list_45foldl (string_45foldl_45node_39 f) identity first) middle) last))
string_45size = \ !string -> (case string of CFTEmpty -> 0 ; (CFTSingle !x) -> (string_45node_45size_39 x) ; (CFTDeep !first !middle !last) -> (_int32_add (list_45foldr _int32_add 0 (list_45map string_45node_45size_39 first)) (_int32_add (list_45foldr _int32_add 0 (list_45map string_45node_45size_39 last)) (string_45size middle))))
string_45concat_45nodes_39 = \ !nodes -> (case nodes of (CCons !a (CCons !b CEmpty)) -> (CCons (string_45node2_39 a b) CEmpty) ; (CCons !a (CCons !b (CCons !c CEmpty))) -> (CCons (string_45node3_39 a b c) CEmpty) ; (CCons !a (CCons !b (CCons !c (CCons !d CEmpty)))) -> (CCons (string_45node2_39 a b) (CCons (string_45node2_39 c d) CEmpty)) ; (CCons !a (CCons !b (CCons !c !rest))) -> (CCons (string_45node3_39 a b c) (string_45concat_45nodes_39 rest)) ; !_95 -> CEmpty)
data Ttriple a b c = CTriple !a !b !c
string_45concat_39 = \ !a !nodes !b -> (case (CTriple a nodes b) of (CTriple CFTEmpty !nodes !b) -> (list_45foldr string_45prepend_45node_39 b nodes) ; (CTriple !a !nodes CFTEmpty) -> (list_45foldl string_45append_45node_39 a nodes) ; (CTriple (CFTSingle !x) !nodes !b) -> (string_45prepend_45node_39 x (list_45foldr string_45prepend_45node_39 b nodes)) ; (CTriple !a !nodes (CFTSingle !x)) -> (string_45append_45node_39 x (list_45foldl string_45append_45node_39 a nodes)) ; (CTriple (CFTDeep !first1 !middle1 !last1) !nodes (CFTDeep !first2 !middle2 !last2)) -> (CFTDeep first1 (string_45concat_39 middle1 (string_45concat_45nodes_39 (list_45concat (list_45reverse last1) (list_45concat nodes first2))) middle2) last2))
string_45concat = \ !a !b -> (string_45concat_39 a CEmpty b)
string_45empty_63 = \ !string -> (case (string_45first string) of (CSome !_95) -> CFalse ; CNone -> CTrue)
string_45any_63 = \ !predicate !string -> (string_45foldl (\ !x !b -> (or (predicate x) b)) CFalse string)
string_45every_63 = \ !predicate !string -> (string_45foldl (\ !x !b -> (and (predicate x) b)) CTrue string)
string_45to_45list = \ !string -> (string_45foldr list_45cons CEmpty string)
string_45from_45list = \ !list -> (list_45foldr string_45prepend (string_45empty) list)
string_45skip = \ !count !string -> (case (_62 count 0) of CTrue -> (string_45skip (_int32_sub count 1) (string_45rest string)) ; CFalse -> string)
string_45take_39 = \ !count !string !taken -> (case (_62 count 0) of CTrue -> (case (string_45first string) of (CSome !char) -> (string_45take_39 (_int32_sub count 1) (string_45rest string) (string_45append char taken)) ; CNone -> taken) ; CFalse -> taken)
string_45take = \ !count !string -> (string_45take_39 count string (string_45empty))
string_45reverse = \ !string -> (string_45foldl string_45prepend (string_45empty) string)
string_45substring = \ !start !size !string -> (string_45take size (string_45skip start string))
string_45join = \ !separator !strings -> (case strings of (CCons !first !rest) -> (list_45foldl (\ !string !joined -> (string_45concat joined (string_45concat separator string))) first rest) ; CEmpty -> (string_45empty))
string_45flatmap = \ !f !string -> (string_45foldl (\ !x !xs -> (string_45concat xs (f x))) (string_45empty) string)
string_45split_39 = \ !separator !list !current !parts -> (case list of CEmpty -> (list_45reverse (CCons (list_45reverse current) parts)) ; (CCons !c !rest) -> (case (_61 separator c) of CTrue -> (string_45split_39 separator rest CEmpty (CCons (list_45reverse current) parts)) ; CFalse -> (string_45split_39 separator rest (CCons c current) parts)))
string_45split = \ !separator !string -> (list_45map string_45from_45list (string_45split_39 separator (string_45to_45list string) CEmpty CEmpty))
string_45trim_45start_39 = \ !list -> (case list of (CCons !x !xs) -> (case (_61 x 32) of CTrue -> (string_45trim_45start_39 xs) ; CFalse -> list) ; CEmpty -> list)
string_45trim_45start = \ !string -> (string_45from_45list (string_45trim_45start_39 (string_45to_45list string)))
string_45trim_45end = \ !string -> (string_45reverse (string_45trim_45start (string_45reverse string)))
string_45trim = \ !string -> (string_45trim_45start (string_45trim_45end string))
string_45equal_63 = \ !a !b -> (case (string_45first a) of (CSome !xa) -> (case (string_45first b) of (CSome !xb) -> (and (_61 xa xb) (string_45equal_63 (string_45rest a) (string_45rest b))) ; CNone -> (string_45empty_63 a)) ; CNone -> (string_45empty_63 b))
string_45point_45is_45digit = \ !point -> (and (_62 point 47) (_60 point 58))
string_45to_45int32_39_39_39 = \ !string_45to_45int32_39_39 !string !accumulator !x -> (string_45to_45int32_39_39 string (CSome (_int32_add (_int32_mul 10 accumulator) (_int32_sub x 48))))
string_45to_45int32_39_39 = \ !string !accumulator -> (case string of CEmpty -> accumulator ; (CCons !x !rest) -> (maybe_45flatmap (\ !accumulator -> ((\ !_226_156_168x -> ((maybe_45flatmap (string_45to_45int32_39_39_39 string_45to_45int32_39_39 rest accumulator)) ((maybe_45filter string_45point_45is_45digit) _226_156_168x))) (CSome x))) accumulator))
string_45to_45int32_39 = \ !string -> (case string of (CCons 45 !string) -> (case (list_45empty_63 string) of CTrue -> CNone ; CFalse -> (maybe_45map (\ !x -> (_int32_mul (-1) x)) (string_45to_45int32_39 string))) ; !_95 -> (string_45to_45int32_39_39 string (CSome 0)))
string_45to_45int32 = \ !string -> (string_45to_45int32_39 (string_45to_45list string))
string_45from_45int32_39_39 = \ !integer !string -> (case (_62 integer 9) of CTrue -> (string_45from_45int32_39_39 (quot integer 10) (CCons (_int32_add (rem integer 10) 48) string)) ; CFalse -> (CCons (_int32_add integer 48) string))
string_45from_45int32_39 = \ !integer -> (case (_60 integer 0) of CTrue -> (case (_61 integer (-2147483648)) of CTrue -> (CCons 45 (CCons 50 (CCons 49 (CCons 52 (CCons 55 (CCons 52 (CCons 56 (CCons 51 (CCons 54 (CCons 52 (CCons 56 CEmpty))))))))))) ; CFalse -> (CCons 45 (string_45from_45int32_39 (_int32_mul integer (-1))))) ; CFalse -> (string_45from_45int32_39_39 integer CEmpty))
string_45from_45int32 = \ !integer -> (string_45from_45list (string_45from_45int32_39 integer))
string_45collect_45from_45indexed_45iterator = \ !predicate !iterator -> (pair_45map_45right string_45from_45list (list_45collect_45from_45indexed_45iterator predicate iterator))
string_45from_45indexed_45iterator = \ !iterator -> (string_45from_45list (pair_45right (list_45collect_45from_45indexed_45iterator (\ !_95 -> CTrue) iterator)))
string_45iterable = (CIterableClass (\ !string -> (CPair (string_45first string) (string_45rest string))))
string_45from_45boolean = \ !boolean -> (case boolean of CTrue -> (string_45from_45list (CCons 84 (CCons 114 (CCons 117 (CCons 101 CEmpty))))) ; CFalse -> (string_45from_45list (CCons 70 (CCons 97 (CCons 108 (CCons 115 (CCons 101 CEmpty)))))))
data Tresult v e = CResult !v | CError !e
result_45lift = \ !result -> (CResult result)
result_45error = \ !error -> (CError error)
result_45map = \ !f !result -> (case result of (CResult !x) -> (CResult (f x)) ; (CError !error) -> (CError error))
result_45map_45error = \ !f !result -> (case result of (CResult !x) -> (CResult x) ; (CError !error) -> (CError (f error)))
result_45flatmap = \ !f !result -> (case result of (CResult !x) -> (f x) ; (CError !error) -> (CError error))
result_45either = \ !f !g !result -> (case result of (CResult !x) -> (f x) ; (CError !x) -> (g x))
result_45or_45else = \ !value !result -> (case result of (CResult !x) -> x ; (CError !x) -> value)
result_45error_63 = \ !result -> (case result of (CError !_95) -> CTrue ; !_95 -> CFalse)
result_45filter_45list = \ !list -> (list_45foldr (\ !result !new_45list -> (case result of (CResult !x) -> (CCons x new_45list) ; !_95 -> new_45list)) CEmpty list)
result_45concat = \ !list -> (case (list_45filter result_45error_63 list) of (CCons (CError !error) !_95) -> (CError error) ; (CCons (CResult !_95) !_95_95) -> (CResult CEmpty) ; CEmpty -> (CResult (result_45filter_45list list)))
result_45of_45maybe = \ !error !maybe -> (case maybe of (CSome !x) -> (CResult x) ; CNone -> (CError error))
result_45bind = \ !result !f -> (result_45flatmap f result)
result_45return = \ !value -> (result_45lift value)
data Tstate s v = COperation !(s -> (Tpair s v))
state_45run = \ !state !operation -> (case operation of (COperation !f) -> (f state))
state_45final_45value = \ !initial_45state !operation -> (case (state_45run initial_45state operation) of (CPair !_95 !value) -> value)
state_45return = \ !value -> (COperation (\ !state -> (CPair state value)))
state_45bind = \ !operation !f -> (COperation (\ !state -> (case (state_45run state operation) of (CPair !new_45state !new_45value) -> (state_45run new_45state (f new_45value)))))
state_45get = (COperation (\ !state -> (CPair state state)))
state_45set = \ !state -> (COperation (\ !_95 -> (CPair state state)))
state_45modify = \ !f -> (state_45bind (state_45get) (\ !state -> (state_45set (f state))))
state_45let = \ !value !f -> (state_45bind (state_45return value) f)
state_45foldr = \ !f !initial_45value !operations -> (list_45foldr (\ !operation !chain -> (state_45bind operation (\ !x -> (state_45bind chain (\ !xs -> (state_45return (f x xs))))))) (state_45return initial_45value) operations)
state_45foreach = \ !f !xs -> (state_45foldr list_45cons CEmpty (list_45map f xs))
state_45flatmap = \ !f !operation -> (state_45bind operation f)
state_45map = \ !f !operation -> (state_45flatmap (\ !_226_156_168x -> (state_45return (f _226_156_168x))) operation)
state_45lift = \ !value -> (state_45return value)
data Tdictionary value = CTrieNode !(Tmaybe value) !(Tlist (Tpair Int32 (Tdictionary value)))
dictionary_45empty = (CTrieNode CNone CEmpty)
dictionary_45value_39 = \ !dictionary -> (case dictionary of (CTrieNode !value !_95) -> value)
dictionary_45children_39 = \ !dictionary -> (case dictionary of (CTrieNode !_95 !children) -> children)
dictionary_45find_45child_39 = \ !char !dictionary -> (maybe_45map pair_45right (list_45find_45first (\ !_226_156_168x -> ((_61 char) (pair_45left _226_156_168x))) (dictionary_45children_39 dictionary)))
dictionary_45remove_45child_39 = \ !char !dictionary -> (case dictionary of (CTrieNode !value !children) -> (CTrieNode value (list_45exclude (\ !_226_156_168x -> ((_61 char) (pair_45left _226_156_168x))) children)))
dictionary_45set = \ !key !new_45value !dictionary -> (case (string_45first key) of CNone -> (CTrieNode (CSome new_45value) (dictionary_45children_39 dictionary)) ; (CSome !char) -> ((\ !_226_156_168x -> ((\ !child -> (CTrieNode (dictionary_45value_39 dictionary) (CCons (CPair char child) (dictionary_45children_39 (dictionary_45remove_45child_39 char dictionary))))) ((dictionary_45set (string_45rest key) new_45value) ((maybe_45else dictionary_45empty) ((dictionary_45find_45child_39 char) _226_156_168x))))) dictionary))
dictionary_45get = \ !key !dictionary -> (case (string_45first key) of (CSome !char) -> (maybe_45flatmap (dictionary_45get (string_45rest key)) (dictionary_45find_45child_39 char dictionary)) ; CNone -> (dictionary_45value_39 dictionary))
dictionary_45entries_39 = \ !key !dictionary -> ((\ !_226_156_168x -> ((\ !entries -> (case (dictionary_45value_39 dictionary) of (CSome !value) -> (CCons (CPair key value) entries) ; CNone -> entries)) ((list_45flatmap (\ !child -> (dictionary_45entries_39 (string_45append (pair_45left child) key) (pair_45right child)))) (dictionary_45children_39 _226_156_168x)))) dictionary)
dictionary_45entries = \ !dictionary -> (dictionary_45entries_39 (string_45empty) dictionary)
dictionary_45of = \ !entries -> (list_45foldl (pair_45map dictionary_45set) (dictionary_45empty) entries)
dictionary_45singleton = \ !key !value -> (dictionary_45set key value (dictionary_45empty))
dictionary_45get_45or = \ !key !_default !dictionary -> (case (dictionary_45get key dictionary) of (CSome !value) -> value ; CNone -> _default)
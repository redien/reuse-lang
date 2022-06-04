var slice_empty = () => new Uint8Array();
var slice_of = x => { var array = new Uint8Array(1); array[0] = x; return array; };
var slice_size = slice => slice.length;
var slice_get = slice => index => { var x = slice[index]; return x === undefined ? 0 : x; };
var slice_concat = a => b => { var array = new Uint8Array(a.length + b.length); array.set(a); array.set(b, a.length); return array; };
var slice_foldl = f => ys => xs => xs.reduce((a, b) => f(b)(a), ys);
var slice_subslice = slice => start => end => slice.subarray(start, end);
var int32_add = a => b => a + b | 0;
var int32_sub = a => b => a - b | 0;
var int32_mul = a => b => a * b | 0;
var int32_div = a => b => a / b | 0;
var int32_mod = a => b => a % b | 0;
var int32_and = a => b => a & b;
function _trampoline(f) {
    while (f && f._k) {
        f = f._k();
    }
    return f;
}
var $ = {};
module.exports.$ = $;
function _match(value, cases) {
    for (var i = 0; i < cases.length; i += 2) {
        var captures = [];
        var match = match_pattern(value, cases[i], captures);
        if (match) { return cases[i + 1].apply(null, captures); }
    }

    throw "No patterns match";

    function match_pattern(value, pattern, captures) {
        if (Array.isArray(pattern)) {
            return pattern.every(function (pattern, index) { return match_pattern(value[index], pattern, captures); });
        } else if (pattern === $) {
            captures.push(value);
            return true;
        } else if (value === pattern) {
            return true;
        } else {
            return false;
        }
    }
}
module.exports.match = _match;

var id = x8 => 
    x8;
module.exports.id = (x8) => id(x8);

var const2 = a => b => 
    a;
module.exports.const2 = (a,b) => const2(a)(b);

var flip = f => 
    (b2 => a2 => f(a2)(b2));
module.exports.flip = (f) => flip(f);

var x = f2 => g => x9 => 
    f2(g(x9));
module.exports.x = (f2,g,x9) => x(f2)(g)(x9);

var x2 = f3 => g2 => x10 => y => 
    f3(g2(x10)(y));
module.exports.x2 = (f3,g2,x10,y) => x2(f3)(g2)(x10)(y);

var fix = f4 => 
    f4(fix(f4));
module.exports.fix = (f4) => fix(f4);

var True = { True: true };
module.exports.True = True;
var False = { False: true };
module.exports.False = False;

var not = a3 => 
    _match(a3, [
        True, () => 
            False,
        False, () => 
            True]);
module.exports.not = (a3) => not(a3);

var and = a4 => b3 => 
    _match(a4, [
        True, () => 
            b3,
        False, () => 
            False]);
module.exports.and = (a4,b3) => and(a4)(b3);

var or = a5 => b4 => 
    _match(a5, [
        True, () => 
            True,
        False, () => 
            b4]);
module.exports.or = (a5,b4) => or(a5)(b4);

var x3 = a6 => b5 => 
    (a6<b5 ? True : False);
module.exports.x3 = (a6,b5) => x3(a6)(b5);

var x4 = a7 => b6 => 
    x3(b6)(a7);
module.exports.x4 = (a7,b6) => x4(a7)(b6);

var x5 = a8 => b7 => 
    not(or(x3(a8)(b7))(x4(a8)(b7)));
module.exports.x5 = (a8,b7) => x5(a8)(b7);

var x6 = a9 => b8 => 
    or(x3(a9)(b8))(x5(a9)(b8));
module.exports.x6 = (a9,b8) => x6(a9)(b8);

var x7 = a10 => b9 => 
    or(x4(a10)(b9))(x5(a10)(b9));
module.exports.x7 = (a10,b9) => x7(a10)(b9);

var max = a11 => b10 => 
    (a11<b10 ? b10 : a11);
module.exports.max = (a11,b10) => max(a11)(b10);

var min = a12 => b11 => 
    (a12<b11 ? a12 : b11);
module.exports.min = (a12,b11) => min(a12)(b11);

var Pair = { Pair: true };
module.exports.Pair = Pair;

var pair_cons = a13 => b12 => 
    [Pair, a13, b12];
module.exports.pair_cons = (a13,b12) => pair_cons(a13)(b12);

var pair_left = pair2 => 
    _match(pair2, [
        [Pair, $, $], (x11, x12) => 
            x11]);
module.exports.pair_left = (pair2) => pair_left(pair2);

var pair_right = pair3 => 
    _match(pair3, [
        [Pair, $, $], (x13, x14) => 
            x14]);
module.exports.pair_right = (pair3) => pair_right(pair3);

var pair_map = f5 => pair4 => 
    _match(pair4, [
        [Pair, $, $], (x15, y2) => 
            f5(x15)(y2)]);
module.exports.pair_map = (f5,pair4) => pair_map(f5)(pair4);

var pair_bimap = f6 => g3 => pair5 => 
    _match(pair5, [
        [Pair, $, $], (x16, y3) => 
            [Pair, f6(x16), g3(y3)]]);
module.exports.pair_bimap = (f6,g3,pair5) => pair_bimap(f6)(g3)(pair5);

var pair_map_left = f7 => pair6 => 
    _match(pair6, [
        [Pair, $, $], (x17, y4) => 
            [Pair, f7(x17), y4]]);
module.exports.pair_map_left = (f7,pair6) => pair_map_left(f7)(pair6);

var pair_map_right = f8 => pair7 => 
    _match(pair7, [
        [Pair, $, $], (x18, y5) => 
            [Pair, x18, f8(y5)]]);
module.exports.pair_map_right = (f8,pair7) => pair_map_right(f8)(pair7);

var pair_swap = pair8 => 
    _match(pair8, [
        [Pair, $, $], (x19, y6) => 
            [Pair, y6, x19]]);
module.exports.pair_swap = (pair8) => pair_swap(pair8);

var Some = { Some: true };
module.exports.Some = Some;
var None = { None: true };
module.exports.None = None;

var maybe_map = f9 => maybe2 => 
    _match(maybe2, [
        [Some, $], (x20) => 
            [Some, f9(x20)],
        None, () => 
            None]);
module.exports.maybe_map = (f9,maybe2) => maybe_map(f9)(maybe2);

var maybe_flatmap = f10 => maybe3 => 
    _match(maybe3, [
        [Some, $], (x21) => 
            f10(x21),
        None, () => 
            None]);
module.exports.maybe_flatmap = (f10,maybe3) => maybe_flatmap(f10)(maybe3);

var maybe_bind = maybe4 => f11 => 
    maybe_flatmap(f11)(maybe4);
module.exports.maybe_bind = (maybe4,f11) => maybe_bind(maybe4)(f11);

var maybe_return = x22 => 
    [Some, x22];
module.exports.maybe_return = (x22) => maybe_return(x22);

var maybe_filter = f12 => maybe5 => 
    _match(maybe5, [
        [Some, $], (x23) => 
            _match(f12(x23), [
                True, () => 
                    maybe5,
                False, () => 
                    None]),
        None, () => 
            None]);
module.exports.maybe_filter = (f12,maybe5) => maybe_filter(f12)(maybe5);

var maybe_else = f13 => maybe6 => 
    _match(maybe6, [
        None, () => 
            f13(),
        [Some, $], (x24) => 
            x24]);
module.exports.maybe_else = (f13,maybe6) => maybe_else(f13)(maybe6);

var maybe_or_else = value => maybe7 => 
    _match(maybe7, [
        None, () => 
            value,
        [Some, $], (x25) => 
            x25]);
module.exports.maybe_or_else = (value,maybe7) => maybe_or_else(value)(maybe7);

var IterableClass = { IterableClass: true };
module.exports.IterableClass = IterableClass;

var iterable_next = class2 => collection => 
    _match(class2, [
        [IterableClass, $], (next) => 
            next(collection)]);
module.exports.iterable_next = (class2,collection) => iterable_next(class2)(collection);

var IndexedIterator = { IndexedIterator: true };
module.exports.IndexedIterator = IndexedIterator;

var indexed_iterator_from_iterable = i => iterable => 
    [IndexedIterator, i, iterable, 0];
module.exports.indexed_iterator_from_iterable = (i,iterable) => indexed_iterator_from_iterable(i)(iterable);

var indexed_iterator_next = iterator => 
    _match(iterator, [
        [IndexedIterator, $, $, $], (i2, iterable2, index) => 
            _match(iterable_next(i2)(iterable2), [
                [Pair, $, $], (value2, next_iterable) => 
                    [Pair, value2, [IndexedIterator, i2, next_iterable, int32_add(index)(1)]]])]);
module.exports.indexed_iterator_next = (iterator) => indexed_iterator_next(iterator);

var indexed_iterator_index = iterator2 => 
    _match(iterator2, [
        [IndexedIterator, $, $, $], (x26, x27, index2) => 
            index2]);
module.exports.indexed_iterator_index = (iterator2) => indexed_iterator_index(iterator2);

var Cons = { Cons: true };
module.exports.Cons = Cons;
var Empty = { Empty: true };
module.exports.Empty = Empty;

var list_empty = () => 
    Empty;
module.exports.list_empty = () => list_empty();

var list_cons = x28 => xs => 
    [Cons, x28, xs];
module.exports.list_cons = (x28,xs) => list_cons(x28)(xs);

var list_from = x29 => 
    [Cons, x29, Empty];
module.exports.list_from = (x29) => list_from(x29);

var list_from_range2 = from => to => rest => {
    var _tailcall = from => to => rest => 
        _match(x4(to)(from), [
            True, () => 
                ({_k:() => _tailcall (from)(int32_sub(to)(1))([Cons, int32_sub(to)(1), rest])}),
            False, () => 
                rest]);
    return _trampoline(_tailcall(from)(to)(rest));
};

var list_from_range = from2 => to2 => 
    list_from_range2(from2)(to2)(Empty);
module.exports.list_from_range = (from2,to2) => list_from_range(from2)(to2);

var list_first = list2 => 
    _match(list2, [
        [Cons, $, $], (x30, x31) => 
            [Some, x30],
        Empty, () => 
            None]);
module.exports.list_first = (list2) => list_first(list2);

var list_rest = list3 => 
    _match(list3, [
        [Cons, $, $], (x32, rest2) => 
            rest2,
        Empty, () => 
            Empty]);
module.exports.list_rest = (list3) => list_rest(list3);

var list_last = list4 => {
    var _tailcall = list4 => 
        _match(list4, [
            Empty, () => 
                None,
            [Cons, $, Empty], (x33) => 
                [Some, x33],
            [Cons, $, $], (x34, rest3) => 
                ({_k:() => _tailcall (rest3)})]);
    return _trampoline(_tailcall(list4));
};
module.exports.list_last = (list4) => list_last(list4);

var list_is_empty = list5 => 
    _match(list5, [
        [Cons, $, $], (x35, x36) => 
            False,
        Empty, () => 
            True]);
module.exports.list_is_empty = (list5) => list_is_empty(list5);

var list_size2 = list6 => size => {
    var _tailcall = list6 => size => 
        _match(list6, [
            [Cons, $, $], (x37, rest4) => 
                ({_k:() => _tailcall (rest4)(int32_add(size)(1))}),
            Empty, () => 
                size]);
    return _trampoline(_tailcall(list6)(size));
};

var list_size = list7 => 
    list_size2(list7)(0);
module.exports.list_size = (list7) => list_size(list7);

var list_foldrk = f14 => initial => list8 => continue2 => {
    var _tailcall = f14 => initial => list8 => continue2 => 
        _match(list8, [
            Empty, () => 
                continue2(initial),
            [Cons, $, $], (x38, xs2) => 
                ({_k:() => _tailcall (f14)(initial)(xs2)((value3 => f14(x38)(value3)(continue2)))})]);
    return _trampoline(_tailcall(f14)(initial)(list8)(continue2));
};
module.exports.list_foldrk = (f14,initial,list8,continue2) => list_foldrk(f14)(initial)(list8)(continue2);

var list_foldlk = f15 => initial2 => list9 => continue3 => 
    _match(list9, [
        Empty, () => 
            continue3(initial2),
        [Cons, $, $], (x39, xs3) => 
            f15(x39)(initial2)((new_value => list_foldlk(f15)(new_value)(xs3)(continue3)))]);
module.exports.list_foldlk = (f15,initial2,list9,continue3) => list_foldlk(f15)(initial2)(list9)(continue3);

var list_foldr = f16 => initial3 => list10 => 
    list_foldrk((x40 => value4 => continue4 => continue4(f16(x40)(value4))))(initial3)(list10)((x41 => x41));
module.exports.list_foldr = (f16,initial3,list10) => list_foldr(f16)(initial3)(list10);

var list_foldl = f17 => initial4 => list11 => {
    var _tailcall = f17 => initial4 => list11 => 
        _match(list11, [
            Empty, () => 
                initial4,
            [Cons, $, $], (x42, xs4) => 
                ({_k:() => _tailcall (f17)(f17(x42)(initial4))(xs4)})]);
    return _trampoline(_tailcall(f17)(initial4)(list11));
};
module.exports.list_foldl = (f17,initial4,list11) => list_foldl(f17)(initial4)(list11);

var list_concat = a14 => b13 => 
    list_foldr(list_cons)(b13)(a14);
module.exports.list_concat = (a14,b13) => list_concat(a14)(b13);

var list_reverse = list12 => 
    list_foldl(list_cons)(Empty)(list12);
module.exports.list_reverse = (list12) => list_reverse(list12);

var list_map = f18 => list13 => 
    list_foldr((head => tail => list_cons(f18(head))(tail)))(Empty)(list13);
module.exports.list_map = (f18,list13) => list_map(f18)(list13);

var list_flatmap = f19 => list14 => 
    list_foldr((head2 => tail2 => list_concat(f19(head2))(tail2)))(Empty)(list14);
module.exports.list_flatmap = (f19,list14) => list_flatmap(f19)(list14);

var list_flatten = list15 => 
    list_foldr(list_concat)(Empty)(list15);
module.exports.list_flatten = (list15) => list_flatten(list15);

var list_split_at2 = n => a15 => b14 => {
    var _tailcall = n => a15 => b14 => 
        _match(x4(n)(0), [
            True, () => 
                _match(b14, [
                    [Cons, $, $], (x43, xs5) => 
                        ({_k:() => _tailcall (int32_sub(n)(1))([Cons, x43, a15])(xs5)}),
                    Empty, () => 
                        [Pair, list_reverse(a15), b14]]),
            False, () => 
                [Pair, list_reverse(a15), b14]]);
    return _trampoline(_tailcall(n)(a15)(b14));
};

var list_split_at = n2 => xs6 => 
    list_split_at2(n2)(Empty)(xs6);
module.exports.list_split_at = (n2,xs6) => list_split_at(n2)(xs6);

var list_partition2 = n3 => xs7 => partitions => {
    var _tailcall = n3 => xs7 => partitions => 
        _match(list_split_at(n3)(xs7), [
            [Pair, Empty, $], (x44) => 
                partitions,
            [Pair, $, $], (partition, xs8) => 
                ({_k:() => _tailcall (n3)(xs8)([Cons, partition, partitions])})]);
    return _trampoline(_tailcall(n3)(xs7)(partitions));
};

var list_partition = n4 => xs9 => 
    list_reverse(list_partition2(n4)(xs9)(Empty));
module.exports.list_partition = (n4,xs9) => list_partition(n4)(xs9);

var list_partition_by2 = x45 => xs10 => 
    _match(xs10, [
        [Cons, $, $], (partition2, rest5) => 
            [Cons, [Cons, x45, partition2], rest5],
        Empty, () => 
            xs10]);

var list_partition_by = f20 => xs11 => 
    _match(xs11, [
        Empty, () => 
            Empty,
        [Cons, $, Empty], (x46) => 
            [Cons, [Cons, x46, Empty], Empty],
        [Cons, $, [Cons, $, $]], (x47, x48, rest6) => 
            _match(f20(x47)(x48), [
                True, () => 
                    list_partition_by2(x47)(list_partition_by(f20)([Cons, x48, rest6])),
                False, () => 
                    [Cons, [Cons, x47, Empty], list_partition_by(f20)([Cons, x48, rest6])]])]);
module.exports.list_partition_by = (f20,xs11) => list_partition_by(f20)(xs11);

var list_skip = count => list16 => 
    pair_right(list_split_at(count)(list16));
module.exports.list_skip = (count,list16) => list_skip(count)(list16);

var list_take = count2 => list17 => 
    pair_left(list_split_at(count2)(list17));
module.exports.list_take = (count2,list17) => list_take(count2)(list17);

var list_zip2 = xs12 => ys => collected => {
    var _tailcall = xs12 => ys => collected => 
        _match(xs12, [
            Empty, () => 
                collected,
            [Cons, $, $], (x49, xs13) => 
                _match(ys, [
                    Empty, () => 
                        collected,
                    [Cons, $, $], (y7, ys2) => 
                        ({_k:() => _tailcall (xs13)(ys2)([Cons, [Pair, x49, y7], collected])})])]);
    return _trampoline(_tailcall(xs12)(ys)(collected));
};

var list_zip = xs14 => ys3 => 
    list_reverse(list_zip2(xs14)(ys3)(Empty));
module.exports.list_zip = (xs14,ys3) => list_zip(xs14)(ys3);

var list_pairs = xs15 => 
    _match(xs15, [
        [Cons, $, [Cons, $, $]], (a16, b15, rest7) => 
            [Cons, [Pair, a16, b15], list_pairs(rest7)],
        $, (x50) => 
            Empty]);
module.exports.list_pairs = (xs15) => list_pairs(xs15);

var list_find_first = predicate => list18 => {
    var _tailcall = predicate => list18 => 
        _match(list18, [
            Empty, () => 
                None,
            [Cons, $, $], (x51, xs16) => 
                _match(predicate(x51), [
                    True, () => 
                        [Some, x51],
                    False, () => 
                        ({_k:() => _tailcall (predicate)(xs16)})])]);
    return _trampoline(_tailcall(predicate)(list18));
};
module.exports.list_find_first = (predicate,list18) => list_find_first(predicate)(list18);

var list_filter = f21 => list19 => 
    list_foldr((head3 => tail3 => _match(f21(head3), [
        True, () => 
            [Cons, head3, tail3],
        False, () => 
            tail3])))(Empty)(list19);
module.exports.list_filter = (f21,list19) => list_filter(f21)(list19);

var list_exclude = f22 => list20 => 
    list_filter((x52 => not(f22(x52))))(list20);
module.exports.list_exclude = (f22,list20) => list_exclude(f22)(list20);

var list_any = f23 => list21 => 
    _match(list_find_first(f23)(list21), [
        [Some, $], (x53) => 
            True,
        $, (x54) => 
            False]);
module.exports.list_any = (f23,list21) => list_any(f23)(list21);

var list_every = f24 => list22 => 
    _match(list_find_first((x55 => not(f24(x55))))(list22), [
        [Some, $], (x56) => 
            False,
        $, (x57) => 
            True]);
module.exports.list_every = (f24,list22) => list_every(f24)(list22);

var list_from_maybe = maybe8 => 
    _match(maybe8, [
        [Some, $], (x58) => 
            [Cons, x58, Empty],
        None, () => 
            Empty]);
module.exports.list_from_maybe = (maybe8) => list_from_maybe(maybe8);

var list_collect_from_indexed_iterator2 = predicate2 => iterator3 => initial5 => {
    var _tailcall = predicate2 => iterator3 => initial5 => 
        _match(indexed_iterator_next(iterator3), [
            [Pair, None, $], (x59) => 
                [Pair, iterator3, initial5],
            [Pair, [Some, $], $], (x60, next2) => 
                _match(predicate2(x60), [
                    True, () => 
                        ({_k:() => _tailcall (predicate2)(next2)([Cons, x60, initial5])}),
                    False, () => 
                        [Pair, iterator3, initial5]])]);
    return _trampoline(_tailcall(predicate2)(iterator3)(initial5));
};

var list_collect_from_indexed_iterator = predicate3 => iterator4 => 
    _match(list_collect_from_indexed_iterator2(predicate3)(iterator4)(Empty), [
        [Pair, $, $], (iterator5, result2) => 
            [Pair, iterator5, list_reverse(result2)]]);
module.exports.list_collect_from_indexed_iterator = (predicate3,iterator4) => list_collect_from_indexed_iterator(predicate3)(iterator4);

var FTValue = { FTValue: true };
var FTNode2 = { FTNode2: true };
var FTNode3 = { FTNode3: true };

var FTEmpty = { FTEmpty: true };
module.exports.FTEmpty = FTEmpty;
var FTSingle = { FTSingle: true };
module.exports.FTSingle = FTSingle;
var FTDeep = { FTDeep: true };
module.exports.FTDeep = FTDeep;

var string_empty = () => 
    FTEmpty;
module.exports.string_empty = () => string_empty();

var string_of_char = character => 
    [FTSingle, [FTValue, character]];
module.exports.string_of_char = (character) => string_of_char(character);

var string_node_size = node => 
    _match(node, [
        [FTValue, $], (x61) => 
            1,
        [FTNode2, $, $, $], (size2, x62, x63) => 
            size2,
        [FTNode3, $, $, $, $], (size3, x64, x65, x66) => 
            size3]);

var string_node2 = a17 => b16 => 
    [FTNode2, int32_add(string_node_size(a17))(string_node_size(b16)), a17, b16];

var string_node3 = a18 => b17 => c => 
    [FTNode3, int32_add(string_node_size(a18))(int32_add(string_node_size(b17))(string_node_size(c))), a18, b17, c];

var string_prepend_node = a19 => tree => 
    _match(tree, [
        FTEmpty, () => 
            [FTSingle, a19],
        [FTSingle, $], (x67) => 
            [FTDeep, [Cons, a19, Empty], FTEmpty, [Cons, x67, Empty]],
        [FTDeep, $, $, $], (first, middle, last) => 
            _match(first, [
                [Cons, $, [Cons, $, [Cons, $, [Cons, $, Empty]]]], (b18, c2, d, e) => 
                    [FTDeep, [Cons, a19, [Cons, b18, Empty]], string_prepend_node(string_node3(c2)(d)(e))(middle), last],
                $, (x68) => 
                    [FTDeep, [Cons, a19, first], middle, last]])]);

var string_prepend = char => string2 => 
    string_prepend_node([FTValue, char])(string2);
module.exports.string_prepend = (char,string2) => string_prepend(char)(string2);

var string_append_node = a20 => tree2 => 
    _match(tree2, [
        FTEmpty, () => 
            [FTSingle, a20],
        [FTSingle, $], (x69) => 
            [FTDeep, [Cons, x69, Empty], FTEmpty, [Cons, a20, Empty]],
        [FTDeep, $, $, $], (first2, middle2, last2) => 
            _match(last2, [
                [Cons, $, [Cons, $, [Cons, $, [Cons, $, Empty]]]], (b19, c3, d2, e2) => 
                    [FTDeep, first2, string_append_node(string_node3(e2)(d2)(c3))(middle2), [Cons, a20, [Cons, b19, Empty]]],
                $, (x70) => 
                    [FTDeep, first2, middle2, [Cons, a20, last2]]])]);

var string_append = char2 => string3 => 
    string_append_node([FTValue, char2])(string3);
module.exports.string_append = (char2,string3) => string_append(char2)(string3);

var string_first_node = node2 => {
    var _tailcall = node2 => 
        _match(node2, [
            [FTValue, $], (x71) => 
                x71,
            [FTNode2, $, $, $], (x72, x73, x74) => 
                ({_k:() => _tailcall (x73)}),
            [FTNode3, $, $, $, $], (x75, x76, x77, x78) => 
                ({_k:() => _tailcall (x76)})]);
    return _trampoline(_tailcall(node2));
};

var string_first = string4 => 
    _match(string4, [
        FTEmpty, () => 
            None,
        [FTSingle, $], (node3) => 
            [Some, string_first_node(node3)],
        [FTDeep, $, $, $], (first3, middle3, last3) => 
            maybe_map(string_first_node)(list_first(first3))]);
module.exports.string_first = (string4) => string_first(string4);

var string_rest_node = node4 => 
    _match(node4, [
        [FTValue, $], (x79) => 
            None,
        [FTNode2, $, $, $], (x80, a21, b20) => 
            _match(string_rest_node(a21), [
                [Some, $], (node5) => 
                    [Some, string_node2(node5)(b20)],
                None, () => 
                    [Some, b20]]),
        [FTNode3, $, $, $, $], (x81, a22, b21, c4) => 
            _match(string_rest_node(a22), [
                [Some, $], (node6) => 
                    [Some, string_node3(node6)(b21)(c4)],
                None, () => 
                    [Some, string_node2(b21)(c4)]])]);

var string_rest = string5 => 
    _match(string5, [
        FTEmpty, () => 
            string5,
        [FTSingle, $], (node7) => 
            _match(string_rest_node(node7), [
                [Some, $], (node8) => 
                    [FTSingle, node8],
                None, () => 
                    FTEmpty]),
        [FTDeep, [Cons, $, $], $, $], (node9, rest8, middle4, last4) => 
            _match(string_rest_node(node9), [
                [Some, $], (node10) => 
                    [FTDeep, [Cons, node10, rest8], middle4, last4],
                None, () => 
                    _match(rest8, [
                        Empty, () => 
                            list_foldr(string_append_node)(middle4)(last4),
                        $, (x82) => 
                            [FTDeep, rest8, middle4, last4]])]),
        $, (x83) => 
            string5]);
module.exports.string_rest = (string5) => string_rest(string5);

var string_foldr_node = f25 => node11 => identity => {
    var _tailcall = f25 => node11 => identity => 
        _match(node11, [
            [FTValue, $], (a23) => 
                f25(a23)(identity),
            [FTNode2, $, $, $], (x84, a24, b22) => 
                ({_k:() => _tailcall (f25)(a24)(string_foldr_node(f25)(b22)(identity))}),
            [FTNode3, $, $, $, $], (x85, a25, b23, c5) => 
                ({_k:() => _tailcall (f25)(a25)(string_foldr_node(f25)(b23)(string_foldr_node(f25)(c5)(identity)))})]);
    return _trampoline(_tailcall(f25)(node11)(identity));
};

var string_foldr = f26 => identity2 => tree3 => 
    _match(tree3, [
        FTEmpty, () => 
            identity2,
        [FTSingle, $], (x86) => 
            string_foldr_node(f26)(x86)(identity2),
        [FTDeep, $, $, $], (first4, middle5, last5) => 
            list_foldr(string_foldr_node(f26))(string_foldr(f26)(list_foldl(string_foldr_node(f26))(identity2)(last5))(middle5))(first4)]);
module.exports.string_foldr = (f26,identity2,tree3) => string_foldr(f26)(identity2)(tree3);

var string_foldl_node = f27 => node12 => identity3 => {
    var _tailcall = f27 => node12 => identity3 => 
        _match(node12, [
            [FTValue, $], (a26) => 
                f27(a26)(identity3),
            [FTNode2, $, $, $], (x87, b24, a27) => 
                ({_k:() => _tailcall (f27)(a27)(string_foldl_node(f27)(b24)(identity3))}),
            [FTNode3, $, $, $, $], (x88, c6, b25, a28) => 
                ({_k:() => _tailcall (f27)(a28)(string_foldl_node(f27)(b25)(string_foldl_node(f27)(c6)(identity3)))})]);
    return _trampoline(_tailcall(f27)(node12)(identity3));
};

var string_foldl = f28 => identity4 => tree4 => 
    _match(tree4, [
        FTEmpty, () => 
            identity4,
        [FTSingle, $], (x89) => 
            string_foldl_node(f28)(x89)(identity4),
        [FTDeep, $, $, $], (first5, middle6, last6) => 
            list_foldr(string_foldl_node(f28))(string_foldl(f28)(list_foldl(string_foldl_node(f28))(identity4)(first5))(middle6))(last6)]);
module.exports.string_foldl = (f28,identity4,tree4) => string_foldl(f28)(identity4)(tree4);

var string_size = string6 => 
    _match(string6, [
        FTEmpty, () => 
            0,
        [FTSingle, $], (x90) => 
            string_node_size(x90),
        [FTDeep, $, $, $], (first6, middle7, last7) => 
            int32_add(list_foldr(int32_add)(0)(list_map(string_node_size)(first6)))(int32_add(list_foldr(int32_add)(0)(list_map(string_node_size)(last7)))(string_size(middle7)))]);
module.exports.string_size = (string6) => string_size(string6);

var string_concat_nodes = nodes => 
    _match(nodes, [
        [Cons, $, [Cons, $, Empty]], (a29, b26) => 
            [Cons, string_node2(a29)(b26), Empty],
        [Cons, $, [Cons, $, [Cons, $, Empty]]], (a30, b27, c7) => 
            [Cons, string_node3(a30)(b27)(c7), Empty],
        [Cons, $, [Cons, $, [Cons, $, [Cons, $, Empty]]]], (a31, b28, c8, d3) => 
            [Cons, string_node2(a31)(b28), [Cons, string_node2(c8)(d3), Empty]],
        [Cons, $, [Cons, $, [Cons, $, $]]], (a32, b29, c9, rest9) => 
            [Cons, string_node3(a32)(b29)(c9), string_concat_nodes(rest9)],
        $, (x91) => 
            Empty]);

var Triple = { Triple: true };

var string_concat2 = a33 => nodes2 => b30 => 
    _match([Triple, a33, nodes2, b30], [
        [Triple, FTEmpty, $, $], (nodes3, b31) => 
            list_foldr(string_prepend_node)(b31)(nodes3),
        [Triple, $, $, FTEmpty], (a34, nodes4) => 
            list_foldl(string_append_node)(a34)(nodes4),
        [Triple, [FTSingle, $], $, $], (x92, nodes5, b32) => 
            string_prepend_node(x92)(list_foldr(string_prepend_node)(b32)(nodes5)),
        [Triple, $, $, [FTSingle, $]], (a35, nodes6, x93) => 
            string_append_node(x93)(list_foldl(string_append_node)(a35)(nodes6)),
        [Triple, [FTDeep, $, $, $], $, [FTDeep, $, $, $]], (first1, middle1, last1, nodes7, first22, middle22, last22) => 
            [FTDeep, first1, string_concat2(middle1)(string_concat_nodes(list_concat(list_reverse(last1))(list_concat(nodes7)(first22))))(middle22), last22]]);

var string_concat = a36 => b33 => 
    string_concat2(a36)(Empty)(b33);
module.exports.string_concat = (a36,b33) => string_concat(a36)(b33);

var string_is_empty = string7 => 
    _match(string_first(string7), [
        [Some, $], (x94) => 
            False,
        None, () => 
            True]);
module.exports.string_is_empty = (string7) => string_is_empty(string7);

var string_any = predicate4 => string8 => 
    string_foldl((x95 => b34 => or(predicate4(x95))(b34)))(False)(string8);
module.exports.string_any = (predicate4,string8) => string_any(predicate4)(string8);

var string_every = predicate5 => string9 => 
    string_foldl((x96 => b35 => and(predicate5(x96))(b35)))(True)(string9);
module.exports.string_every = (predicate5,string9) => string_every(predicate5)(string9);

var string_to_list = string10 => 
    string_foldr(list_cons)(Empty)(string10);
module.exports.string_to_list = (string10) => string_to_list(string10);

var string_from_list = list23 => 
    list_foldl(string_append)(string_empty())(list23);
module.exports.string_from_list = (list23) => string_from_list(list23);

var string_skip = count3 => string11 => {
    var _tailcall = count3 => string11 => 
        _match(string11, [
            FTEmpty, () => 
                FTEmpty,
            $, (x97) => 
                _match(x4(count3)(0), [
                    True, () => 
                        ({_k:() => _tailcall (int32_sub(count3)(1))(string_rest(string11))}),
                    False, () => 
                        string11])]);
    return _trampoline(_tailcall(count3)(string11));
};
module.exports.string_skip = (count3,string11) => string_skip(count3)(string11);

var string_take2 = count4 => string12 => taken => {
    var _tailcall = count4 => string12 => taken => 
        _match(x4(count4)(0), [
            True, () => 
                _match(string_first(string12), [
                    [Some, $], (char3) => 
                        ({_k:() => _tailcall (int32_sub(count4)(1))(string_rest(string12))(string_append(char3)(taken))}),
                    None, () => 
                        taken]),
            False, () => 
                taken]);
    return _trampoline(_tailcall(count4)(string12)(taken));
};

var string_take = count5 => string13 => 
    string_take2(count5)(string13)(string_empty());
module.exports.string_take = (count5,string13) => string_take(count5)(string13);

var string_reverse = string14 => 
    string_foldl(string_prepend)(string_empty())(string14);
module.exports.string_reverse = (string14) => string_reverse(string14);

var string_repeat = string15 => n5 => 
    list_foldl(x2(string_concat(string15))(flip(const2)))(string_empty())(list_from_range(0)(n5));
module.exports.string_repeat = (string15,n5) => string_repeat(string15)(n5);

var string_substring = start => size4 => string16 => 
    string_take(size4)(string_skip(start)(string16));
module.exports.string_substring = (start,size4,string16) => string_substring(start)(size4)(string16);

var string_join = separator => strings => 
    _match(strings, [
        [Cons, $, $], (first7, rest10) => 
            list_foldl((string17 => joined => string_concat(joined)(string_concat(separator)(string17))))(first7)(rest10),
        Empty, () => 
            string_empty()]);
module.exports.string_join = (separator,strings) => string_join(separator)(strings);

var string_flatmap = f29 => string18 => 
    string_foldl((x98 => xs17 => string_concat(xs17)(f29(x98))))(string_empty())(string18);
module.exports.string_flatmap = (f29,string18) => string_flatmap(f29)(string18);

var string_split2 = separator2 => list24 => current => parts => {
    var _tailcall = separator2 => list24 => current => parts => 
        _match(list24, [
            Empty, () => 
                list_reverse([Cons, list_reverse(current), parts]),
            [Cons, $, $], (c10, rest11) => 
                _match(x5(separator2)(c10), [
                    True, () => 
                        ({_k:() => _tailcall (separator2)(rest11)(Empty)([Cons, list_reverse(current), parts])}),
                    False, () => 
                        ({_k:() => _tailcall (separator2)(rest11)([Cons, c10, current])(parts)})])]);
    return _trampoline(_tailcall(separator2)(list24)(current)(parts));
};

var string_split = separator3 => string19 => 
    list_map(string_from_list)(string_split2(separator3)(string_to_list(string19))(Empty)(Empty));
module.exports.string_split = (separator3,string19) => string_split(separator3)(string19);

var string_trim_start2 = list25 => {
    var _tailcall = list25 => 
        _match(list25, [
            [Cons, $, $], (x99, xs18) => 
                _match(x5(x99)(32), [
                    True, () => 
                        ({_k:() => _tailcall (xs18)}),
                    False, () => 
                        list25]),
            Empty, () => 
                list25]);
    return _trampoline(_tailcall(list25));
};

var string_trim_start = string20 => 
    string_from_list(string_trim_start2(string_to_list(string20)));
module.exports.string_trim_start = (string20) => string_trim_start(string20);

var string_trim_end = string21 => 
    string_reverse(string_trim_start(string_reverse(string21)));
module.exports.string_trim_end = (string21) => string_trim_end(string21);

var string_trim = string22 => 
    string_trim_start(string_trim_end(string22));
module.exports.string_trim = (string22) => string_trim(string22);

var string_equal = a37 => b36 => 
    _match(string_first(a37), [
        [Some, $], (xa) => 
            _match(string_first(b36), [
                [Some, $], (xb) => 
                    and(x5(xa)(xb))(string_equal(string_rest(a37))(string_rest(b36))),
                None, () => 
                    string_is_empty(a37)]),
        None, () => 
            string_is_empty(b36)]);
module.exports.string_equal = (a37,b36) => string_equal(a37)(b36);

var string_index_of = index3 => substring => string23 => {
    var _tailcall = index3 => substring => string23 => 
        _match(x7(index3)(string_size(string23)), [
            True, () => 
                None,
            False, () => 
                _match(string_equal(substring)(string_substring(index3)(string_size(substring))(string23)), [
                    True, () => 
                        [Some, index3],
                    False, () => 
                        ({_k:() => _tailcall (int32_add(index3)(1))(substring)(string23)})])]);
    return _trampoline(_tailcall(index3)(substring)(string23));
};
module.exports.string_index_of = (index3,substring,string23) => string_index_of(index3)(substring)(string23);

var string_point_is_digit = point => 
    _match(x4(point)(47), [
        False, () => 
            False,
        True, () => 
            _match(x3(point)(58), [
                True, () => 
                    True,
                False, () => 
                    False])]);
module.exports.string_point_is_digit = (point) => string_point_is_digit(point);

var string_to_int322 = string_to_int323 => string24 => accumulator => x100 => 
    string_to_int323(string24)([Some, int32_add(int32_mul(10)(accumulator))(int32_sub(x100)(48))]);

var string_to_int324 = string25 => accumulator2 => 
    _match(string25, [
        Empty, () => 
            accumulator2,
        [Cons, $, $], (x101, rest12) => 
            maybe_flatmap((accumulator3 => (x52 => maybe_flatmap(string_to_int322(string_to_int324)(rest12)(accumulator3))(maybe_filter(string_point_is_digit)(x52)))([Some, x101])))(accumulator2)]);

var string_to_int325 = string26 => 
    _match(string26, [
        [Cons, 45, $], (string27) => 
            _match(list_is_empty(string27), [
                True, () => 
                    None,
                False, () => 
                    maybe_map((x102 => int32_mul(-1)(x102)))(string_to_int325(string27))]),
        [Cons, $, $], (x103, rest13) => 
            _match(string_point_is_digit(x103), [
                True, () => 
                    string_to_int324(string26)([Some, 0]),
                False, () => 
                    None]),
        Empty, () => 
            None]);

var string_to_int32 = string28 => 
    string_to_int325(string_to_list(string28));
module.exports.string_to_int32 = (string28) => string_to_int32(string28);

var string_from_int322 = integer => string29 => {
    var _tailcall = integer => string29 => 
        _match(x4(integer)(9), [
            True, () => 
                ({_k:() => _tailcall (int32_div(integer)(10))([Cons, int32_add(int32_mod(integer)(10))(48), string29])}),
            False, () => 
                [Cons, int32_add(integer)(48), string29]]);
    return _trampoline(_tailcall(integer)(string29));
};

var string_from_int323 = integer2 => 
    _match(x3(integer2)(0), [
        True, () => 
            _match(x5(integer2)(-2147483648), [
                True, () => 
                    [Cons, 45, [Cons, 50, [Cons, 49, [Cons, 52, [Cons, 55, [Cons, 52, [Cons, 56, [Cons, 51, [Cons, 54, [Cons, 52, [Cons, 56, Empty]]]]]]]]]]],
                False, () => 
                    [Cons, 45, string_from_int323(int32_mul(integer2)(-1))]]),
        False, () => 
            string_from_int322(integer2)(Empty)]);

var string_from_int32 = integer3 => 
    string_from_list(string_from_int323(integer3));
module.exports.string_from_int32 = (integer3) => string_from_int32(integer3);

var string_collect_from_slice2 = predicate6 => index4 => slice => initial6 => {
    var _tailcall = predicate6 => index4 => slice => initial6 => 
        _match(x3(index4)(slice_size(slice)), [
            False, () => 
                [Pair, index4, initial6],
            True, () => 
                _match(predicate6(slice_get(slice)(index4)), [
                    True, () => 
                        ({_k:() => _tailcall (predicate6)(int32_add(index4)(1))(slice)(string_append(slice_get(slice)(index4))(initial6))}),
                    False, () => 
                        [Pair, index4, initial6]])]);
    return _trampoline(_tailcall(predicate6)(index4)(slice)(initial6));
};

var string_collect_from_slice = predicate7 => index5 => slice2 => 
    string_collect_from_slice2(predicate7)(index5)(slice2)(string_empty());
module.exports.string_collect_from_slice = (predicate7,index5,slice2) => string_collect_from_slice(predicate7)(index5)(slice2);

var string_to_slice = string30 => 
    string_foldl((c11 => slice3 => slice_concat(slice3)(slice_of(c11))))(slice_empty())(string30);
module.exports.string_to_slice = (string30) => string_to_slice(string30);

var string_from_slice = slice4 => 
    slice_foldl(string_append)(string_empty())(slice4);
module.exports.string_from_slice = (slice4) => string_from_slice(slice4);

var string_collect_from_indexed_iterator2 = predicate8 => iterator6 => initial7 => {
    var _tailcall = predicate8 => iterator6 => initial7 => 
        _match(indexed_iterator_next(iterator6), [
            [Pair, None, $], (x104) => 
                [Pair, iterator6, initial7],
            [Pair, [Some, $], $], (x105, next3) => 
                _match(predicate8(x105), [
                    True, () => 
                        ({_k:() => _tailcall (predicate8)(next3)(string_append(x105)(initial7))}),
                    False, () => 
                        [Pair, iterator6, initial7]])]);
    return _trampoline(_tailcall(predicate8)(iterator6)(initial7));
};

var string_collect_from_indexed_iterator = predicate9 => iterator7 => 
    string_collect_from_indexed_iterator2(predicate9)(iterator7)(string_empty());
module.exports.string_collect_from_indexed_iterator = (predicate9,iterator7) => string_collect_from_indexed_iterator(predicate9)(iterator7);

var string_from_indexed_iterator = iterator8 => 
    pair_right(string_collect_from_indexed_iterator((x106 => True))(iterator8));
module.exports.string_from_indexed_iterator = (iterator8) => string_from_indexed_iterator(iterator8);

var string_iterable = () => 
    [IterableClass, (string31 => [Pair, string_first(string31), string_rest(string31)])];
module.exports.string_iterable = () => string_iterable();

var string_from_boolean = boolean2 => 
    _match(boolean2, [
        True, () => 
            string_from_list([Cons, 84, [Cons, 114, [Cons, 117, [Cons, 101, Empty]]]]),
        False, () => 
            string_from_list([Cons, 70, [Cons, 97, [Cons, 108, [Cons, 115, [Cons, 101, Empty]]]]])]);
module.exports.string_from_boolean = (boolean2) => string_from_boolean(boolean2);

var valid_string_from_unicode_code_point = point2 => 
    _match(x4(point2)(65535), [
        True, () => 
            string_from_list([Cons, int32_add(240)(int32_div(int32_and(point2)(1835008))(262144)), [Cons, int32_add(128)(int32_div(int32_and(point2)(258048))(4096)), [Cons, int32_add(128)(int32_div(int32_and(point2)(4032))(64)), [Cons, int32_add(128)(int32_and(point2)(63)), Empty]]]]),
        False, () => 
            _match(x4(point2)(2047), [
                True, () => 
                    string_from_list([Cons, int32_add(224)(int32_div(int32_and(point2)(61440))(4096)), [Cons, int32_add(128)(int32_div(int32_and(point2)(4032))(64)), [Cons, int32_add(128)(int32_and(point2)(63)), Empty]]]),
                False, () => 
                    _match(x4(point2)(127), [
                        True, () => 
                            string_from_list([Cons, int32_add(192)(int32_div(int32_and(point2)(1984))(64)), [Cons, int32_add(128)(int32_and(point2)(63)), Empty]]),
                        False, () => 
                            string_of_char(point2)])])]);

var invalid_code_point = () => 
    string_from_list([Cons, 255, [Cons, 253, Empty]]);

var string_from_unicode_code_point = point3 => 
    _match(x4(point3)(1114111), [
        True, () => 
            invalid_code_point(),
        False, () => 
            _match(x4(point3)(55295), [
                True, () => 
                    _match(x3(point3)(57344), [
                        True, () => 
                            invalid_code_point(),
                        False, () => 
                            valid_string_from_unicode_code_point(point3)]),
                False, () => 
                    valid_string_from_unicode_code_point(point3)])]);
module.exports.string_from_unicode_code_point = (point3) => string_from_unicode_code_point(point3);

var Result = { Result: true };
module.exports.Result = Result;
var Error = { Error: true };
module.exports.Error = Error;

var result_lift = result3 => 
    [Result, result3];
module.exports.result_lift = (result3) => result_lift(result3);

var result_error = error => 
    [Error, error];
module.exports.result_error = (error) => result_error(error);

var result_prod = return2 => result4 => 
    _match(result4, [
        [Result, $], (m) => 
            m,
        [Error, $], (error2) => 
            return2([Error, error2])]);
module.exports.result_prod = (return2,result4) => result_prod(return2)(result4);

var result_bimap = f30 => g4 => result5 => 
    _match(result5, [
        [Result, $], (x107) => 
            [Result, f30(x107)],
        [Error, $], (y8) => 
            [Error, g4(y8)]]);
module.exports.result_bimap = (f30,g4,result5) => result_bimap(f30)(g4)(result5);

var result_either = f31 => g5 => result6 => 
    _match(result6, [
        [Result, $], (x108) => 
            f31(x108),
        [Error, $], (x109) => 
            g5(x109)]);
module.exports.result_either = (f31,g5,result6) => result_either(f31)(g5)(result6);

var result_map = f32 => result7 => 
    result_bimap(f32)(id)(result7);
module.exports.result_map = (f32,result7) => result_map(f32)(result7);

var result_flatmap = f33 => result8 => 
    _match(result8, [
        [Result, $], (x110) => 
            f33(x110),
        [Error, $], (error3) => 
            [Error, error3]]);
module.exports.result_flatmap = (f33,result8) => result_flatmap(f33)(result8);

var result_or_else = value5 => result9 => 
    _match(result9, [
        [Result, $], (x111) => 
            x111,
        [Error, $], (x112) => 
            value5]);
module.exports.result_or_else = (value5,result9) => result_or_else(value5)(result9);

var result_error2 = result10 => 
    _match(result10, [
        [Error, $], (x113) => 
            True,
        $, (x114) => 
            False]);
module.exports.result_error2 = (result10) => result_error2(result10);

var result_filter_list = list26 => 
    list_foldr((result11 => new_list => _match(result11, [
        [Result, $], (x115) => 
            [Cons, x115, new_list],
        $, (x116) => 
            new_list])))(Empty)(list26);
module.exports.result_filter_list = (list26) => result_filter_list(list26);

var result_concat = list27 => 
    _match(list_filter(result_error2)(list27), [
        [Cons, [Error, $], $], (error4, x117) => 
            [Error, error4],
        [Cons, [Result, $], $], (x118, x119) => 
            [Result, Empty],
        Empty, () => 
            [Result, result_filter_list(list27)]]);
module.exports.result_concat = (list27) => result_concat(list27);

var result_of_maybe = error5 => maybe9 => 
    _match(maybe9, [
        [Some, $], (x120) => 
            [Result, x120],
        None, () => 
            [Error, error5]]);
module.exports.result_of_maybe = (error5,maybe9) => result_of_maybe(error5)(maybe9);

var result_bind = result12 => f34 => 
    result_flatmap(f34)(result12);
module.exports.result_bind = (result12,f34) => result_bind(result12)(f34);

var result_return = value6 => 
    result_lift(value6);
module.exports.result_return = (value6) => result_return(value6);

var Operation = { Operation: true };
module.exports.Operation = Operation;

var state_run = state2 => operation => 
    _match(operation, [
        [Operation, $], (f35) => 
            f35(state2)]);
module.exports.state_run = (state2,operation) => state_run(state2)(operation);

var state_final_value = initial_state => operation2 => 
    _match(state_run(initial_state)(operation2), [
        [Pair, $, $], (x121, value7) => 
            value7]);
module.exports.state_final_value = (initial_state,operation2) => state_final_value(initial_state)(operation2);

var state_return = value8 => 
    [Operation, (state3 => [Pair, state3, value8])];
module.exports.state_return = (value8) => state_return(value8);

var state_bind = operation3 => f36 => 
    [Operation, (state4 => _match(state_run(state4)(operation3), [
        [Pair, $, $], (new_state, new_value2) => 
            state_run(new_state)(f36(new_value2))]))];
module.exports.state_bind = (operation3,f36) => state_bind(operation3)(f36);

var state_get = () => 
    [Operation, (state5 => [Pair, state5, state5])];
module.exports.state_get = () => state_get();

var state_set = state6 => 
    [Operation, (x122 => [Pair, state6, state6])];
module.exports.state_set = (state6) => state_set(state6);

var state_modify = f37 => 
    state_bind(state_get())((state7 => state_set(f37(state7))));
module.exports.state_modify = (f37) => state_modify(f37);

var state_let = value9 => f38 => 
    state_bind(state_return(value9))(f38);
module.exports.state_let = (value9,f38) => state_let(value9)(f38);

var state_foldr = f39 => initial_value => operations => 
    list_foldr((operation4 => chain => state_bind(operation4)((x123 => state_bind(chain)((xs19 => state_return(f39(x123)(xs19))))))))(state_return(initial_value))(operations);
module.exports.state_foldr = (f39,initial_value,operations) => state_foldr(f39)(initial_value)(operations);

var state_foreach = f40 => xs20 => 
    state_foldr(list_cons)(Empty)(list_map(f40)(xs20));
module.exports.state_foreach = (f40,xs20) => state_foreach(f40)(xs20);

var state_flatmap = f41 => operation5 => 
    state_bind(operation5)(f41);
module.exports.state_flatmap = (f41,operation5) => state_flatmap(f41)(operation5);

var state_map = f42 => operation6 => 
    state_flatmap((x52 => state_return(f42(x52))))(operation6);
module.exports.state_map = (f42,operation6) => state_map(f42)(operation6);

var state_lift = value10 => 
    state_return(value10);
module.exports.state_lift = (value10) => state_lift(value10);

var ArrayRed = { ArrayRed: true };
var ArrayBlack = { ArrayBlack: true };

var ArrayEmpty = { ArrayEmpty: true };
module.exports.ArrayEmpty = ArrayEmpty;
var ArrayTree = { ArrayTree: true };
module.exports.ArrayTree = ArrayTree;

var array_empty = () => 
    ArrayEmpty;
module.exports.array_empty = () => array_empty();

var array_make_black = array2 => 
    _match(array2, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, $, $, $], (x124, a38, y9, b37) => 
            [ArrayTree, ArrayBlack, a38, y9, b37]]);

var array_balance = array3 => 
    _match(array3, [
        [ArrayTree, ArrayBlack, [ArrayTree, ArrayRed, [ArrayTree, ArrayRed, $, $, $], $, $], $, $], (a39, x125, b38, y10, c12, z, d4) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a39, x125, b38], y10, [ArrayTree, ArrayBlack, c12, z, d4]],
        [ArrayTree, ArrayBlack, [ArrayTree, ArrayRed, $, $, [ArrayTree, ArrayRed, $, $, $]], $, $], (a40, x126, b39, y11, c13, z2, d5) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a40, x126, b39], y11, [ArrayTree, ArrayBlack, c13, z2, d5]],
        [ArrayTree, ArrayBlack, $, $, [ArrayTree, ArrayRed, [ArrayTree, ArrayRed, $, $, $], $, $]], (a41, x127, b40, y12, c14, z3, d6) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a41, x127, b40], y12, [ArrayTree, ArrayBlack, c14, z3, d6]],
        [ArrayTree, ArrayBlack, $, $, [ArrayTree, ArrayRed, $, $, [ArrayTree, ArrayRed, $, $, $]]], (a42, x128, b41, y13, c15, z4, d7) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a42, x128, b41], y13, [ArrayTree, ArrayBlack, c15, z4, d7]],
        $, (rest14) => 
            rest14]);

var array_set2 = x129 => value11 => array4 => 
    _match(array4, [
        ArrayEmpty, () => 
            [ArrayTree, ArrayRed, ArrayEmpty, [Pair, x129, value11], ArrayEmpty],
        [ArrayTree, $, $, $, $], (color, a43, y14, b42) => 
            _match(x3(x129)(pair_left(y14)), [
                True, () => 
                    array_balance([ArrayTree, color, array_set2(x129)(value11)(a43), y14, b42]),
                False, () => 
                    _match(x4(x129)(pair_left(y14)), [
                        True, () => 
                            array_balance([ArrayTree, color, a43, y14, array_set2(x129)(value11)(b42)]),
                        False, () => 
                            [ArrayTree, color, a43, [Pair, x129, value11], b42]])])]);

var array_set = x130 => value12 => array5 => 
    array_make_black(array_set2(x130)(value12)(array5));
module.exports.array_set = (x130,value12,array5) => array_set(x130)(value12)(array5);

var array_get = x131 => array6 => {
    var _tailcall = x131 => array6 => 
        _match(array6, [
            ArrayEmpty, () => 
                None,
            [ArrayTree, $, $, [Pair, $, $], $], (x132, a44, y15, value13, b43) => 
                _match(x3(x131)(y15), [
                    True, () => 
                        ({_k:() => _tailcall (x131)(a44)}),
                    False, () => 
                        _match(x4(x131)(y15), [
                            True, () => 
                                ({_k:() => _tailcall (x131)(b43)}),
                            False, () => 
                                [Some, value13]])])]);
    return _trampoline(_tailcall(x131)(array6));
};
module.exports.array_get = (x131,array6) => array_get(x131)(array6);

var array_min = array7 => default2 => {
    var _tailcall = array7 => default2 => 
        _match(array7, [
            ArrayEmpty, () => 
                default2,
            [ArrayTree, $, ArrayEmpty, $, $], (x133, y16, x134) => 
                y16,
            [ArrayTree, $, $, $, $], (x135, a45, x136, x137) => 
                ({_k:() => _tailcall (a45)(default2)})]);
    return _trampoline(_tailcall(array7)(default2));
};

var array_remove_min = array8 => 
    _match(array8, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, ArrayEmpty, $, $], (x138, y17, b44) => 
            b44,
        [ArrayTree, $, $, $, $], (color2, a46, y18, b45) => 
            array_balance([ArrayTree, color2, array_remove_min(a46), y18, b45])]);

var array_remove_root = array9 => 
    _match(array9, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, ArrayEmpty, $, ArrayEmpty], (x139, y19) => 
            ArrayEmpty,
        [ArrayTree, $, $, $, ArrayEmpty], (x140, a47, y20) => 
            a47,
        [ArrayTree, $, ArrayEmpty, $, $], (x141, y21, b46) => 
            b46,
        [ArrayTree, $, $, $, $], (color3, a48, y22, b47) => 
            array_balance([ArrayTree, color3, a48, array_min(b47)(y22), array_remove_min(b47)])]);

var array_remove2 = x142 => array10 => 
    _match(array10, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, $, $, $], (color4, a49, y23, b48) => 
            _match(x3(x142)(pair_left(y23)), [
                True, () => 
                    array_balance([ArrayTree, color4, array_remove2(x142)(a49), y23, b48]),
                False, () => 
                    _match(x4(x142)(pair_left(y23)), [
                        True, () => 
                            array_balance([ArrayTree, color4, a49, y23, array_remove2(x142)(b48)]),
                        False, () => 
                            array_remove_root(array10)])])]);

var array_remove = x143 => array11 => 
    array_make_black(array_remove2(x143)(array11));
module.exports.array_remove = (x143,array11) => array_remove(x143)(array11);

var array_entries = array12 => 
    _match(array12, [
        ArrayEmpty, () => 
            Empty,
        [ArrayTree, $, $, $, $], (x144, a50, entry, b49) => 
            list_flatten([Cons, array_entries(a50), [Cons, [Cons, entry, Empty], [Cons, array_entries(b49), Empty]]])]);
module.exports.array_entries = (array12) => array_entries(array12);

var array_from_list2 = entries => index6 => array13 => {
    var _tailcall = entries => index6 => array13 => 
        _match(entries, [
            [Cons, $, $], (x145, xs21) => 
                ({_k:() => _tailcall (xs21)(int32_add(index6)(1))(array_set(index6)(x145)(array13))}),
            Empty, () => 
                array13]);
    return _trampoline(_tailcall(entries)(index6)(array13));
};

var array_from_list = entries2 => 
    array_from_list2(entries2)(0)(ArrayEmpty);
module.exports.array_from_list = (entries2) => array_from_list(entries2);

var array_of = entries3 => 
    list_foldl((entry2 => array14 => _match(entry2, [
        [Pair, $, $], (key, value14) => 
            array_set(key)(value14)(array14)])))(ArrayEmpty)(entries3);
module.exports.array_of = (entries3) => array_of(entries3);

var array_singleton = index7 => value15 => 
    [ArrayTree, ArrayBlack, ArrayEmpty, [Pair, index7, value15], ArrayEmpty];
module.exports.array_singleton = (index7,value15) => array_singleton(index7)(value15);

var array_get_or = index8 => default3 => array15 => 
    _match(array_get(index8)(array15), [
        [Some, $], (value16) => 
            value16,
        None, () => 
            default3]);
module.exports.array_get_or = (index8,default3,array15) => array_get_or(index8)(default3)(array15);

var array_size = array16 => 
    list_size(array_entries(array16));
module.exports.array_size = (array16) => array_size(array16);

var Dictionary = { Dictionary: true };
module.exports.Dictionary = Dictionary;

var dictionary_empty = () => 
    [Dictionary, array_empty()];
module.exports.dictionary_empty = () => dictionary_empty();

var dictionary_bucket_from_key = key2 => 
    string_foldl((c16 => h => int32_add(int32_mul(h)(33))(c16)))(5381)(key2);

var dictionary_set = key3 => new_value3 => dictionary2 => 
    _match(dictionary2, [
        [Dictionary, $], (array17) => 
            _match(dictionary_bucket_from_key(key3), [
                $, (bucket_id) => 
                    _match(array_get(bucket_id)(array17), [
                        [Some, $], (bucket) => 
                            _match(list_filter((entry3 => not(string_equal(pair_left(entry3))(key3))))(bucket), [
                                $, (new_bucket) => 
                                    [Dictionary, array_set(bucket_id)([Cons, [Pair, key3, new_value3], new_bucket])(array17)]]),
                        None, () => 
                            [Dictionary, array_set(bucket_id)([Cons, [Pair, key3, new_value3], Empty])(array17)]])])]);
module.exports.dictionary_set = (key3,new_value3,dictionary2) => dictionary_set(key3)(new_value3)(dictionary2);

var dictionary_get = key4 => dictionary3 => 
    _match(dictionary3, [
        [Dictionary, $], (array18) => 
            _match(dictionary_bucket_from_key(key4), [
                $, (bucket_id2) => 
                    _match(array_get(bucket_id2)(array18), [
                        [Some, $], (bucket2) => 
                            maybe_map(pair_right)(list_find_first((entry4 => string_equal(pair_left(entry4))(key4)))(bucket2)),
                        None, () => 
                            None])])]);
module.exports.dictionary_get = (key4,dictionary3) => dictionary_get(key4)(dictionary3);

var dictionary_remove = key5 => dictionary4 => 
    _match(dictionary4, [
        [Dictionary, $], (array19) => 
            _match(dictionary_bucket_from_key(key5), [
                $, (bucket_id3) => 
                    _match(array_get(bucket_id3)(array19), [
                        [Some, $], (bucket3) => 
                            _match(list_filter((entry5 => not(string_equal(pair_left(entry5))(key5))))(bucket3), [
                                $, (new_bucket2) => 
                                    [Dictionary, array_set(bucket_id3)(new_bucket2)(array19)]]),
                        None, () => 
                            dictionary4])])]);
module.exports.dictionary_remove = (key5,dictionary4) => dictionary_remove(key5)(dictionary4);

var dictionary_entries = dictionary5 => 
    _match(dictionary5, [
        [Dictionary, $], (array20) => 
            list_flatten(list_map(pair_right)(array_entries(array20)))]);
module.exports.dictionary_entries = (dictionary5) => dictionary_entries(dictionary5);

var dictionary_of = entries4 => 
    list_foldl(pair_map(dictionary_set))(dictionary_empty())(entries4);
module.exports.dictionary_of = (entries4) => dictionary_of(entries4);

var dictionary_singleton = key6 => value17 => 
    dictionary_set(key6)(value17)(dictionary_empty());
module.exports.dictionary_singleton = (key6,value17) => dictionary_singleton(key6)(value17);

var dictionary_get_or = key7 => default4 => dictionary6 => 
    _match(dictionary_get(key7)(dictionary6), [
        [Some, $], (value18) => 
            value18,
        None, () => 
            default4]);
module.exports.dictionary_get_or = (key7,default4,dictionary6) => dictionary_get_or(key7)(default4)(dictionary6);

var dictionary_size = dictionary7 => 
    list_size(dictionary_entries(dictionary7));
module.exports.dictionary_size = (dictionary7) => dictionary_size(dictionary7);

var dictionary_has = key8 => dictionary8 => 
    _match(dictionary_get(key8)(dictionary8), [
        [Some, $], (x146) => 
            True,
        None, () => 
            False]);
module.exports.dictionary_has = (key8,dictionary8) => dictionary_has(key8)(dictionary8);

var dictionary_values = dictionary9 => 
    list_map(pair_right)(dictionary_entries(dictionary9));
module.exports.dictionary_values = (dictionary9) => dictionary_values(dictionary9);

var dictionary_keys = dictionary10 => 
    list_map(pair_left)(dictionary_entries(dictionary10));
module.exports.dictionary_keys = (dictionary10) => dictionary_keys(dictionary10);

var Bigint = { Bigint: true };

var bigint_trim_parts_reversed = parts2 => {
    var _tailcall = parts2 => 
        _match(parts2, [
            [Cons, $, Empty], (x147) => 
                parts2,
            [Cons, $, $], (x148, xs22) => 
                _match(x5(x148)(0), [
                    True, () => 
                        ({_k:() => _tailcall (xs22)}),
                    False, () => 
                        parts2]),
            Empty, () => 
                Empty]);
    return _trampoline(_tailcall(parts2));
};

var bigint_trim_parts = parts3 => 
    list_reverse(bigint_trim_parts_reversed(list_reverse(parts3)));

var bigint_from_string = string32 => 
    _match(string_first(string32), [
        [Some, 45], () => 
            [Bigint, True, bigint_trim_parts(list_reverse(list_map(flip(int32_sub)(48))(string_to_list(string_rest(string32)))))],
        $, (x149) => 
            [Bigint, False, bigint_trim_parts(list_reverse(list_map(flip(int32_sub)(48))(string_to_list(string32))))]]);
module.exports.bigint_from_string = (string32) => bigint_from_string(string32);

var bigint_from = int => 
    bigint_from_string(string_from_int32(int));
module.exports.bigint_from = (int) => bigint_from(int);

var bigint_zero = () => 
    [Bigint, False, [Cons, 0, Empty]];
module.exports.bigint_zero = () => bigint_zero();

var bigint_one = () => 
    [Bigint, False, [Cons, 1, Empty]];
module.exports.bigint_one = () => bigint_one();

var bigint_negate = int2 => 
    _match(int2, [
        [Bigint, $, [Cons, 0, Empty]], (negative) => 
            int2,
        [Bigint, $, $], (negative2, parts4) => 
            [Bigint, _match(negative2, [
                True, () => 
                    False,
                False, () => 
                    True]), parts4]]);
module.exports.bigint_negate = (int2) => bigint_negate(int2);

var stringify_parts = parts5 => 
    string_join(string_empty())(list_reverse(list_map(string_from_int32)(parts5)));

var bigint_to_string = int3 => 
    _match(int3, [
        [Bigint, True, $], (parts6) => 
            string_prepend(45)(stringify_parts(parts6)),
        [Bigint, False, $], (parts7) => 
            stringify_parts(parts7)]);
module.exports.bigint_to_string = (int3) => bigint_to_string(int3);

var less_than_with_carry = x150 => y24 => previous_less_than => 
    _match(x3(x150)(y24), [
        True, () => 
            True,
        False, () => 
            _match(x5(x150)(y24), [
                True, () => 
                    previous_less_than,
                False, () => 
                    False])]);

var bigint_less_than_parts = a51 => b50 => previous_less_than2 => {
    var _tailcall = a51 => b50 => previous_less_than2 => 
        _match([Pair, a51, b50], [
            [Pair, Empty, Empty], () => 
                False,
            [Pair, [Cons, $, $], Empty], (x151, x152) => 
                False,
            [Pair, Empty, [Cons, $, $]], (x153, x154) => 
                True,
            [Pair, [Cons, $, Empty], [Cons, $, Empty]], (x155, y25) => 
                less_than_with_carry(x155)(y25)(previous_less_than2),
            [Pair, [Cons, $, $], [Cons, $, $]], (x156, xs23, y26, ys4) => 
                ({_k:() => _tailcall (xs23)(ys4)(less_than_with_carry(x156)(y26)(previous_less_than2))})]);
    return _trampoline(_tailcall(a51)(b50)(previous_less_than2));
};

var bigint_less_than = a52 => b51 => 
    _match([Pair, a52, b51], [
        [Pair, [Bigint, True, $], [Bigint, False, $]], (x157, x158) => 
            True,
        [Pair, [Bigint, False, $], [Bigint, True, $]], (x159, x160) => 
            False,
        [Pair, [Bigint, True, $], [Bigint, True, $]], (a_parts, b_parts) => 
            bigint_less_than_parts(b_parts)(a_parts)(False),
        [Pair, [Bigint, $, $], [Bigint, $, $]], (x161, a_parts2, x162, b_parts2) => 
            bigint_less_than_parts(a_parts2)(b_parts2)(False)]);
module.exports.bigint_less_than = (a52,b51) => bigint_less_than(a52)(b51);

var bigint_subtract_parts = a53 => b52 => carry => {
    var _tailcall = a53 => b52 => carry => 
        _match([Pair, a53, b52], [
            [Pair, [Cons, $, $], Empty], (x163, xs24) => 
                ({_k:() => _tailcall (a53)([Cons, 0, Empty])(carry)}),
            [Pair, [Cons, $, $], [Cons, $, $]], (x164, xs25, y27, ys5) => 
                _match(x3(int32_sub(x164)(int32_add(y27)(carry)))(0), [
                    True, () => 
                        [Cons, int32_sub(int32_add(x164)(10))(int32_add(y27)(carry)), bigint_subtract_parts(xs25)(ys5)(1)],
                    False, () => 
                        [Cons, int32_sub(x164)(int32_add(y27)(carry)), bigint_subtract_parts(xs25)(ys5)(0)]]),
            $, (x165) => 
                Empty]);
    return _trampoline(_tailcall(a53)(b52)(carry));
};

var bigint_add_parts = a54 => b53 => carry2 => {
    var _tailcall = a54 => b53 => carry2 => 
        _match([Pair, a54, b53], [
            [Pair, [Cons, $, $], [Cons, $, $]], (x166, xs26, y28, ys6) => 
                _match(x4(int32_add(x166)(int32_add(y28)(carry2)))(9), [
                    True, () => 
                        [Cons, int32_sub(int32_add(x166)(int32_add(y28)(carry2)))(10), bigint_add_parts(xs26)(ys6)(1)],
                    False, () => 
                        [Cons, int32_add(x166)(int32_add(y28)(carry2)), bigint_add_parts(xs26)(ys6)(0)]]),
            [Pair, [Cons, $, $], Empty], (x167, x168) => 
                ({_k:() => _tailcall (a54)([Cons, 0, Empty])(carry2)}),
            [Pair, Empty, [Cons, $, $]], (x169, x170) => 
                ({_k:() => _tailcall ([Cons, 0, Empty])(b53)(carry2)}),
            [Pair, Empty, Empty], () => 
                _match(x4(carry2)(0), [
                    True, () => 
                        [Cons, carry2, Empty],
                    False, () => 
                        Empty])]);
    return _trampoline(_tailcall(a54)(b53)(carry2));
};

var bigint_add_zeroes = n6 => digits => {
    var _tailcall = n6 => digits => 
        _match(n6, [
            0, () => 
                digits,
            $, (x171) => 
                ({_k:() => _tailcall (int32_sub(n6)(1))([Cons, 0, digits])})]);
    return _trampoline(_tailcall(n6)(digits));
};

var bigint_multiply_digit = x172 => digits2 => carry3 => 
    _match(digits2, [
        Empty, () => 
            _match(x4(carry3)(0), [
                True, () => 
                    [Cons, carry3, Empty],
                False, () => 
                    Empty]),
        [Cons, $, $], (y29, ys7) => 
            [Cons, int32_mod(int32_add(int32_mul(x172)(y29))(carry3))(10), bigint_multiply_digit(x172)(ys7)(int32_div(int32_add(int32_mul(x172)(y29))(carry3))(10))]]);

var bigint_multiply_parts = a55 => b54 => base => 
    _match(a55, [
        [Cons, $, $], (x173, xs27) => 
            bigint_add_parts(bigint_add_zeroes(base)(bigint_multiply_digit(x173)(b54)(0)))(bigint_multiply_parts(xs27)(b54)(int32_add(base)(1)))(0),
        Empty, () => 
            Empty]);

var bigint_subtract = a56 => b55 => 
    _match([Pair, a56, b55], [
        [Pair, [Bigint, False, $], [Bigint, True, $]], (a_parts3, b_parts3) => 
            [Bigint, False, bigint_add_parts(a_parts3)(b_parts3)(0)],
        [Pair, [Bigint, True, $], [Bigint, False, $]], (a_parts4, b_parts4) => 
            [Bigint, True, bigint_add_parts(a_parts4)(b_parts4)(0)],
        [Pair, [Bigint, True, $], [Bigint, True, $]], (a_parts5, b_parts5) => 
            _match(bigint_less_than(a56)(b55), [
                True, () => 
                    [Bigint, True, bigint_trim_parts(bigint_subtract_parts(a_parts5)(b_parts5)(0))],
                False, () => 
                    [Bigint, False, bigint_trim_parts(bigint_subtract_parts(b_parts5)(a_parts5)(0))]]),
        [Pair, [Bigint, False, $], [Bigint, False, $]], (a_parts6, b_parts6) => 
            _match(bigint_less_than(a56)(b55), [
                True, () => 
                    [Bigint, True, bigint_trim_parts(bigint_subtract_parts(b_parts6)(a_parts6)(0))],
                False, () => 
                    [Bigint, False, bigint_trim_parts(bigint_subtract_parts(a_parts6)(b_parts6)(0))]])]);
module.exports.bigint_subtract = (a56,b55) => bigint_subtract(a56)(b55);

var bigint_add = a57 => b56 => 
    _match([Pair, a57, b56], [
        [Pair, [Bigint, False, $], [Bigint, False, $]], (a_parts7, b_parts7) => 
            [Bigint, False, bigint_add_parts(a_parts7)(b_parts7)(0)],
        [Pair, [Bigint, True, $], [Bigint, True, $]], (a_parts8, b_parts8) => 
            [Bigint, True, bigint_add_parts(a_parts8)(b_parts8)(0)],
        [Pair, [Bigint, True, $], [Bigint, False, $]], (x174, x175) => 
            bigint_subtract(b56)(bigint_negate(a57)),
        [Pair, [Bigint, False, $], [Bigint, True, $]], (x176, x177) => 
            bigint_subtract(a57)(bigint_negate(b56))]);
module.exports.bigint_add = (a57,b56) => bigint_add(a57)(b56);

var bigint_multiply = a58 => b57 => 
    _match([Pair, a58, b57], [
        [Pair, [Bigint, $, [Cons, 0, Empty]], [Bigint, $, $]], (x178, x179, x180) => 
            [Bigint, False, [Cons, 0, Empty]],
        [Pair, [Bigint, $, $], [Bigint, $, [Cons, 0, Empty]]], (x181, x182, x183) => 
            [Bigint, False, [Cons, 0, Empty]],
        [Pair, [Bigint, True, $], [Bigint, False, $]], (a_parts9, b_parts9) => 
            [Bigint, True, bigint_multiply_parts(a_parts9)(b_parts9)(0)],
        [Pair, [Bigint, False, $], [Bigint, True, $]], (a_parts10, b_parts10) => 
            [Bigint, True, bigint_trim_parts(bigint_multiply_parts(a_parts10)(b_parts10)(0))],
        [Pair, [Bigint, $, $], [Bigint, $, $]], (x184, a_parts11, x185, b_parts11) => 
            [Bigint, False, bigint_trim_parts(bigint_multiply_parts(a_parts11)(b_parts11)(0))]]);
module.exports.bigint_multiply = (a58,b57) => bigint_multiply(a58)(b57);


var $textEncoder = typeof TextEncoder != "undefined" ? new TextEncoder() : null;
var $textDecoder = typeof TextDecoder != "undefined" ? new TextDecoder() : null;
var $textEncode = $textEncoder ? $textEncoder.encode.bind($textEncoder) : Buffer.from;
var $textDecode = $textDecoder ? (bytes => $textDecoder.decode(new Uint8Array(bytes))) : (bytes => Buffer.from(bytes).toString());

function js_string_to_reuse(s) {
    var view = $textEncode(s);
    var reuse_string = string_empty();
    for (var byte of view) {
        reuse_string = string_append(byte)(reuse_string);
    }
    return reuse_string;
}
module.exports.js_string_to_reuse = js_string_to_reuse;

function js_list_to_reuse(l) {
    return l.reduceRight(function (a, b) { return list_cons(b)(a); }, list_empty());
}
module.exports.js_list_to_reuse = js_list_to_reuse;

function reuse_list_to_js(l) {
    var list = [];
    list_foldl(a => _ => list.push(a))(undefined)(l);
    return list;
}
module.exports.reuse_list_to_js = reuse_list_to_js;

function reuse_string_to_js(s) {
    var bytes = [];
    string_foldl(a => _ => bytes.push(a))(undefined)(s);
    return $textDecode(bytes);
}
module.exports.reuse_string_to_js = reuse_string_to_js;

function reuse_boolean_to_js(b) {
    return b === True;
}
module.exports.reuse_boolean_to_js = reuse_boolean_to_js;

function reuse_pair_to_js(p) {
    return [p[1], p[2]];
}
module.exports.reuse_pair_to_js = reuse_pair_to_js;


var data_expression_prefix = () => 
    string_from_list([Cons, 62, [Cons, 32, Empty]]);

var data_context_prefix = () => 
    string_from_list([Cons, 124, [Cons, 32, Empty]]);

var data_assertion_prefix = () => 
    string_from_list([Cons, 61, [Cons, 32, Empty]]);

var data_expected = () => 
    string_from_list([Cons, 101, [Cons, 120, [Cons, 112, [Cons, 101, [Cons, 99, [Cons, 116, [Cons, 101, [Cons, 100, Empty]]]]]]]]);

var data_expression = () => 
    string_from_list([Cons, 101, [Cons, 120, [Cons, 112, [Cons, 114, [Cons, 101, [Cons, 115, [Cons, 115, [Cons, 105, [Cons, 111, [Cons, 110, Empty]]]]]]]]]]);

var ExpectSuccess = { ExpectSuccess: true };
module.exports.ExpectSuccess = ExpectSuccess;
var ExpectFailure = { ExpectFailure: true };
module.exports.ExpectFailure = ExpectFailure;
var Comment = { Comment: true };
module.exports.Comment = Comment;

var line_matches = first_char => line => 
    x5(first_char)(maybe_or_else(0)(string_first(line)));

var collect_lines = first_char2 => lines => 
    string_join(string_of_char(10))(list_map(string_skip(2))(list_filter(line_matches(first_char2))(lines)));

var collect_success = lines2 => 
    [ExpectSuccess, collect_lines(124)(lines2), collect_lines(62)(lines2), collect_lines(61)(lines2)];

var collect_failure = lines3 => 
    [ExpectFailure, collect_lines(124)(lines3), collect_lines(62)(lines3), collect_lines(63)(lines3)];

var commit_requirement = result13 => 
    _match(result13, [
        [Pair, $, $], (lines4, requirements) => 
            _match([Pair, list_is_empty(lines4), list_any(line_matches(63))(lines4)], [
                [Pair, False, True], () => 
                    [Pair, list_empty(), [Cons, collect_failure(list_reverse(lines4)), requirements]],
                [Pair, False, False], () => 
                    [Pair, list_empty(), [Cons, collect_success(list_reverse(lines4)), requirements]],
                [Pair, True, $], (x186) => 
                    result13])]);

var append_line = line2 => result14 => 
    _match(result14, [
        [Pair, $, $], (lines5, requirements2) => 
            [Pair, [Cons, line2, lines5], requirements2]]);

var previous_line_is_assertion = result15 => 
    _match(result15, [
        [Pair, [Cons, $, $], $], (line3, x187, x188) => 
            or(line_matches(63)(line3))(line_matches(61)(line3)),
        $, (x189) => 
            False]);

var commit_comment = line4 => result16 => 
    _match(previous_line_is_assertion(result16), [
        True, () => 
            _match(commit_requirement(result16), [
                [Pair, $, $], (lines6, requirements3) => 
                    [Pair, lines6, [Cons, [Comment, line4], requirements3]]]),
        False, () => 
            _match(result16, [
                [Pair, $, $], (lines7, requirements4) => 
                    [Pair, lines7, [Cons, [Comment, line4], requirements4]]])]);

var append_non_assertion = line5 => result17 => 
    _match(previous_line_is_assertion(result17), [
        True, () => 
            append_line(line5)(commit_requirement(result17)),
        False, () => 
            append_line(line5)(result17)]);

var reduce_spec = line6 => result18 => 
    _match(string_first(line6), [
        [Some, 61], () => 
            append_line(line6)(result18),
        [Some, 63], () => 
            append_line(line6)(result18),
        [Some, 62], () => 
            append_non_assertion(line6)(result18),
        [Some, 124], () => 
            append_non_assertion(line6)(result18),
        $, (x190) => 
            _match(string_is_empty(line6), [
                True, () => 
                    result18,
                False, () => 
                    commit_comment(line6)(result18)])]);

var parse_spec = file => 
    list_reverse(pair_right(commit_requirement(list_foldl(reduce_spec)([Pair, list_empty(), list_empty()])(string_split(10)(string_from_slice(file))))));
module.exports.parse_spec = (file) => parse_spec(file);
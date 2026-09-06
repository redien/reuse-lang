var slice_empty = () => new Uint8Array();
var slice_of_u8 = x => count => { var array = new Uint8Array(count); array.fill(x, 0, count); return array; };
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
function $compose(...fs) {
    return x => fs.reduceRight((value, f) => f(value), x);
}
function $pipe(...fs) {
    return fs.reduce((value, f) => f(value));
}
function $trampoline(f) {
    while (f && f.$k) {
        f = f.$k();
    }
    return f;
}
var $ = {};
module.exports.$ = $;
function $match(value, cases) {
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
module.exports.match = $match;
var ArrayAdd = { ArrayAdd: true };
var ArraySubtract = { ArraySubtract: true };
var ArrayMultiply = { ArrayMultiply: true };
var ArrayDivide = { ArrayDivide: true };
var ArrayEqual = { ArrayEqual: true };
var ArrayNotEqual = { ArrayNotEqual: true };
var ArrayLessThan = { ArrayLessThan: true };
var ArrayLessThanEqual = { ArrayLessThanEqual: true };
var ArrayGreaterThan = { ArrayGreaterThan: true };
var ArrayGreaterThanEqual = { ArrayGreaterThanEqual: true };
var ArrayAnd = { ArrayAnd: true };
var ArrayOr = { ArrayOr: true };
var ArrayNand = { ArrayNand: true };
var ArrayXor = { ArrayXor: true };

var ArrayOfInt32 = { ArrayOfInt32: true };
var ArrayConcat = { ArrayConcat: true };
var ArrayGenerate = { ArrayGenerate: true };
var ArrayShape = { ArrayShape: true };
var ArrayMap = { ArrayMap: true };
var ArrayReduce = { ArrayReduce: true };
var ArrayScan = { ArrayScan: true };
var ArrayCompress = { ArrayCompress: true };
var ArrayFromSlice = { ArrayFromSlice: true };

var $array_add = (x, y) => x + y;
var $array_subtract = (x, y) => x - y;
var $array_multiply = (x, y) => x * y;
var $array_divide = (x, y) => x / y;
var $array_and = (x, y) => x & y;
var $array_or = (x, y) => x | y;
var $array_nand = (x, y) => ~(x & y);
var $array_xor = (x, y) => x ^ y;
var $array_equal = (x, y) => (x === y) | 0;
var $array_not_equal = (x, y) => (x !== y) | 0;
var $array_less_than = (x, y) => (x < y) | 0;
var $array_less_than_equal = (x, y) => (x <= y) | 0;
var $array_greater_than = (x, y) => (x > y) | 0;
var $array_greater_than_equal = (x, y) => (x >= y) | 0;

var $select_op = op => {
    switch (op) {
        case ArrayAdd: return $array_add;
        case ArraySubtract: return $array_subtract;
        case ArrayMultiply: return $array_multiply;
        case ArrayDivide: return $array_divide;
        case ArrayAnd: return $array_and;
        case ArrayOr: return $array_or;
        case ArrayNand: return $array_nand;
        case ArrayXor: return $array_xor;
        case ArrayNotEqual: return $array_not_equal;
        case ArrayEqual: return $array_equal;
        case ArrayLessThan: return $array_less_than;
        case ArrayLessThanEqual: return $array_less_than_equal;
        case ArrayGreaterThan: return $array_greater_than;
        case ArrayGreaterThanEqual: return $array_greater_than_equal;

        default:
            throw "Invalid array operator";
    }
};

var $array_compress = (array, mask) => {
    var length = Math.min(array.length, mask.length);
    var data = new Int32Array(length);

    var j = 0;
    for (var i = 0; i < length; ++i) {
        data[j] = array[i];
        j += (mask[i] !== 0) | 0;
    }

    return data.slice(0, j);
};

var $array_map2 = (a, b, op) => {
    var length = Math.min(a.length, b.length);
    var data = new Int32Array(length);
    for (var i = 0; i < length; ++i) {
        data[i] = op(a[i], b[i]);
    }
    return data;
};

var $array_map = (a, f) => {
    var length = a.length;
    var data = new Int32Array(length);
    for (var i = 0; i < length; ++i) {
        data[i] = f(a[i]);
    }
    return data;
};

var $array_eval = array => {
    return $match(array, [
        [ArrayOfInt32, $], x => {
            var data = new Int32Array(1);
            data[0] = x;
            return { data, shape: [1] };
        },
        [ArrayConcat, $, $], (_a, _b) => {
            var a = $array_eval(_a);
            var b = $array_eval(_b);
            var data = new Int32Array(a.data.length + b.data.length);
            data.set(a.data);
            data.set(b.data, a.data.length);
            return { data, shape: [data.length] };
        },
        [ArrayGenerate, $, $], (_shape, x) => {
            var __shape = $array_eval(_shape);

            var mask = $array_map(__shape.data, x => $array_less_than_equal(0, x));
            var shape = $array_compress(__shape.data, mask);

            if (shape.length > 0) {
                var size = shape.reduce((a, b) => a * Math.max(b, 0), 1);
                var data = new Int32Array(size);
                data.fill(x, 0, size);
                return { data, shape };
            } else {
                return { data: [], shape: [] };
            }
        },
        [ArrayShape, $], _array => {
            var array = $array_eval(_array);
            return { data: new Int32Array(array.shape), shape: [array.shape.length] };
        },
        [ArrayMap, $, $, $], (_op, _a, _b) => {
            var a = $array_eval(_a);
            var b = $array_eval(_b);
            var op = $select_op(_op);
            var data = $array_map2(a.data, b.data, op);
            return { data, shape: [data.length] };
        },
        [ArrayReduce, $, $, $], (_op, k, _array) => {
            var array = $array_eval(_array);
            var op = $select_op(_op);
            var length = array.data.length;
            for (var i = 0; i < length; ++i) {
                k = op(k, array.data[i]);
            }
            var data = new Int32Array(1);
            data[0] = k;
            return { data, shape: [1] };
        },
        [ArrayScan, $, $, $], (_op, k, _array) => {
            var array = $array_eval(_array);
            var op = $select_op(_op);
            var length = array.data.length;
            var data = new Int32Array(length);
            for (var i = 0; i < length; ++i) {
                k = op(k, array.data[i]);
                data[i] = k;
            }
            return { data, shape: array.shape };
        },
        [ArrayCompress, $, $], (_mask, _array) => {
            var mask = $array_eval(_mask);
            var array = $array_eval(_array);
            var result = $array_compress(array.data, mask.data);
            return { data: result, shape: [result.length] };
        },
        [ArrayFromSlice, $], (slice) => {
            var result = new Int32Array(slice.buffer, 0, (slice.buffer.byteLength / 4) | 0);
            return { data: result, shape: [result.length] };
        }
    ]);
};
var array_foldl = f => ys => xs => $array_eval(xs).data.reduce((a, b) => f(a)(b), ys);
module.exports.array_foldl = array_foldl;

var array_to_slice = xs => new Uint8Array($array_eval(xs).data.buffer);
module.exports.array_to_slice = array_to_slice;


var id = x7 => 
    x7;
module.exports.id = (x7) => id(x7);

var const2 = a => b => 
    a;
module.exports.const2 = (a,b) => const2(a)(b);

var flip = f => 
    (b2 => a2 => f(a2)(b2));
module.exports.flip = (f) => flip(f);

var x = f2 => g => x8 => y => 
    f2(g(x8)(y));
module.exports.x = (f2,g,x8,y) => x(f2)(g)(x8)(y);

var fix = f3 => 
    f3(fix(f3));
module.exports.fix = (f3) => fix(f3);

var let_bind = x9 => f4 => 
    f4(x9);
module.exports.let_bind = (x9,f4) => let_bind(x9)(f4);

var True = { True: true };
module.exports.True = True;
var False = { False: true };
module.exports.False = False;

var not = a3 => 
    $match(a3, [
        True, () => 
            False,
        False, () => 
            True]);
module.exports.not = (a3) => not(a3);

var and = a4 => b3 => 
    $match(a4, [
        True, () => 
            b3,
        False, () => 
            False]);
module.exports.and = (a4,b3) => and(a4)(b3);

var or = a5 => b4 => 
    $match(a5, [
        True, () => 
            True,
        False, () => 
            b4]);
module.exports.or = (a5,b4) => or(a5)(b4);

var x2 = a6 => b5 => 
    (a6<b5 ? True : False);
module.exports.x2 = (a6,b5) => x2(a6)(b5);

var x3 = a7 => b6 => 
    x2(b6)(a7);
module.exports.x3 = (a7,b6) => x3(a7)(b6);

var x4 = a8 => b7 => 
    not(or(x2(a8)(b7))(x3(a8)(b7)));
module.exports.x4 = (a8,b7) => x4(a8)(b7);

var x5 = a9 => b8 => 
    or(x2(a9)(b8))(x4(a9)(b8));
module.exports.x5 = (a9,b8) => x5(a9)(b8);

var x6 = a10 => b9 => 
    or(x3(a10)(b9))(x4(a10)(b9));
module.exports.x6 = (a10,b9) => x6(a10)(b9);

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

var pair_dup = a14 => 
    [Pair, a14, a14];
module.exports.pair_dup = (a14) => pair_dup(a14);

var pair_left = pair2 => 
    $match(pair2, [
        [Pair, $, $], (x10, x11) => 
            x10]);
module.exports.pair_left = (pair2) => pair_left(pair2);

var pair_right = pair3 => 
    $match(pair3, [
        [Pair, $, $], (x12, x13) => 
            x13]);
module.exports.pair_right = (pair3) => pair_right(pair3);

var pair_map = f5 => pair4 => 
    $match(pair4, [
        [Pair, $, $], (x14, y2) => 
            f5(x14)(y2)]);
module.exports.pair_map = (f5,pair4) => pair_map(f5)(pair4);

var pair_bimap = f6 => g2 => pair5 => 
    $match(pair5, [
        [Pair, $, $], (x15, y3) => 
            [Pair, f6(x15), g2(y3)]]);
module.exports.pair_bimap = (f6,g2,pair5) => pair_bimap(f6)(g2)(pair5);

var pair_map_left = f7 => pair6 => 
    $match(pair6, [
        [Pair, $, $], (x16, y4) => 
            [Pair, f7(x16), y4]]);
module.exports.pair_map_left = (f7,pair6) => pair_map_left(f7)(pair6);

var pair_map_right = f8 => pair7 => 
    $match(pair7, [
        [Pair, $, $], (x17, y5) => 
            [Pair, x17, f8(y5)]]);
module.exports.pair_map_right = (f8,pair7) => pair_map_right(f8)(pair7);

var pair_swap = pair8 => 
    $match(pair8, [
        [Pair, $, $], (x18, y6) => 
            [Pair, y6, x18]]);
module.exports.pair_swap = (pair8) => pair_swap(pair8);

var Some = { Some: true };
module.exports.Some = Some;
var None = { None: true };
module.exports.None = None;

var maybe_map = f9 => maybe2 => 
    $match(maybe2, [
        [Some, $], (x19) => 
            [Some, f9(x19)],
        None, () => 
            None]);
module.exports.maybe_map = (f9,maybe2) => maybe_map(f9)(maybe2);

var maybe_flatmap = f10 => maybe3 => 
    $match(maybe3, [
        [Some, $], (x20) => 
            f10(x20),
        None, () => 
            None]);
module.exports.maybe_flatmap = (f10,maybe3) => maybe_flatmap(f10)(maybe3);

var maybe_bind = maybe4 => f11 => 
    maybe_flatmap(f11)(maybe4);
module.exports.maybe_bind = (maybe4,f11) => maybe_bind(maybe4)(f11);

var maybe_return = x21 => 
    [Some, x21];
module.exports.maybe_return = (x21) => maybe_return(x21);

var maybe_filter = f12 => maybe5 => 
    $match(maybe5, [
        [Some, $], (x22) => 
            $match(f12(x22), [
                True, () => 
                    maybe5,
                False, () => 
                    None]),
        None, () => 
            None]);
module.exports.maybe_filter = (f12,maybe5) => maybe_filter(f12)(maybe5);

var maybe_else = f13 => maybe6 => 
    $match(maybe6, [
        None, () => 
            f13(),
        [Some, $], (x23) => 
            x23]);
module.exports.maybe_else = (f13,maybe6) => maybe_else(f13)(maybe6);

var maybe_or_else = value => maybe7 => 
    $match(maybe7, [
        None, () => 
            value,
        [Some, $], (x24) => 
            x24]);
module.exports.maybe_or_else = (value,maybe7) => maybe_or_else(value)(maybe7);

var IterableClass = { IterableClass: true };
module.exports.IterableClass = IterableClass;

var iterable_next = class2 => collection => 
    $match(class2, [
        [IterableClass, $], (next) => 
            next(collection)]);
module.exports.iterable_next = (class2,collection) => iterable_next(class2)(collection);

var IndexedIterator = { IndexedIterator: true };
module.exports.IndexedIterator = IndexedIterator;

var indexed_iterator_from_iterable = i => iterable => 
    [IndexedIterator, i, iterable, 0];
module.exports.indexed_iterator_from_iterable = (i,iterable) => indexed_iterator_from_iterable(i)(iterable);

var indexed_iterator_next = iterator => 
    $match(iterator, [
        [IndexedIterator, $, $, $], (i2, iterable2, index) => 
            $match(iterable_next(i2)(iterable2), [
                [Pair, $, $], (value2, next_iterable) => 
                    [Pair, value2, [IndexedIterator, i2, next_iterable, int32_add(index)(1)]]])]);
module.exports.indexed_iterator_next = (iterator) => indexed_iterator_next(iterator);

var indexed_iterator_index = iterator2 => 
    $match(iterator2, [
        [IndexedIterator, $, $, $], (x25, x26, index2) => 
            index2]);
module.exports.indexed_iterator_index = (iterator2) => indexed_iterator_index(iterator2);

var Cons = { Cons: true };
module.exports.Cons = Cons;
var Empty = { Empty: true };
module.exports.Empty = Empty;

var list_empty = () => 
    Empty;
module.exports.list_empty = () => list_empty();

var list_cons = x27 => xs => 
    [Cons, x27, xs];
module.exports.list_cons = (x27,xs) => list_cons(x27)(xs);

var list_from = x28 => 
    [Cons, x28, Empty];
module.exports.list_from = (x28) => list_from(x28);

var list_from_range2 = from => to => rest => {
    var $tailcall = from => to => rest => 
        $match(x3(to)(from), [
            True, () => 
                ({$k:() => $tailcall (from)(int32_sub(to)(1))([Cons, int32_sub(to)(1), rest])}),
            False, () => 
                rest]);
    return $trampoline($tailcall(from)(to)(rest));
};

var list_from_range = from2 => to2 => 
    list_from_range2(from2)(to2)(Empty);
module.exports.list_from_range = (from2,to2) => list_from_range(from2)(to2);

var list_first = list2 => 
    $match(list2, [
        [Cons, $, $], (x29, x30) => 
            [Some, x29],
        Empty, () => 
            None]);
module.exports.list_first = (list2) => list_first(list2);

var list_rest = list3 => 
    $match(list3, [
        [Cons, $, $], (x31, rest2) => 
            rest2,
        Empty, () => 
            Empty]);
module.exports.list_rest = (list3) => list_rest(list3);

var list_last = list4 => {
    var $tailcall = list4 => 
        $match(list4, [
            Empty, () => 
                None,
            [Cons, $, Empty], (x32) => 
                [Some, x32],
            [Cons, $, $], (x33, rest3) => 
                ({$k:() => $tailcall (rest3)})]);
    return $trampoline($tailcall(list4));
};
module.exports.list_last = (list4) => list_last(list4);

var list_is_empty = list5 => 
    $match(list5, [
        [Cons, $, $], (x34, x35) => 
            False,
        Empty, () => 
            True]);
module.exports.list_is_empty = (list5) => list_is_empty(list5);

var list_size2 = list6 => size => {
    var $tailcall = list6 => size => 
        $match(list6, [
            [Cons, $, $], (x36, rest4) => 
                ({$k:() => $tailcall (rest4)(int32_add(size)(1))}),
            Empty, () => 
                size]);
    return $trampoline($tailcall(list6)(size));
};

var list_size = list7 => 
    list_size2(list7)(0);
module.exports.list_size = (list7) => list_size(list7);

var list_foldrk = f14 => initial => list8 => continue2 => {
    var $tailcall = f14 => initial => list8 => continue2 => 
        $match(list8, [
            Empty, () => 
                continue2(initial),
            [Cons, $, $], (x37, xs2) => 
                ({$k:() => $tailcall (f14)(initial)(xs2)((value3 => f14(x37)(value3)(continue2)))})]);
    return $trampoline($tailcall(f14)(initial)(list8)(continue2));
};
module.exports.list_foldrk = (f14,initial,list8,continue2) => list_foldrk(f14)(initial)(list8)(continue2);

var list_foldlk = f15 => initial2 => list9 => continue3 => 
    $match(list9, [
        Empty, () => 
            continue3(initial2),
        [Cons, $, $], (x38, xs3) => 
            f15(x38)(initial2)((new_value => list_foldlk(f15)(new_value)(xs3)(continue3)))]);
module.exports.list_foldlk = (f15,initial2,list9,continue3) => list_foldlk(f15)(initial2)(list9)(continue3);

var list_foldr = f16 => initial3 => list10 => 
    list_foldrk((x39 => value4 => continue4 => continue4(f16(x39)(value4))))(initial3)(list10)((x40 => x40));
module.exports.list_foldr = (f16,initial3,list10) => list_foldr(f16)(initial3)(list10);

var list_foldl = f17 => initial4 => list11 => {
    var $tailcall = f17 => initial4 => list11 => 
        $match(list11, [
            Empty, () => 
                initial4,
            [Cons, $, $], (x41, xs4) => 
                ({$k:() => $tailcall (f17)(f17(x41)(initial4))(xs4)})]);
    return $trampoline($tailcall(f17)(initial4)(list11));
};
module.exports.list_foldl = (f17,initial4,list11) => list_foldl(f17)(initial4)(list11);

var list_concat = a15 => b13 => 
    list_foldr(list_cons)(b13)(a15);
module.exports.list_concat = (a15,b13) => list_concat(a15)(b13);

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

var list_split_at2 = n => a16 => b14 => {
    var $tailcall = n => a16 => b14 => 
        $match(x3(n)(0), [
            True, () => 
                $match(b14, [
                    [Cons, $, $], (x42, xs5) => 
                        ({$k:() => $tailcall (int32_sub(n)(1))([Cons, x42, a16])(xs5)}),
                    Empty, () => 
                        [Pair, list_reverse(a16), b14]]),
            False, () => 
                [Pair, list_reverse(a16), b14]]);
    return $trampoline($tailcall(n)(a16)(b14));
};

var list_split_at = n2 => xs6 => 
    list_split_at2(n2)(Empty)(xs6);
module.exports.list_split_at = (n2,xs6) => list_split_at(n2)(xs6);

var list_partition2 = n3 => xs7 => partitions => {
    var $tailcall = n3 => xs7 => partitions => 
        $match(list_split_at(n3)(xs7), [
            [Pair, Empty, $], (x43) => 
                partitions,
            [Pair, $, $], (partition, xs8) => 
                ({$k:() => $tailcall (n3)(xs8)([Cons, partition, partitions])})]);
    return $trampoline($tailcall(n3)(xs7)(partitions));
};

var list_partition = n4 => xs9 => 
    list_reverse(list_partition2(n4)(xs9)(Empty));
module.exports.list_partition = (n4,xs9) => list_partition(n4)(xs9);

var list_partition_by2 = x44 => xs10 => 
    $match(xs10, [
        [Cons, $, $], (partition2, rest5) => 
            [Cons, [Cons, x44, partition2], rest5],
        Empty, () => 
            xs10]);

var list_partition_by = f20 => xs11 => 
    $match(xs11, [
        Empty, () => 
            Empty,
        [Cons, $, Empty], (x45) => 
            [Cons,[Cons,x45,Empty],Empty],
        [Cons, $, [Cons, $, $]], (x46, x47, rest6) => 
            $match(f20(x46)(x47), [
                True, () => 
                    list_partition_by2(x46)(list_partition_by(f20)([Cons, x47, rest6])),
                False, () => 
                    [Cons, [Cons,x46,Empty], list_partition_by(f20)([Cons, x47, rest6])]])]);
module.exports.list_partition_by = (f20,xs11) => list_partition_by(f20)(xs11);

var list_skip = count => list16 => 
    pair_right(list_split_at(count)(list16));
module.exports.list_skip = (count,list16) => list_skip(count)(list16);

var list_take = count2 => list17 => 
    pair_left(list_split_at(count2)(list17));
module.exports.list_take = (count2,list17) => list_take(count2)(list17);

var list_zip2 = xs12 => ys => collected => {
    var $tailcall = xs12 => ys => collected => 
        $match(xs12, [
            Empty, () => 
                collected,
            [Cons, $, $], (x48, xs13) => 
                $match(ys, [
                    Empty, () => 
                        collected,
                    [Cons, $, $], (y7, ys2) => 
                        ({$k:() => $tailcall (xs13)(ys2)([Cons, [Pair, x48, y7], collected])})])]);
    return $trampoline($tailcall(xs12)(ys)(collected));
};

var list_zip = xs14 => ys3 => 
    list_reverse(list_zip2(xs14)(ys3)(Empty));
module.exports.list_zip = (xs14,ys3) => list_zip(xs14)(ys3);

var list_mapi = f21 => list18 => 
    list_map(pair_map(f21))(list_zip(list18)(list_from_range(0)(list_size(list18))));
module.exports.list_mapi = (f21,list18) => list_mapi(f21)(list18);

var list_pairs = xs15 => 
    $match(xs15, [
        [Cons, $, [Cons, $, $]], (a17, b15, rest7) => 
            [Cons, [Pair, a17, b15], list_pairs(rest7)],
        $, (x49) => 
            Empty]);
module.exports.list_pairs = (xs15) => list_pairs(xs15);

var list_find_first = predicate => list19 => {
    var $tailcall = predicate => list19 => 
        $match(list19, [
            Empty, () => 
                None,
            [Cons, $, $], (x50, xs16) => 
                $match(predicate(x50), [
                    True, () => 
                        [Some, x50],
                    False, () => 
                        ({$k:() => $tailcall (predicate)(xs16)})])]);
    return $trampoline($tailcall(predicate)(list19));
};
module.exports.list_find_first = (predicate,list19) => list_find_first(predicate)(list19);

var list_filter = f22 => list20 => 
    list_foldr((head3 => tail3 => $match(f22(head3), [
        True, () => 
            [Cons, head3, tail3],
        False, () => 
            tail3])))(Empty)(list20);
module.exports.list_filter = (f22,list20) => list_filter(f22)(list20);

var list_exclude = f23 => list21 => 
    list_filter($compose(not,f23))(list21);
module.exports.list_exclude = (f23,list21) => list_exclude(f23)(list21);

var list_any = f24 => list22 => 
    $match(list_find_first(f24)(list22), [
        [Some, $], (x51) => 
            True,
        $, (x52) => 
            False]);
module.exports.list_any = (f24,list22) => list_any(f24)(list22);

var list_every = f25 => list23 => 
    $match(list_find_first((x53 => not(f25(x53))))(list23), [
        [Some, $], (x54) => 
            False,
        $, (x55) => 
            True]);
module.exports.list_every = (f25,list23) => list_every(f25)(list23);

var list_from_maybe = maybe8 => 
    $match(maybe8, [
        [Some, $], (x56) => 
            [Cons,x56,Empty],
        None, () => 
            Empty]);
module.exports.list_from_maybe = (maybe8) => list_from_maybe(maybe8);

var list_collect_from_indexed_iterator2 = predicate2 => iterator3 => initial5 => {
    var $tailcall = predicate2 => iterator3 => initial5 => 
        $match(indexed_iterator_next(iterator3), [
            [Pair, None, $], (x57) => 
                [Pair, iterator3, initial5],
            [Pair, [Some, $], $], (x58, next2) => 
                $match(predicate2(x58), [
                    True, () => 
                        ({$k:() => $tailcall (predicate2)(next2)([Cons, x58, initial5])}),
                    False, () => 
                        [Pair, iterator3, initial5]])]);
    return $trampoline($tailcall(predicate2)(iterator3)(initial5));
};

var list_collect_from_indexed_iterator = predicate3 => iterator4 => 
    $match(list_collect_from_indexed_iterator2(predicate3)(iterator4)(Empty), [
        [Pair, $, $], (iterator5, result2) => 
            [Pair, iterator5, list_reverse(result2)]]);
module.exports.list_collect_from_indexed_iterator = (predicate3,iterator4) => list_collect_from_indexed_iterator(predicate3)(iterator4);

var maybe_concat = maybes => 
    list_foldr((maybe9 => values => $match(maybe9, [
        [Some, $], (value5) => 
            [Cons, value5, values],
        None, () => 
            values])))(Empty)(maybes);
module.exports.maybe_concat = (maybes) => maybe_concat(maybes);

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
    $match(node, [
        [FTValue, $], (x59) => 
            1,
        [FTNode2, $, $, $], (size2, x60, x61) => 
            size2,
        [FTNode3, $, $, $, $], (size3, x62, x63, x64) => 
            size3]);

var string_node2 = a18 => b16 => 
    [FTNode2, int32_add(string_node_size(a18))(string_node_size(b16)), a18, b16];

var string_node3 = a19 => b17 => c => 
    [FTNode3, int32_add(string_node_size(a19))(int32_add(string_node_size(b17))(string_node_size(c))), a19, b17, c];

var string_prepend_node = a20 => tree => 
    $match(tree, [
        FTEmpty, () => 
            [FTSingle, a20],
        [FTSingle, $], (x65) => 
            [FTDeep, [Cons,a20,Empty], FTEmpty, [Cons,x65,Empty]],
        [FTDeep, $, $, $], (first, middle, last) => 
            $match(first, [
                [Cons, $, [Cons, $, [Cons, $, [Cons, $, Empty]]]], (b18, c2, d, e) => 
                    [FTDeep, [Cons,a20,[Cons,b18,Empty]], string_prepend_node(string_node3(c2)(d)(e))(middle), last],
                $, (x66) => 
                    [FTDeep, [Cons, a20, first], middle, last]])]);

var string_prepend = char => string2 => 
    string_prepend_node([FTValue, char])(string2);
module.exports.string_prepend = (char,string2) => string_prepend(char)(string2);

var string_append_node = a21 => tree2 => 
    $match(tree2, [
        FTEmpty, () => 
            [FTSingle, a21],
        [FTSingle, $], (x67) => 
            [FTDeep, [Cons,x67,Empty], FTEmpty, [Cons,a21,Empty]],
        [FTDeep, $, $, $], (first2, middle2, last2) => 
            $match(last2, [
                [Cons, $, [Cons, $, [Cons, $, [Cons, $, Empty]]]], (b19, c3, d2, e2) => 
                    [FTDeep, first2, string_append_node(string_node3(e2)(d2)(c3))(middle2), [Cons,a21,[Cons,b19,Empty]]],
                $, (x68) => 
                    [FTDeep, first2, middle2, [Cons, a21, last2]]])]);

var string_append = char2 => string3 => 
    string_append_node([FTValue, char2])(string3);
module.exports.string_append = (char2,string3) => string_append(char2)(string3);

var string_first_node = node2 => {
    var $tailcall = node2 => 
        $match(node2, [
            [FTValue, $], (x69) => 
                x69,
            [FTNode2, $, $, $], (x70, x71, x72) => 
                ({$k:() => $tailcall (x71)}),
            [FTNode3, $, $, $, $], (x73, x74, x75, x76) => 
                ({$k:() => $tailcall (x74)})]);
    return $trampoline($tailcall(node2));
};

var string_first = string4 => 
    $match(string4, [
        FTEmpty, () => 
            None,
        [FTSingle, $], (node3) => 
            [Some, string_first_node(node3)],
        [FTDeep, $, $, $], (first3, middle3, last3) => 
            maybe_map(string_first_node)(list_first(first3))]);
module.exports.string_first = (string4) => string_first(string4);

var string_rest_node = node4 => 
    $match(node4, [
        [FTValue, $], (x77) => 
            None,
        [FTNode2, $, $, $], (x78, a22, b20) => 
            $match(string_rest_node(a22), [
                [Some, $], (node5) => 
                    [Some, string_node2(node5)(b20)],
                None, () => 
                    [Some, b20]]),
        [FTNode3, $, $, $, $], (x79, a23, b21, c4) => 
            $match(string_rest_node(a23), [
                [Some, $], (node6) => 
                    [Some, string_node3(node6)(b21)(c4)],
                None, () => 
                    [Some, string_node2(b21)(c4)]])]);

var string_rest = string5 => 
    $match(string5, [
        FTEmpty, () => 
            string5,
        [FTSingle, $], (node7) => 
            $match(string_rest_node(node7), [
                [Some, $], (node8) => 
                    [FTSingle, node8],
                None, () => 
                    FTEmpty]),
        [FTDeep, [Cons, $, $], $, $], (node9, rest8, middle4, last4) => 
            $match(string_rest_node(node9), [
                [Some, $], (node10) => 
                    [FTDeep, [Cons, node10, rest8], middle4, last4],
                None, () => 
                    $match(rest8, [
                        Empty, () => 
                            list_foldr(string_append_node)(middle4)(last4),
                        $, (x80) => 
                            [FTDeep, rest8, middle4, last4]])]),
        $, (x81) => 
            string5]);
module.exports.string_rest = (string5) => string_rest(string5);

var string_foldr_node = f26 => node11 => identity => {
    var $tailcall = f26 => node11 => identity => 
        $match(node11, [
            [FTValue, $], (a24) => 
                f26(a24)(identity),
            [FTNode2, $, $, $], (x82, a25, b22) => 
                ({$k:() => $tailcall (f26)(a25)(string_foldr_node(f26)(b22)(identity))}),
            [FTNode3, $, $, $, $], (x83, a26, b23, c5) => 
                ({$k:() => $tailcall (f26)(a26)(string_foldr_node(f26)(b23)(string_foldr_node(f26)(c5)(identity)))})]);
    return $trampoline($tailcall(f26)(node11)(identity));
};

var string_foldr = f27 => identity2 => tree3 => 
    $match(tree3, [
        FTEmpty, () => 
            identity2,
        [FTSingle, $], (x84) => 
            string_foldr_node(f27)(x84)(identity2),
        [FTDeep, $, $, $], (first4, middle5, last5) => 
            list_foldr(string_foldr_node(f27))(string_foldr(f27)(list_foldl(string_foldr_node(f27))(identity2)(last5))(middle5))(first4)]);
module.exports.string_foldr = (f27,identity2,tree3) => string_foldr(f27)(identity2)(tree3);

var string_foldl_node = f28 => node12 => identity3 => {
    var $tailcall = f28 => node12 => identity3 => 
        $match(node12, [
            [FTValue, $], (a27) => 
                f28(a27)(identity3),
            [FTNode2, $, $, $], (x85, b24, a28) => 
                ({$k:() => $tailcall (f28)(a28)(string_foldl_node(f28)(b24)(identity3))}),
            [FTNode3, $, $, $, $], (x86, c6, b25, a29) => 
                ({$k:() => $tailcall (f28)(a29)(string_foldl_node(f28)(b25)(string_foldl_node(f28)(c6)(identity3)))})]);
    return $trampoline($tailcall(f28)(node12)(identity3));
};

var string_foldl = f29 => identity4 => tree4 => 
    $match(tree4, [
        FTEmpty, () => 
            identity4,
        [FTSingle, $], (x87) => 
            string_foldl_node(f29)(x87)(identity4),
        [FTDeep, $, $, $], (first5, middle6, last6) => 
            list_foldr(string_foldl_node(f29))(string_foldl(f29)(list_foldl(string_foldl_node(f29))(identity4)(first5))(middle6))(last6)]);
module.exports.string_foldl = (f29,identity4,tree4) => string_foldl(f29)(identity4)(tree4);

var string_size = string6 => 
    $match(string6, [
        FTEmpty, () => 
            0,
        [FTSingle, $], (x88) => 
            string_node_size(x88),
        [FTDeep, $, $, $], (first6, middle7, last7) => 
            int32_add(list_foldr(int32_add)(0)(list_map(string_node_size)(first6)))(int32_add(list_foldr(int32_add)(0)(list_map(string_node_size)(last7)))(string_size(middle7)))]);
module.exports.string_size = (string6) => string_size(string6);

var string_concat_nodes = nodes => 
    $match(nodes, [
        [Cons, $, [Cons, $, Empty]], (a30, b26) => 
            [Cons,string_node2(a30)(b26),Empty],
        [Cons, $, [Cons, $, [Cons, $, Empty]]], (a31, b27, c7) => 
            [Cons,string_node3(a31)(b27)(c7),Empty],
        [Cons, $, [Cons, $, [Cons, $, [Cons, $, Empty]]]], (a32, b28, c8, d3) => 
            [Cons,string_node2(a32)(b28),[Cons,string_node2(c8)(d3),Empty]],
        [Cons, $, [Cons, $, [Cons, $, $]]], (a33, b29, c9, rest9) => 
            [Cons, string_node3(a33)(b29)(c9), string_concat_nodes(rest9)],
        $, (x89) => 
            Empty]);

var Triple = { Triple: true };

var string_concat2 = a34 => nodes2 => b30 => 
    $match([Triple, a34, nodes2, b30], [
        [Triple, FTEmpty, $, $], (nodes3, b31) => 
            list_foldr(string_prepend_node)(b31)(nodes3),
        [Triple, $, $, FTEmpty], (a35, nodes4) => 
            list_foldl(string_append_node)(a35)(nodes4),
        [Triple, [FTSingle, $], $, $], (x90, nodes5, b32) => 
            string_prepend_node(x90)(list_foldr(string_prepend_node)(b32)(nodes5)),
        [Triple, $, $, [FTSingle, $]], (a36, nodes6, x91) => 
            string_append_node(x91)(list_foldl(string_append_node)(a36)(nodes6)),
        [Triple, [FTDeep, $, $, $], $, [FTDeep, $, $, $]], (first1, middle1, last1, nodes7, first22, middle22, last22) => 
            [FTDeep, first1, string_concat2(middle1)(string_concat_nodes(list_concat(list_reverse(last1))(list_concat(nodes7)(first22))))(middle22), last22]]);

var string_concat = a37 => b33 => 
    string_concat2(a37)(Empty)(b33);
module.exports.string_concat = (a37,b33) => string_concat(a37)(b33);

var string_is_empty = string7 => 
    $match(string_first(string7), [
        [Some, $], (x92) => 
            False,
        None, () => 
            True]);
module.exports.string_is_empty = (string7) => string_is_empty(string7);

var string_any = predicate4 => string8 => 
    string_foldl((x93 => b34 => or(predicate4(x93))(b34)))(False)(string8);
module.exports.string_any = (predicate4,string8) => string_any(predicate4)(string8);

var string_every = predicate5 => string9 => 
    string_foldl((x94 => b35 => and(predicate5(x94))(b35)))(True)(string9);
module.exports.string_every = (predicate5,string9) => string_every(predicate5)(string9);

var string_to_list = string10 => 
    string_foldr(list_cons)(Empty)(string10);
module.exports.string_to_list = (string10) => string_to_list(string10);

var string_from_list = list24 => 
    list_foldl(string_append)(string_empty())(list24);
module.exports.string_from_list = (list24) => string_from_list(list24);

var string_skip = count3 => string11 => {
    var $tailcall = count3 => string11 => 
        $match(string11, [
            FTEmpty, () => 
                FTEmpty,
            $, (x95) => 
                $match(x3(count3)(0), [
                    True, () => 
                        ({$k:() => $tailcall (int32_sub(count3)(1))(string_rest(string11))}),
                    False, () => 
                        string11])]);
    return $trampoline($tailcall(count3)(string11));
};
module.exports.string_skip = (count3,string11) => string_skip(count3)(string11);

var string_take2 = count4 => string12 => taken => {
    var $tailcall = count4 => string12 => taken => 
        $match(x3(count4)(0), [
            True, () => 
                $match(string_first(string12), [
                    [Some, $], (char3) => 
                        ({$k:() => $tailcall (int32_sub(count4)(1))(string_rest(string12))(string_append(char3)(taken))}),
                    None, () => 
                        taken]),
            False, () => 
                taken]);
    return $trampoline($tailcall(count4)(string12)(taken));
};

var string_take = count5 => string13 => 
    string_take2(count5)(string13)(string_empty());
module.exports.string_take = (count5,string13) => string_take(count5)(string13);

var string_reverse = string14 => 
    string_foldl(string_prepend)(string_empty())(string14);
module.exports.string_reverse = (string14) => string_reverse(string14);

var string_repeat = string15 => n5 => 
    list_foldl(x(string_concat(string15))(flip(const2)))(string_empty())(list_from_range(0)(n5));
module.exports.string_repeat = (string15,n5) => string_repeat(string15)(n5);

var string_substring = start => size4 => string16 => 
    string_take(size4)(string_skip(start)(string16));
module.exports.string_substring = (start,size4,string16) => string_substring(start)(size4)(string16);

var string_join = separator => strings => 
    $match(strings, [
        [Cons, $, $], (first7, rest10) => 
            list_foldl((string17 => joined => string_concat(joined)(string_concat(separator)(string17))))(first7)(rest10),
        Empty, () => 
            string_empty()]);
module.exports.string_join = (separator,strings) => string_join(separator)(strings);

var string_flatmap = f30 => string18 => 
    string_foldl((x96 => xs17 => string_concat(xs17)(f30(x96))))(string_empty())(string18);
module.exports.string_flatmap = (f30,string18) => string_flatmap(f30)(string18);

var string_split2 = separator2 => list25 => current => parts => {
    var $tailcall = separator2 => list25 => current => parts => 
        $match(list25, [
            Empty, () => 
                list_reverse([Cons, list_reverse(current), parts]),
            [Cons, $, $], (c10, rest11) => 
                $match(x4(separator2)(c10), [
                    True, () => 
                        ({$k:() => $tailcall (separator2)(rest11)(Empty)([Cons, list_reverse(current), parts])}),
                    False, () => 
                        ({$k:() => $tailcall (separator2)(rest11)([Cons, c10, current])(parts)})])]);
    return $trampoline($tailcall(separator2)(list25)(current)(parts));
};

var string_split = separator3 => string19 => 
    list_map(string_from_list)(string_split2(separator3)(string_to_list(string19))(Empty)(Empty));
module.exports.string_split = (separator3,string19) => string_split(separator3)(string19);

var string_trim_start2 = list26 => {
    var $tailcall = list26 => 
        $match(list26, [
            [Cons, $, $], (x97, xs18) => 
                $match(x4(x97)(32), [
                    True, () => 
                        ({$k:() => $tailcall (xs18)}),
                    False, () => 
                        list26]),
            Empty, () => 
                list26]);
    return $trampoline($tailcall(list26));
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

var string_equal = a38 => b36 => {
    var $tailcall = a38 => b36 => 
        $match(string_first(a38), [
            [Some, $], (xa) => 
                $match(string_first(b36), [
                    [Some, $], (xb) => 
                        $match(x4(xa)(xb), [
                            True, () => 
                                ({$k:() => $tailcall (string_rest(a38))(string_rest(b36))}),
                            False, () => 
                                False]),
                    None, () => 
                        string_is_empty(a38)]),
            None, () => 
                string_is_empty(b36)]);
    return $trampoline($tailcall(a38)(b36));
};
module.exports.string_equal = (a38,b36) => string_equal(a38)(b36);

var string_index_of2 = index3 => substring => substring_size => string23 => string_size2 => {
    var $tailcall = index3 => substring => substring_size => string23 => string_size2 => 
        $match(x6(index3)(string_size2), [
            True, () => 
                None,
            False, () => 
                $match(string_equal(substring)(string_substring(index3)(substring_size)(string23)), [
                    True, () => 
                        [Some, index3],
                    False, () => 
                        ({$k:() => $tailcall (int32_add(index3)(1))(substring)(substring_size)(string23)(string_size2)})])]);
    return $trampoline($tailcall(index3)(substring)(substring_size)(string23)(string_size2));
};

var string_index_of = index4 => substring2 => string24 => 
    string_index_of2(index4)(substring2)(string_size(substring2))(string24)(string_size(string24));
module.exports.string_index_of = (index4,substring2,string24) => string_index_of(index4)(substring2)(string24);

var string_point_is_digit = point => 
    $match(x3(point)(47), [
        False, () => 
            False,
        True, () => 
            $match(x2(point)(58), [
                True, () => 
                    True,
                False, () => 
                    False])]);
module.exports.string_point_is_digit = (point) => string_point_is_digit(point);

var string_to_int322 = string_to_int323 => string25 => accumulator => x98 => 
    string_to_int323(string25)([Some, int32_add(int32_mul(10)(accumulator))(int32_sub(x98)(48))]);

var string_to_int324 = string26 => accumulator2 => 
    $match(string26, [
        Empty, () => 
            accumulator2,
        [Cons, $, $], (x99, rest12) => 
            maybe_flatmap((accumulator3 => $pipe([Some, x99],maybe_filter(string_point_is_digit),maybe_flatmap(string_to_int322(string_to_int324)(rest12)(accumulator3)))))(accumulator2)]);

var string_to_int325 = string27 => 
    $match(string27, [
        [Cons, 45, $], (string28) => 
            $match(list_is_empty(string28), [
                True, () => 
                    None,
                False, () => 
                    maybe_map((x100 => int32_mul(-1)(x100)))(string_to_int325(string28))]),
        [Cons, $, $], (x101, rest13) => 
            $match(string_point_is_digit(x101), [
                True, () => 
                    string_to_int324(string27)([Some, 0]),
                False, () => 
                    None]),
        Empty, () => 
            None]);

var string_to_int32 = string29 => 
    string_to_int325(string_to_list(string29));
module.exports.string_to_int32 = (string29) => string_to_int32(string29);

var string_from_int322 = integer => string30 => {
    var $tailcall = integer => string30 => 
        $match(x3(integer)(9), [
            True, () => 
                ({$k:() => $tailcall (int32_div(integer)(10))([Cons, int32_add(int32_mod(integer)(10))(48), string30])}),
            False, () => 
                [Cons, int32_add(integer)(48), string30]]);
    return $trampoline($tailcall(integer)(string30));
};

var string_from_int323 = integer2 => 
    $match(x2(integer2)(0), [
        True, () => 
            $match(x4(integer2)(-2147483648), [
                True, () => 
                    [Cons,45,[Cons,50,[Cons,49,[Cons,52,[Cons,55,[Cons,52,[Cons,56,[Cons,51,[Cons,54,[Cons,52,[Cons,56,Empty]]]]]]]]]]],
                False, () => 
                    [Cons, 45, string_from_int323(int32_mul(integer2)(-1))]]),
        False, () => 
            string_from_int322(integer2)(Empty)]);

var string_from_int32 = integer3 => 
    string_from_list(string_from_int323(integer3));
module.exports.string_from_int32 = (integer3) => string_from_int32(integer3);

var string_collect_from_slice2 = predicate6 => index5 => slice => initial6 => {
    var $tailcall = predicate6 => index5 => slice => initial6 => 
        $match(x2(index5)(slice_size(slice)), [
            False, () => 
                [Pair, index5, initial6],
            True, () => 
                $match(predicate6(slice_get(slice)(index5)), [
                    True, () => 
                        ({$k:() => $tailcall (predicate6)(int32_add(index5)(1))(slice)(string_append(slice_get(slice)(index5))(initial6))}),
                    False, () => 
                        [Pair, index5, initial6]])]);
    return $trampoline($tailcall(predicate6)(index5)(slice)(initial6));
};

var string_collect_from_slice = predicate7 => index6 => slice2 => 
    string_collect_from_slice2(predicate7)(index6)(slice2)(string_empty());
module.exports.string_collect_from_slice = (predicate7,index6,slice2) => string_collect_from_slice(predicate7)(index6)(slice2);

var string_to_slice = string31 => 
    string_foldl((c11 => slice3 => slice_concat(slice3)(slice_of_u8(c11)(1))))(slice_empty())(string31);
module.exports.string_to_slice = (string31) => string_to_slice(string31);

var string_from_slice = slice4 => 
    slice_foldl(string_append)(string_empty())(slice4);
module.exports.string_from_slice = (slice4) => string_from_slice(slice4);

var string_collect_from_indexed_iterator2 = predicate8 => iterator6 => initial7 => {
    var $tailcall = predicate8 => iterator6 => initial7 => 
        $match(indexed_iterator_next(iterator6), [
            [Pair, None, $], (x102) => 
                [Pair, iterator6, initial7],
            [Pair, [Some, $], $], (x103, next3) => 
                $match(predicate8(x103), [
                    True, () => 
                        ({$k:() => $tailcall (predicate8)(next3)(string_append(x103)(initial7))}),
                    False, () => 
                        [Pair, iterator6, initial7]])]);
    return $trampoline($tailcall(predicate8)(iterator6)(initial7));
};

var string_collect_from_indexed_iterator = predicate9 => iterator7 => 
    string_collect_from_indexed_iterator2(predicate9)(iterator7)(string_empty());
module.exports.string_collect_from_indexed_iterator = (predicate9,iterator7) => string_collect_from_indexed_iterator(predicate9)(iterator7);

var string_from_indexed_iterator = iterator8 => 
    pair_right(string_collect_from_indexed_iterator((x104 => True))(iterator8));
module.exports.string_from_indexed_iterator = (iterator8) => string_from_indexed_iterator(iterator8);

var string_iterable = () => 
    [IterableClass, (string32 => [Pair, string_first(string32), string_rest(string32)])];
module.exports.string_iterable = () => string_iterable();

var string_from_boolean = boolean2 => 
    $match(boolean2, [
        True, () => 
            string_from_list([Cons,84,[Cons,114,[Cons,117,[Cons,101,Empty]]]]),
        False, () => 
            string_from_list([Cons,70,[Cons,97,[Cons,108,[Cons,115,[Cons,101,Empty]]]]])]);
module.exports.string_from_boolean = (boolean2) => string_from_boolean(boolean2);

var valid_string_from_unicode_code_point = point2 => 
    $match(x3(point2)(65535), [
        True, () => 
            string_from_list([Cons,int32_add(240)(int32_div(int32_and(point2)(1835008))(262144)),[Cons,int32_add(128)(int32_div(int32_and(point2)(258048))(4096)),[Cons,int32_add(128)(int32_div(int32_and(point2)(4032))(64)),[Cons,int32_add(128)(int32_and(point2)(63)),Empty]]]]),
        False, () => 
            $match(x3(point2)(2047), [
                True, () => 
                    string_from_list([Cons,int32_add(224)(int32_div(int32_and(point2)(61440))(4096)),[Cons,int32_add(128)(int32_div(int32_and(point2)(4032))(64)),[Cons,int32_add(128)(int32_and(point2)(63)),Empty]]]),
                False, () => 
                    $match(x3(point2)(127), [
                        True, () => 
                            string_from_list([Cons,int32_add(192)(int32_div(int32_and(point2)(1984))(64)),[Cons,int32_add(128)(int32_and(point2)(63)),Empty]]),
                        False, () => 
                            string_of_char(point2)])])]);

var invalid_code_point = () => 
    string_from_list([Cons,255,[Cons,253,Empty]]);

var string_from_unicode_code_point = point3 => 
    $match(x3(point3)(1114111), [
        True, () => 
            invalid_code_point(),
        False, () => 
            $match(x3(point3)(55295), [
                True, () => 
                    $match(x2(point3)(57344), [
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
    $match(result4, [
        [Result, $], (m) => 
            m,
        [Error, $], (error2) => 
            return2([Error, error2])]);
module.exports.result_prod = (return2,result4) => result_prod(return2)(result4);

var result_bimap = f31 => g3 => result5 => 
    $match(result5, [
        [Result, $], (x105) => 
            [Result, f31(x105)],
        [Error, $], (y8) => 
            [Error, g3(y8)]]);
module.exports.result_bimap = (f31,g3,result5) => result_bimap(f31)(g3)(result5);

var result_either = f32 => g4 => result6 => 
    $match(result6, [
        [Result, $], (x106) => 
            f32(x106),
        [Error, $], (x107) => 
            g4(x107)]);
module.exports.result_either = (f32,g4,result6) => result_either(f32)(g4)(result6);

var result_map = f33 => result7 => 
    result_bimap(f33)(id)(result7);
module.exports.result_map = (f33,result7) => result_map(f33)(result7);

var result_flatmap = f34 => result8 => 
    $match(result8, [
        [Result, $], (x108) => 
            f34(x108),
        [Error, $], (error3) => 
            [Error, error3]]);
module.exports.result_flatmap = (f34,result8) => result_flatmap(f34)(result8);

var result_or_else = value6 => result9 => 
    $match(result9, [
        [Result, $], (x109) => 
            x109,
        [Error, $], (x110) => 
            value6]);
module.exports.result_or_else = (value6,result9) => result_or_else(value6)(result9);

var result_error2 = result10 => 
    $match(result10, [
        [Error, $], (x111) => 
            True,
        $, (x112) => 
            False]);
module.exports.result_error2 = (result10) => result_error2(result10);

var result_filter_list = list27 => 
    list_foldr((result11 => new_list => $match(result11, [
        [Result, $], (x113) => 
            [Cons, x113, new_list],
        $, (x114) => 
            new_list])))(Empty)(list27);
module.exports.result_filter_list = (list27) => result_filter_list(list27);

var result_partition = list28 => 
    list_foldr((result12 => state2 => $match(result12, [
        [Result, $], (x115) => 
            [Pair, [Cons, x115, pair_left(state2)], pair_right(state2)],
        [Error, $], (e3) => 
            [Pair, pair_left(state2), [Cons, e3, pair_right(state2)]]])))([Pair, Empty, Empty])(list28);
module.exports.result_partition = (list28) => result_partition(list28);

var result_concat = list29 => 
    $match(list_filter(result_error2)(list29), [
        [Cons, [Error, $], $], (error4, x116) => 
            [Error, error4],
        [Cons, [Result, $], $], (x117, x118) => 
            [Result, Empty],
        Empty, () => 
            [Result, result_filter_list(list29)]]);
module.exports.result_concat = (list29) => result_concat(list29);

var result_of_maybe = error5 => maybe10 => 
    $match(maybe10, [
        [Some, $], (x119) => 
            [Result, x119],
        None, () => 
            [Error, error5]]);
module.exports.result_of_maybe = (error5,maybe10) => result_of_maybe(error5)(maybe10);

var result_bind = result13 => f35 => 
    result_flatmap(f35)(result13);
module.exports.result_bind = (result13,f35) => result_bind(result13)(f35);

var result_return = value7 => 
    result_lift(value7);
module.exports.result_return = (value7) => result_return(value7);

var TrampolineDone = { TrampolineDone: true };
module.exports.TrampolineDone = TrampolineDone;
var TrampolineMore = { TrampolineMore: true };
module.exports.TrampolineMore = TrampolineMore;
var TrampolineFlatmap = { TrampolineFlatmap: true };
module.exports.TrampolineFlatmap = TrampolineFlatmap;

var trampoline_return = value8 => 
    [TrampolineDone, value8];
module.exports.trampoline_return = (value8) => trampoline_return(value8);

var trampoline_yield = k => 
    [TrampolineMore, k];
module.exports.trampoline_yield = (k) => trampoline_yield(k);

var trampoline_bind = trampoline2 => f36 => 
    $match(trampoline2, [
        [TrampolineFlatmap, $, $], (a39, g5) => 
            [TrampolineFlatmap, a39, (x120 => trampoline_bind(g5(x120))(f36))],
        $, (x121) => 
            [TrampolineFlatmap, x121, f36]]);
module.exports.trampoline_bind = (trampoline2,f36) => trampoline_bind(trampoline2)(f36);

var trampoline_map = trampoline3 => f37 => 
    trampoline_bind(trampoline3)((a40 => [TrampolineDone, f37(a40)]));
module.exports.trampoline_map = (trampoline3,f37) => trampoline_map(trampoline3)(f37);

var resume = trampoline4 => {
    var $tailcall = trampoline4 => 
        $match(trampoline4, [
            [TrampolineDone, $], (v) => 
                [Result, v],
            [TrampolineMore, $], (k2) => 
                [Error, k2],
            [TrampolineFlatmap, $, $], (a41, f38) => 
                $match(a41, [
                    [TrampolineDone, $], (v2) => 
                        ({$k:() => $tailcall (f38(v2))}),
                    [TrampolineMore, $], (k3) => 
                        [Error, (() => trampoline_bind(k3())(f38))],
                    [TrampolineFlatmap, $, $], (b37, g6) => 
                        ({$k:() => $tailcall (trampoline_bind(b37)((x122 => trampoline_bind(g6(x122))(f38))))})])]);
    return $trampoline($tailcall(trampoline4));
};

var trampoline_run = trampoline5 => {
    var $tailcall = trampoline5 => 
        $match(resume(trampoline5), [
            [Result, $], (a42) => 
                a42,
            [Error, $], (k4) => 
                ({$k:() => $tailcall (k4())})]);
    return $trampoline($tailcall(trampoline5));
};
module.exports.trampoline_run = (trampoline5) => trampoline_run(trampoline5);

var Operation = { Operation: true };
module.exports.Operation = Operation;

var state_run_internal = state3 => operation => 
    $match(operation, [
        [Operation, $], (f39) => 
            f39(state3)]);

var state_run = state4 => operation2 => 
    trampoline_run(state_run_internal(state4)(operation2));
module.exports.state_run = (state4,operation2) => state_run(state4)(operation2);

var state_final_value = initial_state => operation3 => 
    $match(trampoline_run(state_run_internal(initial_state)(operation3)), [
        [Pair, $, $], (x123, value9) => 
            value9]);
module.exports.state_final_value = (initial_state,operation3) => state_final_value(initial_state)(operation3);

var state_return = value10 => 
    [Operation, (state5 => trampoline_return([Pair, state5, value10]))];
module.exports.state_return = (value10) => state_return(value10);

var state_bind = operation4 => f40 => 
    [Operation, (state6 => trampoline_yield((() => trampoline_bind(state_run_internal(state6)(operation4))((v3 => $match(v3, [
        [Pair, $, $], (state7, value11) => 
            trampoline_yield((() => state_run_internal(state7)(f40(value11))))]))))))];
module.exports.state_bind = (operation4,f40) => state_bind(operation4)(f40);

var state_get = () => 
    [Operation, (state8 => trampoline_return([Pair, state8, state8]))];
module.exports.state_get = () => state_get();

var state_set = state9 => 
    [Operation, (x124 => trampoline_return([Pair, state9, state9]))];
module.exports.state_set = (state9) => state_set(state9);

var state_modify = f41 => 
    state_bind(state_get())((state10 => state_set(f41(state10))));
module.exports.state_modify = (f41) => state_modify(f41);

var state_let = value12 => f42 => 
    state_bind(state_return(value12))(f42);
module.exports.state_let = (value12,f42) => state_let(value12)(f42);

var state_foldr = f43 => initial_value => operations => 
    list_foldr((operation5 => chain => state_bind(operation5)((x125 => state_bind(chain)((xs19 => state_return(f43(x125)(xs19))))))))(state_return(initial_value))(operations);
module.exports.state_foldr = (f43,initial_value,operations) => state_foldr(f43)(initial_value)(operations);

var state_foreach = f44 => xs20 => 
    state_foldr(list_cons)(Empty)(list_map(f44)(xs20));
module.exports.state_foreach = (f44,xs20) => state_foreach(f44)(xs20);

var state_flatmap = f45 => operation6 => 
    state_bind(operation6)(f45);
module.exports.state_flatmap = (f45,operation6) => state_flatmap(f45)(operation6);

var state_map = f46 => operation7 => 
    state_flatmap($compose(state_return,f46))(operation7);
module.exports.state_map = (f46,operation7) => state_map(f46)(operation7);

var state_lift = value13 => 
    state_return(value13);
module.exports.state_lift = (value13) => state_lift(value13);

var ArrayRed = { ArrayRed: true };
var ArrayBlack = { ArrayBlack: true };

var ArrayEmpty = { ArrayEmpty: true };
module.exports.ArrayEmpty = ArrayEmpty;
var ArrayTree = { ArrayTree: true };
module.exports.ArrayTree = ArrayTree;

var array_empty = () => 
    ArrayEmpty;
module.exports.array_empty = () => array_empty();

var array_make_black = array => 
    $match(array, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, $, $, $], (x126, a43, y9, b38) => 
            [ArrayTree, ArrayBlack, a43, y9, b38]]);

var array_balance = array2 => 
    $match(array2, [
        [ArrayTree, ArrayBlack, [ArrayTree, ArrayRed, [ArrayTree, ArrayRed, $, $, $], $, $], $, $], (a44, x127, b39, y10, c12, z, d4) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a44, x127, b39], y10, [ArrayTree, ArrayBlack, c12, z, d4]],
        [ArrayTree, ArrayBlack, [ArrayTree, ArrayRed, $, $, [ArrayTree, ArrayRed, $, $, $]], $, $], (a45, x128, b40, y11, c13, z2, d5) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a45, x128, b40], y11, [ArrayTree, ArrayBlack, c13, z2, d5]],
        [ArrayTree, ArrayBlack, $, $, [ArrayTree, ArrayRed, [ArrayTree, ArrayRed, $, $, $], $, $]], (a46, x129, b41, y12, c14, z3, d6) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a46, x129, b41], y12, [ArrayTree, ArrayBlack, c14, z3, d6]],
        [ArrayTree, ArrayBlack, $, $, [ArrayTree, ArrayRed, $, $, [ArrayTree, ArrayRed, $, $, $]]], (a47, x130, b42, y13, c15, z4, d7) => 
            [ArrayTree, ArrayRed, [ArrayTree, ArrayBlack, a47, x130, b42], y13, [ArrayTree, ArrayBlack, c15, z4, d7]],
        $, (rest14) => 
            rest14]);

var array_set2 = x131 => value14 => array3 => 
    $match(array3, [
        ArrayEmpty, () => 
            [ArrayTree, ArrayRed, ArrayEmpty, [Pair, x131, value14], ArrayEmpty],
        [ArrayTree, $, $, $, $], (color, a48, y14, b43) => 
            $match(x2(x131)(pair_left(y14)), [
                True, () => 
                    array_balance([ArrayTree, color, array_set2(x131)(value14)(a48), y14, b43]),
                False, () => 
                    $match(x3(x131)(pair_left(y14)), [
                        True, () => 
                            array_balance([ArrayTree, color, a48, y14, array_set2(x131)(value14)(b43)]),
                        False, () => 
                            [ArrayTree, color, a48, [Pair, x131, value14], b43]])])]);

var array_set = x132 => value15 => array4 => 
    array_make_black(array_set2(x132)(value15)(array4));
module.exports.array_set = (x132,value15,array4) => array_set(x132)(value15)(array4);

var array_get = x133 => array5 => {
    var $tailcall = x133 => array5 => 
        $match(array5, [
            ArrayEmpty, () => 
                None,
            [ArrayTree, $, $, [Pair, $, $], $], (x134, a49, y15, value16, b44) => 
                $match(x2(x133)(y15), [
                    True, () => 
                        ({$k:() => $tailcall (x133)(a49)}),
                    False, () => 
                        $match(x3(x133)(y15), [
                            True, () => 
                                ({$k:() => $tailcall (x133)(b44)}),
                            False, () => 
                                [Some, value16]])])]);
    return $trampoline($tailcall(x133)(array5));
};
module.exports.array_get = (x133,array5) => array_get(x133)(array5);

var array_min = array6 => default2 => {
    var $tailcall = array6 => default2 => 
        $match(array6, [
            ArrayEmpty, () => 
                default2,
            [ArrayTree, $, ArrayEmpty, $, $], (x135, y16, x136) => 
                y16,
            [ArrayTree, $, $, $, $], (x137, a50, x138, x139) => 
                ({$k:() => $tailcall (a50)(default2)})]);
    return $trampoline($tailcall(array6)(default2));
};

var array_remove_min = array7 => 
    $match(array7, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, ArrayEmpty, $, $], (x140, y17, b45) => 
            b45,
        [ArrayTree, $, $, $, $], (color2, a51, y18, b46) => 
            array_balance([ArrayTree, color2, array_remove_min(a51), y18, b46])]);

var array_remove_root = array8 => 
    $match(array8, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, ArrayEmpty, $, ArrayEmpty], (x141, y19) => 
            ArrayEmpty,
        [ArrayTree, $, $, $, ArrayEmpty], (x142, a52, y20) => 
            a52,
        [ArrayTree, $, ArrayEmpty, $, $], (x143, y21, b47) => 
            b47,
        [ArrayTree, $, $, $, $], (color3, a53, y22, b48) => 
            array_balance([ArrayTree, color3, a53, array_min(b48)(y22), array_remove_min(b48)])]);

var array_remove2 = x144 => array9 => 
    $match(array9, [
        ArrayEmpty, () => 
            ArrayEmpty,
        [ArrayTree, $, $, $, $], (color4, a54, y23, b49) => 
            $match(x2(x144)(pair_left(y23)), [
                True, () => 
                    array_balance([ArrayTree, color4, array_remove2(x144)(a54), y23, b49]),
                False, () => 
                    $match(x3(x144)(pair_left(y23)), [
                        True, () => 
                            array_balance([ArrayTree, color4, a54, y23, array_remove2(x144)(b49)]),
                        False, () => 
                            array_remove_root(array9)])])]);

var array_remove = x145 => array10 => 
    array_make_black(array_remove2(x145)(array10));
module.exports.array_remove = (x145,array10) => array_remove(x145)(array10);

var array_entries = array11 => 
    $match(array11, [
        ArrayEmpty, () => 
            Empty,
        [ArrayTree, $, $, $, $], (x146, a55, entry, b50) => 
            list_flatten([Cons,array_entries(a55),[Cons,[Cons,entry,Empty],[Cons,array_entries(b50),Empty]]])]);
module.exports.array_entries = (array11) => array_entries(array11);

var array_values = array12 => 
    list_map(pair_right)(array_entries(array12));
module.exports.array_values = (array12) => array_values(array12);

var array_from_list2 = entries => index7 => array13 => {
    var $tailcall = entries => index7 => array13 => 
        $match(entries, [
            [Cons, $, $], (x147, xs21) => 
                ({$k:() => $tailcall (xs21)(int32_add(index7)(1))(array_set(index7)(x147)(array13))}),
            Empty, () => 
                array13]);
    return $trampoline($tailcall(entries)(index7)(array13));
};

var array_from_list = entries2 => 
    array_from_list2(entries2)(0)(ArrayEmpty);
module.exports.array_from_list = (entries2) => array_from_list(entries2);

var array_of = entries3 => 
    list_foldl((entry2 => array14 => $match(entry2, [
        [Pair, $, $], (key, value17) => 
            array_set(key)(value17)(array14)])))(ArrayEmpty)(entries3);
module.exports.array_of = (entries3) => array_of(entries3);

var array_singleton = index8 => value18 => 
    [ArrayTree, ArrayBlack, ArrayEmpty, [Pair, index8, value18], ArrayEmpty];
module.exports.array_singleton = (index8,value18) => array_singleton(index8)(value18);

var array_get_or = index9 => default3 => array15 => 
    $match(array_get(index9)(array15), [
        [Some, $], (value19) => 
            value19,
        None, () => 
            default3]);
module.exports.array_get_or = (index9,default3,array15) => array_get_or(index9)(default3)(array15);

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

var dictionary_set = key3 => new_value2 => dictionary2 => 
    $match(dictionary2, [
        [Dictionary, $], (array17) => 
            $match(dictionary_bucket_from_key(key3), [
                $, (bucket_id) => 
                    $match(array_get(bucket_id)(array17), [
                        [Some, $], (bucket) => 
                            $match(list_filter((entry3 => not(string_equal(pair_left(entry3))(key3))))(bucket), [
                                $, (new_bucket) => 
                                    [Dictionary, array_set(bucket_id)([Cons, [Pair, key3, new_value2], new_bucket])(array17)]]),
                        None, () => 
                            [Dictionary, array_set(bucket_id)([Cons,[Pair, key3, new_value2],Empty])(array17)]])])]);
module.exports.dictionary_set = (key3,new_value2,dictionary2) => dictionary_set(key3)(new_value2)(dictionary2);

var dictionary_get = key4 => dictionary3 => 
    $match(dictionary3, [
        [Dictionary, $], (array18) => 
            $match(dictionary_bucket_from_key(key4), [
                $, (bucket_id2) => 
                    $match(array_get(bucket_id2)(array18), [
                        [Some, $], (bucket2) => 
                            maybe_map(pair_right)(list_find_first((entry4 => string_equal(pair_left(entry4))(key4)))(bucket2)),
                        None, () => 
                            None])])]);
module.exports.dictionary_get = (key4,dictionary3) => dictionary_get(key4)(dictionary3);

var dictionary_remove = key5 => dictionary4 => 
    $match(dictionary4, [
        [Dictionary, $], (array19) => 
            $match(dictionary_bucket_from_key(key5), [
                $, (bucket_id3) => 
                    $match(array_get(bucket_id3)(array19), [
                        [Some, $], (bucket3) => 
                            $match(list_filter((entry5 => not(string_equal(pair_left(entry5))(key5))))(bucket3), [
                                $, (new_bucket2) => 
                                    [Dictionary, array_set(bucket_id3)(new_bucket2)(array19)]]),
                        None, () => 
                            dictionary4])])]);
module.exports.dictionary_remove = (key5,dictionary4) => dictionary_remove(key5)(dictionary4);

var dictionary_entries = dictionary5 => 
    $match(dictionary5, [
        [Dictionary, $], (array20) => 
            list_flatten(list_map(pair_right)(array_entries(array20)))]);
module.exports.dictionary_entries = (dictionary5) => dictionary_entries(dictionary5);

var dictionary_of = entries4 => 
    list_foldl(pair_map(dictionary_set))(dictionary_empty())(entries4);
module.exports.dictionary_of = (entries4) => dictionary_of(entries4);

var dictionary_singleton = key6 => value20 => 
    dictionary_set(key6)(value20)(dictionary_empty());
module.exports.dictionary_singleton = (key6,value20) => dictionary_singleton(key6)(value20);

var dictionary_get_or = key7 => default4 => dictionary6 => 
    $match(dictionary_get(key7)(dictionary6), [
        [Some, $], (value21) => 
            value21,
        None, () => 
            default4]);
module.exports.dictionary_get_or = (key7,default4,dictionary6) => dictionary_get_or(key7)(default4)(dictionary6);

var dictionary_size = dictionary7 => 
    list_size(dictionary_entries(dictionary7));
module.exports.dictionary_size = (dictionary7) => dictionary_size(dictionary7);

var dictionary_has = key8 => dictionary8 => 
    $match(dictionary_get(key8)(dictionary8), [
        [Some, $], (x148) => 
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

var dictionary_merge = a56 => b51 => 
    list_foldl(pair_map(dictionary_set))(a56)(dictionary_entries(b51));
module.exports.dictionary_merge = (a56,b51) => dictionary_merge(a56)(b51);

var Bigint = { Bigint: true };

var bigint_trim_parts_reversed = parts2 => {
    var $tailcall = parts2 => 
        $match(parts2, [
            [Cons, $, Empty], (x149) => 
                parts2,
            [Cons, $, $], (x150, xs22) => 
                $match(x4(x150)(0), [
                    True, () => 
                        ({$k:() => $tailcall (xs22)}),
                    False, () => 
                        parts2]),
            Empty, () => 
                Empty]);
    return $trampoline($tailcall(parts2));
};

var bigint_trim_parts = parts3 => 
    list_reverse(bigint_trim_parts_reversed(list_reverse(parts3)));

var bigint_from_string = string33 => 
    $match(string_first(string33), [
        [Some, 45], () => 
            [Bigint, True, bigint_trim_parts(list_reverse(list_map(flip(int32_sub)(48))(string_to_list(string_rest(string33)))))],
        $, (x151) => 
            [Bigint, False, bigint_trim_parts(list_reverse(list_map(flip(int32_sub)(48))(string_to_list(string33))))]]);
module.exports.bigint_from_string = (string33) => bigint_from_string(string33);

var bigint_from = int => 
    bigint_from_string(string_from_int32(int));
module.exports.bigint_from = (int) => bigint_from(int);

var bigint_zero = () => 
    [Bigint, False, [Cons,0,Empty]];
module.exports.bigint_zero = () => bigint_zero();

var bigint_one = () => 
    [Bigint, False, [Cons,1,Empty]];
module.exports.bigint_one = () => bigint_one();

var bigint_negate = int2 => 
    $match(int2, [
        [Bigint, $, [Cons, 0, Empty]], (negative) => 
            int2,
        [Bigint, $, $], (negative2, parts4) => 
            [Bigint, $match(negative2, [
                True, () => 
                    False,
                False, () => 
                    True]), parts4]]);
module.exports.bigint_negate = (int2) => bigint_negate(int2);

var stringify_parts = parts5 => 
    string_join(string_empty())(list_reverse(list_map(string_from_int32)(parts5)));

var bigint_to_string = int3 => 
    $match(int3, [
        [Bigint, True, $], (parts6) => 
            string_prepend(45)(stringify_parts(parts6)),
        [Bigint, False, $], (parts7) => 
            stringify_parts(parts7)]);
module.exports.bigint_to_string = (int3) => bigint_to_string(int3);

var less_than_with_carry = x152 => y24 => previous_less_than => 
    $match(x2(x152)(y24), [
        True, () => 
            True,
        False, () => 
            $match(x4(x152)(y24), [
                True, () => 
                    previous_less_than,
                False, () => 
                    False])]);

var bigint_less_than_parts = a57 => b52 => previous_less_than2 => {
    var $tailcall = a57 => b52 => previous_less_than2 => 
        $match([Pair, a57, b52], [
            [Pair, Empty, Empty], () => 
                False,
            [Pair, [Cons, $, $], Empty], (x153, x154) => 
                False,
            [Pair, Empty, [Cons, $, $]], (x155, x156) => 
                True,
            [Pair, [Cons, $, Empty], [Cons, $, Empty]], (x157, y25) => 
                less_than_with_carry(x157)(y25)(previous_less_than2),
            [Pair, [Cons, $, $], [Cons, $, $]], (x158, xs23, y26, ys4) => 
                ({$k:() => $tailcall (xs23)(ys4)(less_than_with_carry(x158)(y26)(previous_less_than2))})]);
    return $trampoline($tailcall(a57)(b52)(previous_less_than2));
};

var bigint_less_than = a58 => b53 => 
    $match([Pair, a58, b53], [
        [Pair, [Bigint, True, $], [Bigint, False, $]], (x159, x160) => 
            True,
        [Pair, [Bigint, False, $], [Bigint, True, $]], (x161, x162) => 
            False,
        [Pair, [Bigint, True, $], [Bigint, True, $]], (a_parts, b_parts) => 
            bigint_less_than_parts(b_parts)(a_parts)(False),
        [Pair, [Bigint, $, $], [Bigint, $, $]], (x163, a_parts2, x164, b_parts2) => 
            bigint_less_than_parts(a_parts2)(b_parts2)(False)]);
module.exports.bigint_less_than = (a58,b53) => bigint_less_than(a58)(b53);

var bigint_subtract_parts = a59 => b54 => carry => {
    var $tailcall = a59 => b54 => carry => 
        $match([Pair, a59, b54], [
            [Pair, [Cons, $, $], Empty], (x165, xs24) => 
                ({$k:() => $tailcall (a59)([Cons, 0, Empty])(carry)}),
            [Pair, [Cons, $, $], [Cons, $, $]], (x166, xs25, y27, ys5) => 
                $match(x2(int32_sub(x166)(int32_add(y27)(carry)))(0), [
                    True, () => 
                        [Cons, int32_sub(int32_add(x166)(10))(int32_add(y27)(carry)), bigint_subtract_parts(xs25)(ys5)(1)],
                    False, () => 
                        [Cons, int32_sub(x166)(int32_add(y27)(carry)), bigint_subtract_parts(xs25)(ys5)(0)]]),
            $, (x167) => 
                Empty]);
    return $trampoline($tailcall(a59)(b54)(carry));
};

var bigint_add_parts = a60 => b55 => carry2 => {
    var $tailcall = a60 => b55 => carry2 => 
        $match([Pair, a60, b55], [
            [Pair, [Cons, $, $], [Cons, $, $]], (x168, xs26, y28, ys6) => 
                $match(x3(int32_add(x168)(int32_add(y28)(carry2)))(9), [
                    True, () => 
                        [Cons, int32_sub(int32_add(x168)(int32_add(y28)(carry2)))(10), bigint_add_parts(xs26)(ys6)(1)],
                    False, () => 
                        [Cons, int32_add(x168)(int32_add(y28)(carry2)), bigint_add_parts(xs26)(ys6)(0)]]),
            [Pair, [Cons, $, $], Empty], (x169, x170) => 
                ({$k:() => $tailcall (a60)([Cons, 0, Empty])(carry2)}),
            [Pair, Empty, [Cons, $, $]], (x171, x172) => 
                ({$k:() => $tailcall ([Cons, 0, Empty])(b55)(carry2)}),
            [Pair, Empty, Empty], () => 
                $match(x3(carry2)(0), [
                    True, () => 
                        [Cons, carry2, Empty],
                    False, () => 
                        Empty])]);
    return $trampoline($tailcall(a60)(b55)(carry2));
};

var bigint_add_zeroes = n6 => digits => {
    var $tailcall = n6 => digits => 
        $match(n6, [
            0, () => 
                digits,
            $, (x173) => 
                ({$k:() => $tailcall (int32_sub(n6)(1))([Cons, 0, digits])})]);
    return $trampoline($tailcall(n6)(digits));
};

var bigint_multiply_digit = x174 => digits2 => carry3 => 
    $match(digits2, [
        Empty, () => 
            $match(x3(carry3)(0), [
                True, () => 
                    [Cons, carry3, Empty],
                False, () => 
                    Empty]),
        [Cons, $, $], (y29, ys7) => 
            [Cons, int32_mod(int32_add(int32_mul(x174)(y29))(carry3))(10), bigint_multiply_digit(x174)(ys7)(int32_div(int32_add(int32_mul(x174)(y29))(carry3))(10))]]);

var bigint_multiply_parts = a61 => b56 => base => 
    $match(a61, [
        [Cons, $, $], (x175, xs27) => 
            bigint_add_parts(bigint_add_zeroes(base)(bigint_multiply_digit(x175)(b56)(0)))(bigint_multiply_parts(xs27)(b56)(int32_add(base)(1)))(0),
        Empty, () => 
            Empty]);

var bigint_subtract = a62 => b57 => 
    $match([Pair, a62, b57], [
        [Pair, [Bigint, False, $], [Bigint, True, $]], (a_parts3, b_parts3) => 
            [Bigint, False, bigint_add_parts(a_parts3)(b_parts3)(0)],
        [Pair, [Bigint, True, $], [Bigint, False, $]], (a_parts4, b_parts4) => 
            [Bigint, True, bigint_add_parts(a_parts4)(b_parts4)(0)],
        [Pair, [Bigint, True, $], [Bigint, True, $]], (a_parts5, b_parts5) => 
            $match(bigint_less_than(a62)(b57), [
                True, () => 
                    [Bigint, True, bigint_trim_parts(bigint_subtract_parts(a_parts5)(b_parts5)(0))],
                False, () => 
                    [Bigint, False, bigint_trim_parts(bigint_subtract_parts(b_parts5)(a_parts5)(0))]]),
        [Pair, [Bigint, False, $], [Bigint, False, $]], (a_parts6, b_parts6) => 
            $match(bigint_less_than(a62)(b57), [
                True, () => 
                    [Bigint, True, bigint_trim_parts(bigint_subtract_parts(b_parts6)(a_parts6)(0))],
                False, () => 
                    [Bigint, False, bigint_trim_parts(bigint_subtract_parts(a_parts6)(b_parts6)(0))]])]);
module.exports.bigint_subtract = (a62,b57) => bigint_subtract(a62)(b57);

var bigint_add = a63 => b58 => 
    $match([Pair, a63, b58], [
        [Pair, [Bigint, False, $], [Bigint, False, $]], (a_parts7, b_parts7) => 
            [Bigint, False, bigint_add_parts(a_parts7)(b_parts7)(0)],
        [Pair, [Bigint, True, $], [Bigint, True, $]], (a_parts8, b_parts8) => 
            [Bigint, True, bigint_add_parts(a_parts8)(b_parts8)(0)],
        [Pair, [Bigint, True, $], [Bigint, False, $]], (x176, x177) => 
            bigint_subtract(b58)(bigint_negate(a63)),
        [Pair, [Bigint, False, $], [Bigint, True, $]], (x178, x179) => 
            bigint_subtract(a63)(bigint_negate(b58))]);
module.exports.bigint_add = (a63,b58) => bigint_add(a63)(b58);

var bigint_multiply = a64 => b59 => 
    $match([Pair, a64, b59], [
        [Pair, [Bigint, $, [Cons, 0, Empty]], [Bigint, $, $]], (x180, x181, x182) => 
            [Bigint, False, [Cons, 0, Empty]],
        [Pair, [Bigint, $, $], [Bigint, $, [Cons, 0, Empty]]], (x183, x184, x185) => 
            [Bigint, False, [Cons, 0, Empty]],
        [Pair, [Bigint, True, $], [Bigint, False, $]], (a_parts9, b_parts9) => 
            [Bigint, True, bigint_multiply_parts(a_parts9)(b_parts9)(0)],
        [Pair, [Bigint, False, $], [Bigint, True, $]], (a_parts10, b_parts10) => 
            [Bigint, True, bigint_trim_parts(bigint_multiply_parts(a_parts10)(b_parts10)(0))],
        [Pair, [Bigint, $, $], [Bigint, $, $]], (x186, a_parts11, x187, b_parts11) => 
            [Bigint, False, bigint_trim_parts(bigint_multiply_parts(a_parts11)(b_parts11)(0))]]);
module.exports.bigint_multiply = (a64,b59) => bigint_multiply(a64)(b59);


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
    string_from_list([Cons,62,[Cons,32,Empty]]);

var data_context_prefix = () => 
    string_from_list([Cons,124,[Cons,32,Empty]]);

var data_assertion_prefix = () => 
    string_from_list([Cons,61,[Cons,32,Empty]]);

var data_expected = () => 
    string_from_list([Cons,101,[Cons,120,[Cons,112,[Cons,101,[Cons,99,[Cons,116,[Cons,101,[Cons,100,Empty]]]]]]]]);

var data_expression = () => 
    string_from_list([Cons,101,[Cons,120,[Cons,112,[Cons,114,[Cons,101,[Cons,115,[Cons,115,[Cons,105,[Cons,111,[Cons,110,Empty]]]]]]]]]]);

var ExpectSuccess = { ExpectSuccess: true };
module.exports.ExpectSuccess = ExpectSuccess;
var ExpectFailure = { ExpectFailure: true };
module.exports.ExpectFailure = ExpectFailure;
var Comment = { Comment: true };
module.exports.Comment = Comment;

var line_matches = first_char => line => 
    x4(first_char)(maybe_or_else(0)(string_first(line)));

var collect_lines = first_char2 => lines => 
    string_join(string_of_char(10))(list_map(string_skip(2))(list_filter(line_matches(first_char2))(lines)));

var collect_success = lines2 => 
    [ExpectSuccess, collect_lines(124)(lines2), collect_lines(47)(lines2), collect_lines(92)(lines2), collect_lines(62)(lines2), collect_lines(61)(lines2)];

var collect_failure = lines3 => 
    [ExpectFailure, collect_lines(124)(lines3), collect_lines(47)(lines3), collect_lines(92)(lines3), collect_lines(62)(lines3), collect_lines(63)(lines3)];

var commit_requirement = result14 => 
    $match(result14, [
        [Pair, $, $], (lines4, requirements) => 
            $match([Pair, list_is_empty(lines4), list_any(line_matches(63))(lines4)], [
                [Pair, False, True], () => 
                    [Pair, list_empty(), [Cons, collect_failure(list_reverse(lines4)), requirements]],
                [Pair, False, False], () => 
                    [Pair, list_empty(), [Cons, collect_success(list_reverse(lines4)), requirements]],
                [Pair, True, $], (x188) => 
                    result14])]);

var append_line = line2 => result15 => 
    $match(result15, [
        [Pair, $, $], (lines5, requirements2) => 
            [Pair, [Cons, line2, lines5], requirements2]]);

var previous_line_is_assertion = result16 => 
    $match(result16, [
        [Pair, [Cons, $, $], $], (line3, x189, x190) => 
            or(line_matches(63)(line3))(line_matches(61)(line3)),
        $, (x191) => 
            False]);

var commit_comment = line4 => result17 => 
    $match(previous_line_is_assertion(result17), [
        True, () => 
            $match(commit_requirement(result17), [
                [Pair, $, $], (lines6, requirements3) => 
                    [Pair, lines6, [Cons, [Comment, line4], requirements3]]]),
        False, () => 
            $match(result17, [
                [Pair, $, $], (lines7, requirements4) => 
                    [Pair, lines7, [Cons, [Comment, line4], requirements4]]])]);

var append_non_assertion = line5 => result18 => 
    $match(previous_line_is_assertion(result18), [
        True, () => 
            append_line(line5)(commit_requirement(result18)),
        False, () => 
            append_line(line5)(result18)]);

var reduce_spec = line6 => result19 => 
    $match(string_first(line6), [
        [Some, 61], () => 
            append_line(line6)(result19),
        [Some, 63], () => 
            append_line(line6)(result19),
        [Some, 62], () => 
            append_non_assertion(line6)(result19),
        [Some, 47], () => 
            append_non_assertion(line6)(result19),
        [Some, 92], () => 
            append_non_assertion(line6)(result19),
        [Some, 124], () => 
            append_non_assertion(line6)(result19),
        $, (x192) => 
            $match(string_is_empty(line6), [
                True, () => 
                    result19,
                False, () => 
                    commit_comment(line6)(result19)])]);

var parse_spec = file => 
    list_reverse(pair_right(commit_requirement(list_foldl(reduce_spec)([Pair, list_empty(), list_empty()])(string_split(10)(string_from_slice(file))))));
module.exports.parse_spec = (file) => parse_spec(file);
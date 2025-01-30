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
        }
    ]);
};
var array_foldl = f => ys => xs => $array_eval(xs).data.reduce((a, b) => f(a)(b), ys);
module.exports.array_foldl = array_foldl;
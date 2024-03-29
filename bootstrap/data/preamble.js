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
var slice_45empty = () => new Int8Array();
var slice_45of = x => { var array = new Int8Array(1); array[0] = x; return array; };
var slice_45size = slice => slice.length;
var slice_45get = slice => index => { var x = slice[index]; return x === undefined ? 0 : x; };
var slice_45concat = a => b => { var array = new Int8Array(a.length + b.length); array.set(a); array.set(b, a.length); return array; };
var slice_45foldl = f => ys => xs => xs.reduce((a, b) => f(b)(a), ys);
var int32_add = a => b => a + b | 0;
var int32_sub = a => b => a - b | 0;
var int32_mul = a => b => a * b | 0;
var int32_div = a => b => a / b | 0;
var int32_mod = a => b => a % b | 0;
var int32_and = a => b => a & b;
var $ = {};
function _match(value, cases) {
    for (var i = 0; i < cases.length; i += 2) {
        var captures = [];
        var match = match_pattern(value, cases[i], captures);
        if (match) { return cases[i + 1].apply(null, captures); }
    }

    throw new Error("No patterns match");

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
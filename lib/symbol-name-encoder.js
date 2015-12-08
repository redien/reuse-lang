var _43 = function (a, b) { return (a + b) | 0; };
var _45 = function (a, b) { return (a - b) | 0; };
var _47 = function (a, b) { return (a / b) | 0; };
var _42 = function (a, b) { return (a * b) | 0; };
var _37 = function (a, b) { return (a % b) | 0; };
var _62 = function (a, b) { return a > b; };
var _62_61 = function (a, b) { return a >= b; };
var _60 = function (a, b) { return a < b; };
var _60_61 = function (a, b) { return a <= b; };
var _61_61 = function (a, b) { return a === b; };
var _33_61 = function (a, b) { return a !== b; };
var nil = null;
var cons = function (first, rest) { return [first, rest]; };
var first = function (list) { return list === nil ? nil : list[0]; };
var rest = function (list) { return list === nil ? nil : list[1]; };
var nil_63 = function (list) { return list === nil ? true : false; };
var and = function (a, b) { return a && b; };
var or = function (a, b) { return a || b; };
var not = function (x) { return !x; };
var vector_58new = function () {
    return [];
};
var vector_58length = function (vector) {
    return vector.length;
};
var vector_58element_45at_45index = function (vector, index) {
    return vector[index];
};
var vector_58pop = function (vector) {
    var newVector = vector.slice();
    newVector.pop();
    return newVector;
};
var vector_58push = function (vector, value) {
    var newVector = vector.slice();
    newVector.push(value);
    return newVector;
};
var _generate_recursive_function = function (_arguments) {
    return function () {
        var argumentIndex;
        for (argumentIndex = 0; argumentIndex < arguments.length; ++argumentIndex) {
            var argument = arguments[argumentIndex];
            _arguments[argumentIndex] = argument;
        }

        return { _reuse_isRecurValue: true };
    };
};
var _String = function (string) {
    Array.call(this);
    this.__isReuseString = true;

    var index;
    for (index = 0; index < string.length; ++index) {
        var character = string.charCodeAt(index);
        if (character >= 0xD800 && character <= 0xDBFF) {
            var leading = character;
            var trailing = string.charCodeAt(index + 1);

            var SURROGATE_OFFSET = 0x10000 - (0xD800 << 10) - 0xDC00;
            this.push((leading << 10) + trailing + SURROGATE_OFFSET);
            index += 1;

        } else {
            this.push(character);
        }
    }
};
_String.prototype = Object.create(Array.prototype);
_String.prototype.constructor = _String;
_String.prototype.toString = function () {
    var string = '';
    var index;
    for (index = 0; index < this.length; ++index) {
        var codePoint = this[index];

        if (codePoint > 0x10000) {
            var LEAD_OFFSET = 0xD800 - (0x10000 >> 10);
            var leading = LEAD_OFFSET + (codePoint >> 10);
            var trailing = 0xDC00 + (codePoint & 0x3FF);
            string += String.fromCharCode(leading) + String.fromCharCode(trailing);
        } else {
            string += String.fromCharCode(codePoint);
        }
    }
    return string;
};
var string_58new = function () {
    return new _String('');
};
var string_58push = function (string, codePoint) {
    var str = new _String('');
    for (var i = 0; i < string.length; ++i) {
        str.push(string[i]);
    }
    str.push(codePoint);
    return str;
};
var _export_callback = function (func) {
    return function () {
        for (var i = 0; i < arguments.length; ++i) {
            var argument = arguments[i];
            if (result !== null && typeof argument === 'object' && argument.__isReuseString) {
                arguments[i] = argument.toString();
            }

            if (typeof argument === 'function') {
                arguments[i] = _export(argument);
            }
        }

        var result = func.apply(null, arguments);

        if (result !== null && (typeof result === 'string' || result instanceof String)) {
            return new _String(result);
        }

        return result;
    };
};
var _export = function _export(func) {
    if (typeof func === 'function') {
        return function () {
            for (var i = 0; i < arguments.length; ++i) {
                var argument = arguments[i];
                if (typeof argument === 'string' || argument instanceof String) {
                    arguments[i] = new _String(argument);
                }

                if (typeof argument === 'function') {
                    arguments[i] = _export_callback(argument);
                }
            }

            var result = func.apply(null, arguments);

            if (result !== null && typeof result === 'object' && result.__isReuseString) {
                return result.toString();
            }

            return result;
        };
    } else {
        return func;
    }
};
var list_58reduce = (function (f, initial_45value, list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(list) ? initial_45value : recur(f, f(initial_45value, first(list)), rest(list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var list_58foldl = list_58reduce;
var list_58reverse = (function (list) { return list_58reduce((function (a, b) { return cons(b, a); }), nil, list); });
var list_58foldr = (function (f, initial_45value, list) { return list_58reduce((function (a, b) { return f(b, a); }), initial_45value, list_58reverse(list)); });
var list_58map = (function (f, list) { return list_58foldr((function (first, rest) { return cons(f(first), rest); }), nil, list); });
var list_58count = (function (list) { return (function (count_45with_45accumulator) { return count_45with_45accumulator(list, 0); })((function (list, count) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(list) ? count : recur(rest(list), _43(count, 1))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58take = (function (list, n) { return (function (take_45with_45accumulator) { return list_58reverse(take_45with_45accumulator(list, n, nil)); })((function (list, n, new_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(n, 0) ? new_45list : (nil_63(list) ? new_45list : recur(rest(list), _45(n, 1), cons(first(list), new_45list)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58take_45last = (function (list, n) { return (function (count) { return (function (items_45to_45take) { return (function (list_45at_45hop) { return list_45at_45hop(list, items_45to_45take); })((function (list, index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_62(index, 0) ? recur(rest(list), _45(index, 1)) : list); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })(_45(count, n)); })(list_58count(list)); });
var list_58concatenate = (function (first_45list, second_45list) { return (function (concatenate) { return concatenate(list_58reverse(first_45list), second_45list); })((function (first_45list_45reversed, second_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(first_45list_45reversed) ? second_45list : recur(rest(first_45list_45reversed), cons(first(first_45list_45reversed), second_45list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });






var vector_58last_45element = (function (vector) { return vector_58element_45at_45index(vector, _45(vector_58length(vector), 1)); });

var string_58length = (function (string) { return vector_58length(string); });

var string_58code_45point_45at_45index = (function (string, index) { return (_62_61(index, vector_58length(string)) ? 0 : vector_58element_45at_45index(string, index)); });


var math_58pow = (function (base, exponent) { return (function (pow_45with_45accumulator) { return (_61_61(base, 0) ? 0 : pow_45with_45accumulator(base, exponent, 1)); })((function (base, exponent, accumulator) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(exponent, 0) ? accumulator : recur(base, _45(exponent, 1), _42(base, accumulator))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_58concatenate = (function (first_45string, second_45string) { return (function (concatenate_45with_45index) { return concatenate_45with_45index(first_45string, second_45string, 0); })((function (accumulator, string, index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(index, string_58length(string)) ? recur(string_58push(accumulator, string_58code_45point_45at_45index(string, index)), string, _43(index, 1)) : accumulator); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var stdlib_47string_46ru_95substring = (function (string, start, length, string_45length) { return (_60(length, 0) ? string_58new() : (function (substring_45with_45accumulator) { return substring_45with_45accumulator(start, length, string_58new()); })((function (offset, length, new_45string) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (or(_61_61(length, 0), _62_61(offset, string_45length)) ? new_45string : recur(_43(offset, 1), _45(length, 1), string_58push(new_45string, string_58code_45point_45at_45index(string, offset)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; }))); });
var string_58substring = (function (string, start, length) { return stdlib_47string_46ru_95substring(string, start, length, string_58length(string)); });
var stdlib_47string_46ru_95equal_63 = (function (first_45string, first_45string_45length, second_45string, second_45string_45length) { return (function (code_45point_45equal_63) { return (_33_61(first_45string_45length, second_45string_45length) ? false : code_45point_45equal_63(0)); })((function (index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(index, first_45string_45length) ? (_61_61(string_58code_45point_45at_45index(first_45string, index), string_58code_45point_45at_45index(second_45string, index)) ? recur(_43(index, 1)) : false) : true); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_58equal_63 = (function (first_45string, second_45string) { return stdlib_47string_46ru_95equal_63(first_45string, string_58length(first_45string), second_45string, string_58length(second_45string)); });
var string_58decimal_45string_45from_45integer = (function (original_45integer) { return (function (min_45value_45string) { return (function (min_45value) { return (_61_61(original_45integer, min_45value) ? min_45value_45string : (function (string) { return (function (prefixed_45string) { return (function (original_45integer) { return (function (decimal_45string_45from_45integer_45with_45accumulators) { return decimal_45string_45from_45integer_45with_45accumulators(original_45integer, prefixed_45string, 1000000000, 0); })((function (integer, string, exponent, factor) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(exponent, 0) ? (_61_61(string_58length(string), 0) ? string_58push(string, 48) : string) : (function (new_45factor) { return (function (new_45integer) { return (function (new_45exponent) { return (function (new_45string) { return recur(new_45integer, new_45string, new_45exponent, new_45factor); })((_33_61(original_45integer, new_45integer) ? string_58push(string, _43(48, new_45factor)) : string)); })(_47(exponent, 10)); })(_45(integer, _42(new_45factor, exponent))); })(_47(integer, exponent))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })((_60(original_45integer, 0) ? _45(0, original_45integer) : original_45integer)); })((_60(original_45integer, 0) ? string_58push(string, 45) : string)); })(string_58new())); })(_45(_45(0, 2147483647), 1)); })(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58new(), 45), 50), 49), 52), 55), 52), 56), 51), 54), 52), 56)); });
var string_58integer_45from_45decimal_45string = (function (string) { return (function (length) { return (function (negativity_45factor) { return (function (start_45index) { return (function (integer_45from_45decimal_45string_45with_45accumulator) { return (_61_61(length, 0) ? 0 : (function (exponent) { return integer_45from_45decimal_45string_45with_45accumulator(string, start_45index, exponent, 0); })(math_58pow(10, _45(_45(length, start_45index), 1)))); })((function (string, index, exponent, integer) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(index, length) ? _42(negativity_45factor, integer) : recur(string, _43(index, 1), _47(exponent, 10), _43(integer, _42(exponent, _45(string_58code_45point_45at_45index(string, index), 48))))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })((_61_61(negativity_45factor, 1) ? 0 : 1)); })((_61_61(string_58code_45point_45at_45index(string, 0), 45) ? _45(0, 1) : 1)); })(string_58length(string)); });
var encode = (function (name) { return (function (encode_45with_45accumulator) { return encode_45with_45accumulator(name, string_58length(name), 0, string_58new()); })((function (name, name_45length, index, encoded_45name) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (function (code_45point) { return (_60(index, name_45length) ? (or(and(_62_61(code_45point, 65), _60_61(code_45point, 90)), and(_62_61(code_45point, 97), _60_61(code_45point, 122))) ? recur(name, name_45length, _43(index, 1), string_58push(encoded_45name, code_45point)) : recur(name, name_45length, _43(index, 1), string_58concatenate(string_58push(encoded_45name, 95), string_58decimal_45string_45from_45integer(code_45point)))) : encoded_45name); })(string_58code_45point_45at_45index(name, index)); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); }); module.exports.encode = _export(encode);

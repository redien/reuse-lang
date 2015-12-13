var comp = function (first, second) {
    return function (x) {
        return first(second(x));
    };
};
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
var transducers_58mapping = (function (f) { return (function (step) { return (function (accumulator, value) { return step(accumulator, f(value)); }); }); });
var transducers_58filtering = (function (predicate) { return (function (step) { return (function (accumulator, value) { return (predicate(value) ? step(accumulator, value) : accumulator); }); }); });
var transducers_58overriding = (function (value) { return (function (step) { return (function (accumulator, _95) { return step(accumulator, value); }); }); });
var stdlib_47list_46ru_95swap = (function (f) { return (function (a, b) { return f(b, a); }); });
var list_58reduce = (function (f, accumulator, list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(list) ? accumulator : recur(f, f(accumulator, first(list)), rest(list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var list_58foldl = list_58reduce;
var list_58reverse = (function (list) { return list_58reduce(stdlib_47list_46ru_95swap(cons), nil, list); });
var list_58foldr = (function (f, initial_45value, list) { return list_58reduce(f, initial_45value, list_58reverse(list)); });
var list_58map = (function (f, list) { return list_58transduce_45right(transducers_58mapping(f), stdlib_47list_46ru_95swap(cons), nil, list); });
var list_58filter = (function (predicate, list) { return list_58transduce_45right(transducers_58filtering(predicate), stdlib_47list_46ru_95swap(cons), nil, list); });
var list_58count = (function (list) { return list_58transduce(transducers_58overriding(1), _43, 0, list); });
var list_58take = (function (list, n) { return (function (take_45with_45accumulator) { return list_58reverse(take_45with_45accumulator(list, n, nil)); })((function (list, n, new_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(n, 0) ? new_45list : (nil_63(list) ? new_45list : recur(rest(list), _45(n, 1), cons(first(list), new_45list)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58take_45last = (function (list, n) { return (function (count) { return (function (items_45to_45take) { return (function (list_45at_45hop) { return list_45at_45hop(list, items_45to_45take); })((function (list, index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_62(index, 0) ? recur(rest(list), _45(index, 1)) : list); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })(_45(count, n)); })(list_58count(list)); });
var list_58concatenate = (function (first_45list, second_45list) { return (function (concatenate) { return concatenate(list_58reverse(first_45list), second_45list); })((function (first_45list_45reversed, second_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(first_45list_45reversed) ? second_45list : recur(rest(first_45list_45reversed), cons(first(first_45list_45reversed), second_45list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58transduce = (function (transducer, step, initial_45value, list) { return (function (reducer) { return list_58foldl(reducer, initial_45value, list); })(transducer(step)); });
var list_58transduce_45right = (function (transducer, step, initial_45value, list) { return (function (reducer) { return list_58foldr(reducer, initial_45value, list); })(transducer(step)); });






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

var parse_45tree_58list_45kind = string_58push(string_58push(string_58push(string_58push(string_58new(), 108), 105), 115), 116);
var parse_45tree_58atom_45kind = string_58push(string_58push(string_58push(string_58push(string_58new(), 97), 116), 111), 109);
var parse_45tree_58atom = (function (value, line, column) { return cons(1, cons(value, cons(line, cons(column, nil)))); });
var parse_45tree_58list = (function () { return cons(0, nil); });
var parse_45tree_58kind = (function (expression) { return (_61_61(first(expression), 0) ? parse_45tree_58list_45kind : parse_45tree_58atom_45kind); });
var parse_45tree_58atom_63 = (function (expression) { return _61_61(first(expression), 1); });
var parse_45tree_58list_63 = (function (expression) { return _61_61(first(expression), 0); });
var parse_45tree_58value = (function (expression) { return first(rest(expression)); });
var parse_45tree_58line = (function (expression) { return first(rest(rest(expression))); });
var parse_45tree_58column = (function (expression) { return first(rest(rest(rest(expression)))); });
var parse_45tree_58child = (function (expression, index) { return (function (list) { return (function (count) { return (function (item_45at_45position) { return item_45at_45position(list, 0, index); })((function (list, index, target_45index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (and(_60(index, count), _60(index, target_45index)) ? recur(rest(list), _43(index, 1)) : first(list)); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })(list_58count(list)); })(rest(expression)); });
var parse_45tree_58count = (function (expression) { return (function (list) { return list_58count(list); })(rest(expression)); });
var parse_45tree_58push = (function (expression, child) { return (function (list) { return (function (push_45back) { return cons(0, push_45back(list, child)); })((function (list, item) { return list_58concatenate(list, cons(item, nil)); })); })(rest(expression)); });
var _46_47lib_47parse_45tree_46ru_95transform_45list = (function (list, child_45index, new_45list, should_45replace_63, replace) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(child_45index, parse_45tree_58count(list)) ? recur(list, _43(child_45index, 1), parse_45tree_58push(new_45list, parse_45tree_58transform(parse_45tree_58child(list, child_45index), should_45replace_63, replace)), should_45replace_63, replace) : new_45list); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var parse_45tree_58transform = (function (parse_45tree, should_45replace_63, replace) { return (should_45replace_63(parse_45tree) ? replace(parse_45tree) : (parse_45tree_58list_63(parse_45tree) ? _46_47lib_47parse_45tree_46ru_95transform_45list(parse_45tree, 0, parse_45tree_58list(), should_45replace_63, replace) : parse_45tree)); });
var error = (function (type) { return cons(1, type); }); module.exports.error = _export(error);
var isError = (function (expression) { return _61_61(first(expression), 1); }); module.exports.isError = _export(isError);
var errorType = (function (expression) { return rest(expression); }); module.exports.errorType = _export(errorType);
var result = (function (program) { return cons(0, program); }); module.exports.result = _export(result);
var value = (function (expression) { return rest(expression); }); module.exports.value = _export(value);
var unbalanced_45parentheses_45value = string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58new(), 117), 110), 98), 97), 108), 97), 110), 99), 101), 100), 95), 112), 97), 114), 101), 110), 116), 104), 101), 115), 101), 115);
var unbalanced_45parentheses_45error = error(unbalanced_45parentheses_45value);
var whitespace_63 = (function (character) { return or(_61_61(character, 32), or(_61_61(character, 9), or(_61_61(character, 10), or(_61_61(character, 13), or(_61_61(character, 160), or(_61_61(character, 5760), or(_61_61(character, 6158), or(_61_61(character, 8192), or(_61_61(character, 8193), or(_61_61(character, 8194), or(_61_61(character, 8195), or(_61_61(character, 8196), or(_61_61(character, 8197), or(_61_61(character, 8198), or(_61_61(character, 8199), or(_61_61(character, 8200), or(_61_61(character, 8201), or(_61_61(character, 8202), or(_61_61(character, 8203), or(_61_61(character, 8239), or(_61_61(character, 8287), or(_61_61(character, 12288), _61_61(character, 65279))))))))))))))))))))))); });
var open_45parenthesis = 40;
var close_45parenthesis = 41;
var line_45feed = 10;
var intermediate_45result_45new = (function (expression, index, row, row_45start) { return cons(0, cons(expression, cons(index, cons(row, row_45start)))); });
var intermediate_45result_45expression = (function (result) { return first(rest(result)); });
var intermediate_45result_45index = (function (result) { return first(rest(rest(result))); });
var intermediate_45result_45row = (function (result) { return first(rest(rest(rest(result)))); });
var intermediate_45result_45row_45start = (function (result) { return rest(rest(rest(rest(result)))); });
var intermediate_45result_45new_45error = (function () { return cons(1, nil); });
var intermediate_45result_45error_63 = (function (result) { return _61_61(first(result), 1); });
var part_45of_45atom_63 = (function (character) { return not(or(or(whitespace_63(character), _61_61(character, open_45parenthesis)), _61_61(character, close_45parenthesis))); });
var parse_45atom = (function (program, program_45length, index, row, row_45start) { return (function (parse_45atom_45value) { return (function (value) { return (function (next_45index) { return intermediate_45result_45new(parse_45tree_58atom(value, row, _43(_45(index, row_45start), 1)), next_45index, row, row_45start); })(_43(index, string_58length(value))); })(parse_45atom_45value(program, program_45length, index, string_58new())); })((function (program, program_45length, index, value) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(index, program_45length) ? (function (character) { return (part_45of_45atom_63(character) ? recur(program, program_45length, _43(index, 1), string_58push(value, character)) : value); })(string_58code_45point_45at_45index(program, index)) : value); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_45end_63 = (function (program, program_45length, index) { return _62_61(index, program_45length); });
var close_45parenthesis_63 = (function (program, program_45length, index) { return and(_60(index, program_45length), (function (character) { return _61_61(character, close_45parenthesis); })(string_58code_45point_45at_45index(program, index))); });
var parse_45expression = (function (program, program_45length, index, row, row_45start) { return (function (character) { return (_61_61(character, open_45parenthesis) ? parse_45list(program, program_45length, _43(index, 1), row, row_45start, parse_45tree_58list(), close_45parenthesis_63, string_45end_63) : parse_45atom(program, program_45length, index, row, row_45start)); })(string_58code_45point_45at_45index(program, index)); });
var parse_45list = (function (program, program_45length, index, row, row_45start, list, stop_63, error_63) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (stop_63(program, program_45length, index) ? intermediate_45result_45new(list, _43(index, 1), row, row_45start) : (error_63(program, program_45length, index) ? intermediate_45result_45new_45error() : (function (character) { return (_61_61(character, line_45feed) ? recur(program, program_45length, _43(index, 1), _43(row, 1), _43(index, 1), list, stop_63, error_63) : (whitespace_63(character) ? recur(program, program_45length, _43(index, 1), row, row_45start, list, stop_63, error_63) : (function (intermediate_45result) { return (intermediate_45result_45error_63(intermediate_45result) ? intermediate_45result : (function (expression) { return (function (next_45index) { return (function (next_45row) { return (function (next_45row_45start) { return recur(program, program_45length, next_45index, next_45row, next_45row_45start, parse_45tree_58push(list, expression), stop_63, error_63); })(intermediate_45result_45row_45start(intermediate_45result)); })(intermediate_45result_45row(intermediate_45result)); })(intermediate_45result_45index(intermediate_45result)); })(intermediate_45result_45expression(intermediate_45result))); })(parse_45expression(program, program_45length, index, row, row_45start)))); })(string_58code_45point_45at_45index(program, index)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var parse = (function (program) { return (function (intermediate_45result) { return (intermediate_45result_45error_63(intermediate_45result) ? unbalanced_45parentheses_45error : (function (parsed_45program) { return result(parsed_45program); })(intermediate_45result_45expression(intermediate_45result))); })(parse_45list(program, string_58length(program), 0, 1, 0, parse_45tree_58list(), string_45end_63, close_45parenthesis_63)); }); module.exports.parse = _export(parse);

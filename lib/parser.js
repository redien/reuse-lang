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
var _utf16IndexFromutf32Index = function (string, utf32Index) {
    var utf16Index = 0;

    while (utf32Index > 0 && utf16Index < string.length) {
        var character = string.charCodeAt(utf16Index);

        if (character >= 0xD800 && character <= 0xDBFF) {
            utf16Index += 1;
        }

        utf16Index += 1;
        utf32Index -= 1;
    }

    return utf16Index;
};
var _charCodeAt = function (string, index) {
    index = _utf16IndexFromutf32Index(string, index);
    if (index >= string.length) { return 0; }

    var character = string.charCodeAt(index);
    if (character >= 0xD800 && character <= 0xDBFF) {
        var leading = character;
        var trailing = string.charCodeAt(index + 1);

        var SURROGATE_OFFSET = 0x10000 - (0xD800 << 10) - 0xDC00;
        return (leading << 10) + trailing + SURROGATE_OFFSET;
    }

    return character;
};
var _string_push = function (string, codePoint) {
    if (codePoint < 0x10000) {
        return string + String.fromCharCode(codePoint);
    } else {
        var LEAD_OFFSET = 0xD800 - (0x10000 >> 10);
        var leading = LEAD_OFFSET + (codePoint >> 10);
        var trailing = 0xDC00 + (codePoint & 0x3FF);
        return string + String.fromCharCode(leading) + String.fromCharCode(trailing);
    }
};
var _string_length = function (string) {
    var count = 0;
    var index = 0;

    while (index < string.length) {
        var character = string.charCodeAt(index);

        if (character >= 0xD800 && character <= 0xDBFF) {
            index += 2;
        } else {
            index += 1;
        }

        count += 1;
    }

    return count;
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
var list_58reduce = (function (f, initial_45value, list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(list) ? initial_45value : recur(f, f(initial_45value, first(list)), rest(list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var list_58foldl = list_58reduce;
var list_58reverse = (function (list) { return list_58reduce((function (a, b) { return cons(b, a); }), nil, list); });
var list_58foldr = (function (f, initial_45value, list) { return list_58reduce((function (a, b) { return f(b, a); }), initial_45value, list_58reverse(list)); });
var list_58map = (function (f, list) { return list_58foldr((function (first, rest) { return cons(f(first), rest); }), nil, list); });
var list_58count = (function (list) { return (function (count_45with_45accumulator) { return count_45with_45accumulator(list, 0); })((function (list, count) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(list) ? count : recur(rest(list), _43(count, 1))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58take = (function (list, n) { return (function (take_45with_45accumulator) { return list_58reverse(take_45with_45accumulator(list, n, nil)); })((function (list, n, new_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(n, 0) ? new_45list : (nil_63(list) ? new_45list : recur(rest(list), _45(n, 1), cons(first(list), new_45list)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58take_45last = (function (list, n) { return (function (count) { return (function (items_45to_45take) { return (function (list_45at_45hop) { return list_45at_45hop(list, items_45to_45take); })((function (list, index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_62(index, 0) ? recur(rest(list), _45(index, 1)) : list); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })(_45(count, n)); })(list_58count(list)); });
var list_58concatenate = (function (first_45list, second_45list) { return (function (concatenate) { return concatenate(list_58reverse(first_45list), second_45list); })((function (first_45list_45reversed, second_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(first_45list_45reversed) ? second_45list : recur(rest(first_45list_45reversed), cons(first(first_45list_45reversed), second_45list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_58new = (function () { return cons(0, nil); });
var string_58length = (function (string) { return first(string); });
var string_58push = (function (string, code_45point) { return cons(_43(first(string), 1), cons(code_45point, rest(string))); });
var string_58code_45point_45at_45index = (function (string, index) { return (_62_61(index, _string_length(string)) ? 0 : first(list_58take_45last(rest(string), _43(index, 1)))); });
var string_58concatenate = (function (first_45string, second_45string) { return cons(_43(first(first_45string), first(second_45string)), list_58concatenate(rest(second_45string), rest(first_45string))); });


var math_58pow = (function (base, exponent) { return (function (pow_45with_45accumulator) { return (_61_61(base, 0) ? 0 : pow_45with_45accumulator(base, exponent, 1)); })((function (base, exponent, accumulator) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(exponent, 0) ? accumulator : recur(base, _45(exponent, 1), _42(base, accumulator))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_58substring = (function (string, start, length) { return (_60(length, 0) ? '' : (function (string_45length) { return (function (substring_45with_45accumulator) { return substring_45with_45accumulator(string, start, length, ''); })((function (string, offset, length, new_45string) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (or(_61_61(length, 0), _62_61(offset, string_45length)) ? new_45string : recur(string, _43(offset, 1), _45(length, 1), _string_push(new_45string, _charCodeAt(string, offset)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })(_string_length(string))); });
var string_58equal_63 = (function (first_45string, second_45string) { return (function (code_45point_45equal_63) { return (_33_61(_string_length(first_45string), _string_length(second_45string)) ? false : code_45point_45equal_63(first_45string, second_45string, 0)); })((function (first_45string, second_45string, index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(index, _string_length(first_45string)) ? (_61_61(_charCodeAt(first_45string, index), _charCodeAt(second_45string, index)) ? recur(first_45string, second_45string, _43(index, 1)) : false) : true); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_58decimal_45string_45from_45integer = (function (original_45integer) { return (function (min_45value_45string) { return (function (min_45value) { return (_61_61(original_45integer, min_45value) ? min_45value_45string : (function (string) { return (function (prefixed_45string) { return (function (original_45integer) { return (function (decimal_45string_45from_45integer_45with_45accumulators) { return decimal_45string_45from_45integer_45with_45accumulators(original_45integer, prefixed_45string, 1000000000, 0); })((function (integer, string, exponent, factor) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(exponent, 0) ? (_61_61(_string_length(string), 0) ? _string_push(string, 48) : string) : (function (new_45factor) { return (function (new_45integer) { return (function (new_45exponent) { return (function (new_45string) { return recur(new_45integer, new_45string, new_45exponent, new_45factor); })((_33_61(original_45integer, new_45integer) ? _string_push(string, _43(48, new_45factor)) : string)); })(_47(exponent, 10)); })(_45(integer, _42(new_45factor, exponent))); })(_47(integer, exponent))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })((_60(original_45integer, 0) ? _45(0, original_45integer) : original_45integer)); })((_60(original_45integer, 0) ? _string_push(string, 45) : string)); })('')); })(_45(_45(0, 2147483647), 1)); })(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push('', 45), 50), 49), 52), 55), 52), 56), 51), 54), 52), 56)); });
var string_58integer_45from_45decimal_45string = (function (string) { return (function (length) { return (function (negativity_45factor) { return (function (start_45index) { return (function (integer_45from_45decimal_45string_45with_45accumulator) { return (_61_61(length, 0) ? 0 : (function (exponent) { return integer_45from_45decimal_45string_45with_45accumulator(string, start_45index, exponent, 0); })(math_58pow(10, _45(_45(length, start_45index), 1)))); })((function (string, index, exponent, integer) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(index, length) ? _42(negativity_45factor, integer) : recur(string, _43(index, 1), _47(exponent, 10), _43(integer, _42(exponent, _45(_charCodeAt(string, index), 48))))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })((_61_61(negativity_45factor, 1) ? 0 : 1)); })((_61_61(_charCodeAt(string, 0), 45) ? _45(0, 1) : 1)); })(_string_length(string)); });

var parse_45tree_58list_45kind = _string_push(_string_push(_string_push(_string_push('', 108), 105), 115), 116);
var parse_45tree_58atom_45kind = _string_push(_string_push(_string_push(_string_push('', 97), 116), 111), 109);
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
var error = (function (type) { return cons(1, type); }); module.exports.error = error;
var isError = (function (expression) { return _61_61(first(expression), 1); }); module.exports.isError = isError;
var errorType = (function (expression) { return rest(expression); }); module.exports.errorType = errorType;
var result = (function (program) { return cons(0, program); }); module.exports.result = result;
var value = (function (expression) { return rest(expression); }); module.exports.value = value;
var unbalanced_45parentheses_45value = _string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push(_string_push('', 117), 110), 98), 97), 108), 97), 110), 99), 101), 100), 95), 112), 97), 114), 101), 110), 116), 104), 101), 115), 101), 115);
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
var parse_45atom = (function (program, index, row, row_45start) { return (function (parse_45atom_45value) { return (function (value) { return (function (next_45index) { return intermediate_45result_45new(parse_45tree_58atom(value, row, _43(_45(index, row_45start), 1)), next_45index, row, row_45start); })(_43(index, _string_length(value))); })(parse_45atom_45value(program, index, '')); })((function (program, index, value) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(index, _string_length(program)) ? (function (character) { return (part_45of_45atom_63(character) ? recur(program, _43(index, 1), _string_push(value, character)) : value); })(_charCodeAt(program, index)) : value); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_45end_63 = (function (program, index) { return _62_61(index, _string_length(program)); });
var close_45parenthesis_63 = (function (program, index) { return and(_60(index, _string_length(program)), (function (character) { return _61_61(character, close_45parenthesis); })(_charCodeAt(program, index))); });
var parse_45expression = (function (program, index, row, row_45start) { return (function (character) { return (_61_61(character, open_45parenthesis) ? parse_45list(program, _43(index, 1), row, row_45start, parse_45tree_58list(), close_45parenthesis_63, string_45end_63) : parse_45atom(program, index, row, row_45start)); })(_charCodeAt(program, index)); });
var parse_45list = (function (program, index, row, row_45start, list, stop_63, error_63) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (stop_63(program, index) ? intermediate_45result_45new(list, _43(index, 1), row, row_45start) : (error_63(program, index) ? intermediate_45result_45new_45error() : (function (character) { return (_61_61(character, line_45feed) ? recur(program, _43(index, 1), _43(row, 1), _43(index, 1), list, stop_63, error_63) : (whitespace_63(character) ? recur(program, _43(index, 1), row, row_45start, list, stop_63, error_63) : (function (intermediate_45result) { return (intermediate_45result_45error_63(intermediate_45result) ? intermediate_45result : (function (expression) { return (function (next_45index) { return (function (next_45row) { return (function (next_45row_45start) { return recur(program, next_45index, next_45row, next_45row_45start, parse_45tree_58push(list, expression), stop_63, error_63); })(intermediate_45result_45row_45start(intermediate_45result)); })(intermediate_45result_45row(intermediate_45result)); })(intermediate_45result_45index(intermediate_45result)); })(intermediate_45result_45expression(intermediate_45result))); })(parse_45expression(program, index, row, row_45start)))); })(_charCodeAt(program, index)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var parse = (function (program) { return (function (intermediate_45result) { return (intermediate_45result_45error_63(intermediate_45result) ? unbalanced_45parentheses_45error : (function (parsed_45program) { return result(parsed_45program); })(intermediate_45result_45expression(intermediate_45result))); })(parse_45list(program, 0, 1, 0, parse_45tree_58list(), string_45end_63, close_45parenthesis_63)); }); module.exports.parse = parse;

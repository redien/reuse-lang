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
var string_58new = function () {
    return '';
};
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
var string_58code_45point_45at_45index = function (string, index) {
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
var string_58push = function (string, codePoint) {
    if (codePoint < 0x10000) {
        return string + String.fromCharCode(codePoint);
    } else {
        var LEAD_OFFSET = 0xD800 - (0x10000 >> 10);
        var leading = LEAD_OFFSET + (codePoint >> 10);
        var trailing = 0xDC00 + (codePoint & 0x3FF);
        return string + String.fromCharCode(leading) + String.fromCharCode(trailing);
    }
};
var string_58length = function (string) {
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
var string_58equal_63 = function (a, b) {
    if (typeof a !== 'string') {
        throw new Error(a + ' is not a string');
    }
    if (typeof b !== 'string') {
        throw new Error(b + ' is not a string');
    }
    return a === b;
};
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
var list_58reduce = (function (f, initial_45value, list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(list) ? initial_45value : recur(f, f(initial_45value, first(list)), rest(list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var list_58foldl = list_58reduce;
var list_58reverse = (function (list) { return list_58reduce((function (a, b) { return cons(b, a); }), nil, list); });
var list_58foldr = (function (f, initial_45value, list) { return list_58reduce((function (a, b) { return f(b, a); }), initial_45value, list_58reverse(list)); });
var list_58map = (function (f, list) { return list_58foldr((function (first, rest) { return cons(f(first), rest); }), nil, list); });
var list_58count = (function (list) { return (function (count_45with_45accumulator) { return count_45with_45accumulator(list, 0); })((function (list, count) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(list) ? count : recur(rest(list), _43(count, 1))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58take = (function (list, n) { return (function (take_45with_45accumulator) { return list_58reverse(take_45with_45accumulator(list, n, nil)); })((function (list, n, new_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(n, 0) ? new_45list : (nil_63(list) ? new_45list : recur(rest(list), _45(n, 1), cons(first(list), new_45list)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var list_58take_45last = (function (list, n) { return (function (count) { return (function (items_45to_45take) { return (function (list_45at_45hop) { return list_45at_45hop(list, items_45to_45take); })((function (list, index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_62(index, 0) ? recur(rest(list), _45(index, 1)) : list); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); })(_45(count, n)); })(list_58count(list)); });
var list_58concatenate = (function (first_45list, second_45list) { return (function (concatenate) { return concatenate(list_58reverse(first_45list), second_45list); })((function (first_45list_45reversed, second_45list) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(first_45list_45reversed) ? second_45list : recur(rest(first_45list_45reversed), cons(first(first_45list_45reversed), second_45list))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });







var math_58pow = (function (base, exponent) { return (function (pow_45with_45accumulator) { return (_61_61(base, 0) ? 0 : pow_45with_45accumulator(base, exponent, 1)); })((function (base, exponent, accumulator) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_61_61(exponent, 0) ? accumulator : recur(base, _45(exponent, 1), _42(base, accumulator))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var string_58concatenate = (function (first_45string, second_45string) { return (function (concatenate_45with_45index) { return concatenate_45with_45index(first_45string, second_45string, 0); })((function (accumulator, string, index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(index, string_58length(string)) ? recur(string_58push(accumulator, string_58code_45point_45at_45index(string, index)), string, _43(index, 1)) : accumulator); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });
var substring = (function (string, start, length, string_45length) { return (_60(length, 0) ? string_58new() : (function (substring_45with_45accumulator) { return substring_45with_45accumulator(start, length, string_58new()); })((function (offset, length, new_45string) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (or(_61_61(length, 0), _62_61(offset, string_45length)) ? new_45string : recur(_43(offset, 1), _45(length, 1), string_58push(new_45string, string_58code_45point_45at_45index(string, offset)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; }))); });
var string_58substring = (function (string, start, length) { return substring(string, start, length, string_58length(string)); });
var equal_63 = (function (first_45string, first_45string_45length, second_45string, second_45string_45length) { return (function (code_45point_45equal_63) { return (_33_61(first_45string_45length, second_45string_45length) ? false : code_45point_45equal_63(0)); })((function (index) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (_60(index, first_45string_45length) ? (_61_61(string_58code_45point_45at_45index(first_45string, index), string_58code_45point_45at_45index(second_45string, index)) ? recur(_43(index, 1)) : false) : true); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); });

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
var export_45value = string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58new(), 101), 120), 112), 111), 114), 116);
var import_45value = string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58new(), 105), 109), 112), 111), 114), 116);
var new_45define_45from_45import_45atom = (function (line, column) { return parse_45tree_58atom(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58push(string_58new(), 100), 101), 102), 105), 110), 101), 45), 102), 114), 111), 109), 45), 105), 109), 112), 111), 114), 116), line, column); });
var module_45list_45contains_63 = (function (module_45list, module_45name) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(module_45list) ? false : (string_58equal_63(module_45name, first(module_45list)) ? true : recur(rest(module_45list), module_45name))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });
var make_45state = (function (program, statement_45index, module_45name, import_45prefix, redefine_45exports) { return cons(program, cons(statement_45index, cons(module_45name, cons(import_45prefix, redefine_45exports)))); });
var append_45state = (function (state_45list, state) { return cons(state, state_45list); });
var _reserved_import = (function (program, module_45loader) { return (function (convert_45module) { return (_62(parse_45tree_58count(program), 0) ? convert_45module(append_45state(nil, make_45state(program, 0, string_58new(), string_58new(), false)), parse_45tree_58list(), nil) : parse_45tree_58list()); })((function (state, new_45program, imported_45modules) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = (nil_63(state) ? new_45program : (function (program) { return (function (statement_45index) { return (function (module_45name) { return (function (import_45prefix) { return (function (redefine_45exports) { return (function (statement) { return (function (form_45name) { return (function (module_45import_63) { return (function (import_45prefix) { return (function (state_45for_45next_45statement) { return (function (state_45with_45imported_45module) { return (function (statement) { return (function (new_45program) { return (function (next_45state) { return (function (imported_45modules) { return recur(next_45state, new_45program, imported_45modules); })((module_45import_63 ? cons(parse_45tree_58value(parse_45tree_58child(statement, 1)), imported_45modules) : imported_45modules)); })((module_45import_63 ? (function (module_45name) { return (function (loaded_45module) { return (_62(parse_45tree_58count(loaded_45module), 0) ? state_45with_45imported_45module(module_45name, loaded_45module) : state_45for_45next_45statement()); })(module_45loader(module_45name)); })(parse_45tree_58value(parse_45tree_58child(statement, 1))) : state_45for_45next_45statement())); })((or(string_58equal_63(import_45value, form_45name), _62_61(statement_45index, parse_45tree_58count(program))) ? new_45program : parse_45tree_58push(new_45program, statement))); })((and(redefine_45exports, string_58equal_63(export_45value, form_45name)) ? parse_45tree_58push(parse_45tree_58push(parse_45tree_58push(parse_45tree_58push(parse_45tree_58list(), new_45define_45from_45import_45atom(0, 0)), parse_45tree_58atom(string_58concatenate(import_45prefix, parse_45tree_58value(parse_45tree_58child(statement, 1))), 0, 0)), parse_45tree_58child(statement, 2)), parse_45tree_58atom(module_45name, 0, 0)) : statement)); })((function (module_45name, imported_45module) { return append_45state(state_45for_45next_45statement(), make_45state(imported_45module, 0, module_45name, import_45prefix, true)); })); })((function () { return (_60(_43(statement_45index, 1), parse_45tree_58count(program)) ? append_45state(rest(state), make_45state(program, _43(statement_45index, 1), module_45name, import_45prefix, redefine_45exports)) : rest(state)); })); })((and(module_45import_63, _61_61(parse_45tree_58count(statement), 3)) ? string_58push(parse_45tree_58value(parse_45tree_58child(statement, 2)), 58) : import_45prefix)); })(and(string_58equal_63(import_45value, form_45name), not(module_45list_45contains_63(imported_45modules, parse_45tree_58value(parse_45tree_58child(statement, 1)))))); })(parse_45tree_58value(parse_45tree_58child(statement, 0))); })(parse_45tree_58child(program, statement_45index)); })(rest(rest(rest(rest(first(state)))))); })(first(rest(rest(rest(first(state)))))); })(first(rest(rest(first(state))))); })(first(rest(first(state)))); })(first(first(state)))); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; })); }); module.exports.import = _reserved_import;

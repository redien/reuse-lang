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

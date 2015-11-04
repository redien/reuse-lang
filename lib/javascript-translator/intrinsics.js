var _43 = function (a, b) { return (a + b) | 0; };
var _45 = function (a, b) { return (a - b) | 0; };
var _47 = function (a, b) { return (a / b) | 0; };
var _42 = function (a, b) { return (a * b) | 0; };
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
var or = function (a, b) { return a || b; }
var _charCodeAt = function (string, index) {
    if (index >= string.length) { return 0; }
    return string.charCodeAt(index);
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
var code_45point_45list_45from_45string = function (string) {
    var list = null;
    var index;
    for (index = string.length - 1; index >= 0; --index) {
        var character = string.charCodeAt(index);

        if (character >= 0xDC00 && character <= 0xDFFF && index - 1 >= 0) {
            var low = character - 0xDC00;
            index -= 1;
            var high = string.charCodeAt(index) - 0xD800;

            character = (low | (high << 10)) + 0x10000;
        }

        list = [character, list];
    }

    return list;
};

var string_45from_45code_45point_45list = function (list) {
    var string = '';
    while (list !== null) {
        var codePoint = list[0];

        if (codePoint < 0x10000) {
            string += String.fromCharCode(codePoint);
        } else {
            codePoint -= 0x10000;
            var high = (codePoint & 0x00FC0F00) + 0xD800;
            var low = (codePoint & 0xFF03) + 0xDC00;
            string += String.fromCharCode(high);
            string += String.fromCharCode(low);
        }

        list = list[1];
    }
    return string;
};

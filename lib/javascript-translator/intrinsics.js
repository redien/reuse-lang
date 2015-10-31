var _43 = function (a, b) { return (a + b) | 0; };
var _45 = function (a, b) { return (a - b) | 0; };
var _47 = function (a, b) { return (a / b) | 0; };
var _42 = function (a, b) { return (a * b) | 0; };
var _62 = function (a, b) { return a > b; };
var _62_61 = function (a, b) { return a >= b; };
var _60 = function (a, b) { return a < b; };
var _60_61 = function (a, b) { return a <= b; };
var _61_61 = function (a, b) { return a === b; };
var nil = null;
var cons = function (first, rest) { return [first, rest]; };
var first = function (list) { return list === nil ? nil : list[0]; };
var rest = function (list) { return list === nil ? nil : list[1]; };
var nil_63 = function (list) { return list === nil ? true : false; };
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

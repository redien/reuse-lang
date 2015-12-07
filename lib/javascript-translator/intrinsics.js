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

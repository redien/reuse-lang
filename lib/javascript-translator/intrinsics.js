var i32_add = function (a, b) { return (a + b) | 0; };
var i32_subtract = function (a, b) { return (a - b) | 0; };
var i32_divide = function (a, b) { return (a / b) | 0; };
var i32_multiply = function (a, b) { return (a * b) | 0; };
var nil = [];
var cons = function (first, rest) { return [first, rest]; };
var first = function (list) { return list === nil ? nil : list[0]; };
var rest = function (list) { return list === nil ? nil : list[1]; };
var is_nil = function (list) { return list === nil ? true : false; };

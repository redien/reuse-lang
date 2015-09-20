var i32_add = function (a, b) { return (a + b) | 0; };
module.exports.add5 = (function (a) { return i32_add(a, 3); });

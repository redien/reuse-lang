
// reuse-lang - a pure functional lisp-like language for writing
// reusable algorithms in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var fs = require('fs');
var reuse = require(__dirname + '/../../lib/reuse');

var generateTestModuleName = function () {
    // Make sure we don't get the cached module when we require.
    return __dirname + '/test-module' + Math.random() + '.js';
};
module.exports.generateTestModuleName = generateTestModuleName;

var evaluateExpressionWithProgram = function (expression, program) {
    var testModuleName = generateTestModuleName();

    var translation = reuse.translate(program, reuse.moduleProvider);

    if (translation.error) {
        throw translation;
    }

    fs.writeFileSync(testModuleName, translation.value);

    try {
        var module = require(testModuleName);
        var result = eval(expression);
        fs.unlinkSync(testModuleName);
        return result;

    } catch (exception) {
        fs.unlinkSync(testModuleName);
        throw exception;
    }
};
module.exports.evaluateExpressionWithProgram = evaluateExpressionWithProgram;


var fs = require('fs');
var should = require('should');
var reuse = require('../lib/reuse.js');

var generateTestModuleName = function () {
    // Make sure we don't get the cached module when we require.
    return __dirname + '/test-module' + Math.random() + '.js';
};

var it_should_evaluate_expression_to_value_given_program = function (expression, expected, program) {
    it('should evaluate ' + expression + ' to ' + JSON.stringify(expected) + ' given ' + program, function () {
        var testModuleName = generateTestModuleName();
        fs.writeFileSync(testModuleName, reuse.translate(program).value);
        var module = require(testModuleName);
        try {
            eval(expression).should.equal(expected);
            fs.unlinkSync(testModuleName);
        } catch (exception) {
            fs.unlinkSync(testModuleName);
            throw exception;
        }
    });
};

module.exports = it_should_evaluate_expression_to_value_given_program;

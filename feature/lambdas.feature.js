
var fs = require('fs');
var should = require('should');
var reuse = require('../lib/reuse.js');

var TEST_MODULE = __dirname + '/lambda-test-module.js';

var it_should_evaluate_expression_to_value_given_program = function (expression, expected, program) {
    it('should evaluate ' + expression + ' to ' + expected + ' given ' + program, function () {
        fs.writeFileSync(TEST_MODULE, reuse.translate(program).value);
        var module = require(TEST_MODULE);
        try {
            eval(expression).should.equal(expected);
            fs.unlinkSync(TEST_MODULE);
        } catch (exception) {
            fs.unlinkSync(TEST_MODULE);
            throw exception;
        }
    });
};

describe('Lambdas', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.identity("3")',
        '3',
        '(export identity (lambda (x) x))'
    );
});

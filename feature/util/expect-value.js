
var should = require('should');
var nodeTester = require(__dirname + '/node-tester');

var it_should_evaluate_expression_to_value_given_program = function (expression, expected, program, message) {
    message = message || 'should evaluate ' + expression + ' to ' + JSON.stringify(expected) + ' given ' + program;

    it(message, function () {
        nodeTester.evaluateExpressionWithProgram(expression, program).should.equal(expected);
    });
};

module.exports = it_should_evaluate_expression_to_value_given_program;

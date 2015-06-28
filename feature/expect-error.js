
var should = require('should');
var nodeTester = require('./node-tester');

var it_should_return_error_given_program = function (error, program) {
    it('should throw error ' + error + ' given ' + program, function () {
        var threw = false;
        try {
            nodeTester.evaluateExpressionWithProgram(undefined, program);
        } catch (exception) {
            exception.message.should.equal(error);
            threw = true;
        }

        if (!threw) {
            throw new Error("Expected to return error " + error);
        }
    });
};

module.exports = it_should_return_error_given_program;

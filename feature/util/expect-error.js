
var should = require('should');
var nodeTester = require(__dirname + '/node-tester');

var it_should_return_error_given_program = function (expectedError, line, column, program) {
    it('should return error ' + expectedError + ' at line ' + line + ' column ' + column + ' given ' + program, function () {
        var threw = false;
        try {
            nodeTester.evaluateExpressionWithProgram(undefined, program);
        } catch (error) {
            error.message.should.equal(expectedError);
            error.line.should.equal(line);
            error.column.should.equal(column);
            threw = true;
        }

        if (!threw) {
            throw new Error("Expected to return error " + expectedError);
        }
    });
};

module.exports = it_should_return_error_given_program;


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

var should = require('should');
var nodeTester = require(__dirname + '/node-tester');

var it_should_return_error_given_program = function (expectedError, line, column, program) {
    it('should return error ' + expectedError + ' at line ' + line + ' column ' + column + ' given ' + program, function (done) {
        var threw = false;

        nodeTester.evaluateExpressionWithProgram(undefined, program, function (error, result) {
            if (error) {
                error.error.should.equal(expectedError);
                error.line.should.equal(line);
                error.column.should.equal(column);
                threw = true;
            }

            if (!threw) {
                throw new Error("Expected to return error " + expectedError);
            }

            done();
        });
    });
};

module.exports = it_should_return_error_given_program;

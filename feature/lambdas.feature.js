
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
var should = require('should');
var reuse = require('../lib/reuse.js');

var TEST_MODULE = __dirname + '/lambda-test-module.js';

var it_should_evaluate_expression_to_value_given_program = function (expression, expected, program) {
    it('should evaluate ' + expression + ' to ' + JSON.stringify(expected) + ' given ' + program, function () {
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
        'module.identity(3)',
        3,
        '(export identity (lambda (x) x))'
    );
});

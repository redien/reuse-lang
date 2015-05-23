
// reuse-lang - a pure functional lisp-like language for writing
// reusable business-logic in an extremely portable way.
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
var interpreter = require('../lib/interpreter');
var ast = require('../lib/ast-builder');

describe('interpreter', function () {
    describe('evaluate', function () {
        it('should evaluate 3 to 3', function () {
            var parsedProgram = ast('3');

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(3);
        });

        it('should evaluate -5 to -5', function () {
            var parsedProgram = ast('-5');

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(-5);
        });

        it('should evaluate () to []', function () {
            var parsedProgram = ast([]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.be.Array;
            result.value.length.should.equal(0);
        });

        it('should evaluate (list 1 ()) to [1, []]', function () {
            var parsedProgram = ast(['list', '1', []]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.be.Array;
            result.value.length.should.equal(2);
            result.value[0].should.equal(1);
            result.value[1].should.be.Array;
            result.value[1].length.should.equal(0);
        });

        it('should evaluate (list 2 (list 3 ())) to [2, [3, []]]', function () {
            var parsedProgram = ast(['list', '2', ['list', '3', []]]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.be.Array;
            result.value.length.should.equal(2);
            result.value[0].should.equal(2);
            result.value[1].should.be.Array;
            result.value[1].length.should.equal(2);
            result.value[1][0].should.equal(3);
            result.value[1][1].should.be.Array;
            result.value[1][1].length.should.equal(0);
        });

        it('should evaluate (head ()) []', function () {
            var parsedProgram = ast(['head', []]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.be.Array;
            result.value.length.should.equal(0);
        });

        it('should evaluate ((lambda () 1)) to 1', function () {
            var parsedProgram = ast([['lambda', [], '1']]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(1);
        });

        it('should evaluate ((lambda () ())) to []', function () {
            var parsedProgram = ast([['lambda', [], []]]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.be.Array;
            result.value.length.should.equal(0);
        });

        it('should evaluate ((lambda (x) x) 42) to 42', function () {
            var parsedProgram = ast([['lambda', ['x'], 'x'], '42']);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(42);
        });

        it('should evaluate ((lambda (x) x) ()) to []', function () {
            var parsedProgram = ast([['lambda', ['x'], 'x'], []]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.be.Array;
            result.value.length.should.equal(0);
        });

        it('should evaluate ((lambda (x y) y) () 2) to 2', function () {
            var parsedProgram = ast([['lambda', ['x', 'y'], 'y'], [], '2']);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(2);
        });

        it('should evaluate ((lambda (x y) x) () 2) to []', function () {
            var parsedProgram = ast([['lambda', ['x', 'y'], 'x'], [], '2']);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.be.Array;
            result.value.length.should.equal(0);
        });

        it('should evaluate (((lambda (x) (lambda () x)) 7)) to 7', function () {
            var parsedProgram = ast([[['lambda', ['x'], ['lambda', [], 'x']], '7']]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(7);
        });

        it('should evaluate (((lambda (x) x) (lambda (x) x)) 7) to 7', function () {
            var parsedProgram = ast([[['lambda', ['x'], 'x'], ['lambda', ['x'], 'x']], '7']);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(7);
        });

        it('should evaluate ((lambda (x) (x 42)) (lambda (x) x)) to 42', function () {
            var parsedProgram = ast([['lambda', ['x'], ['x', '42']], ['lambda', ['x'], 'x']]);

            var result = interpreter.evaluate(parsedProgram);
            result.value.should.equal(42);
        });
    });
});

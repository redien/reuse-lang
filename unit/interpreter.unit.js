
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

describe('interpreter', function () {
    describe('evaluate', function () {
        it('should evaluate 3 to 3', function (done) {
            var parsedProgram = {kind: 'atom', value: '3'};
            
            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(3);
                return done();
            });
        });

        it('should evaluate -5 to -5', function (done) {
            var parsedProgram = {kind: 'atom', value: '-5'};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(-5);
                return done();
            });
        });

        it('should evaluate () to []', function (done) {
            var parsedProgram = {kind: 'list', elements: []};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });

        it('should evaluate (list 1 ()) to [1, []]', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'list'},
                    {kind: 'atom', value: '1'},
                    {kind: 'list', elements: []}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(2);
                value[0].should.equal(1);
                value[1].should.be.Array;
                value[1].length.should.equal(0);
                return done();
            });
        });

        it('should evaluate (list 2 (list 3 ())) to [2, [3, []]]', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'list'},
                    {kind: 'atom', value: '2'},
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'list'},
                        {kind: 'atom', value: '3'},
                        {kind: 'list', elements: []}
                    ]}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(2);
                value[0].should.equal(2);
                value[1].should.be.Array;
                value[1].length.should.equal(2);
                value[1][0].should.equal(3);
                value[1][1].should.be.Array;
                value[1][1].length.should.equal(0);
                return done();
            });
        });

        it('should evaluate (head ()) []', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'head'},
                    {kind: 'list', elements: []}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });

        it('should evaluate ((lambda () 1)) to 1', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: []},
                        {kind: 'atom', value: '1'}
                    ]}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(1);
                return done();
            });
        });

        it('should evaluate ((lambda () ())) to []', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: []},
                        {kind: 'list', elements: []}
                    ]}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });

        it('should evaluate ((lambda (x) x) 42) to 42', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'}
                        ]},
                        {kind: 'atom', value: 'x'}
                    ]},
                    {kind: 'atom', value: '42'}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(42);
                return done();
            });
        });

        it('should evaluate ((lambda (x) x) ()) to []', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'}
                        ]},
                        {kind: 'atom', value: 'x'}
                    ]},
                    {kind: 'list', elements: []}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });

        it('should evaluate ((lambda (x y) y) () 2) to 2', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'},
                            {kind: 'atom', value: 'y'}
                        ]},
                        {kind: 'atom', value: 'y'}
                    ]},
                    {kind: 'list', elements: []},
                    {kind: 'atom', value: '2'}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(2);
                return done();
            });
        });

        it('should evaluate ((lambda (x y) x) () 2) to []', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'},
                            {kind: 'atom', value: 'y'}
                        ]},
                        {kind: 'atom', value: 'x'}
                    ]},
                    {kind: 'list', elements: []},
                    {kind: 'atom', value: '2'}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });

        it('should evaluate (((lambda (x) (lambda () x)) 7)) to 7', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'x'}
                            ]},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'lambda'},
                                {kind: 'list', elements: []},
                                {kind: 'atom', value: 'x'}
                            ]}
                        ]},
                        {kind: 'atom', value: '7'}
                    ]}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(7);
                return done();
            });
        });

        it('should evaluate (((lambda (x) x) (lambda (x) x)) 7) to 7', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'x'}
                            ]},
                            {kind: 'atom', value: 'x'}
                        ]},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'x'}
                            ]},
                            {kind: 'atom', value: 'x'}
                        ]}
                    ]},
                    {kind: 'atom', value: '7'}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(7);
                return done();
            });
        });

        it('should evaluate ((lambda (x) (x 42)) (lambda (x) x)) to 42', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'}
                        ]},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'},
                            {kind: 'atom', value: '42'}
                        ]}
                    ]},
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'}
                        ]},
                        {kind: 'atom', value: 'x'},
                    ]},
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(42);
                return done();
            });
        });
    });
});

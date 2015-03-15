
var should = require('should');
var interpreter = require('../lib/interpreter');

describe('interpreter', function () {
    describe('evaluate', function () {
        it('should evaluate {kind: "atom", value: "3"} to 3', function (done) {
            var parsedProgram = {
                kind: 'atom',
                value: '3'
            };
            
            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(3);
                return done();
            });
        });

        it('should evaluate {kind: "atom", value: "-5"} to -5', function (done) {
            var parsedProgram = {
                kind: 'atom',
                value: '-5'
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(-5);
                return done();
            });
        });

        it('should evaluate () to null', function (done) {
            var parsedProgram = {
                kind: 'list',
                elements: []
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                should(value).be.null;
                return done();
            });
        });

        it('should evaluate ((lambda () 1)) to 1', function (done) {
            var parsedProgram = {
                kind: 'list',
                elements: [
                    {
                        kind: 'list',
                        elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: []},
                            {kind: 'atom', value: '1'}
                        ]
                    }
                ]
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(1);
                return done();
            });
        });

        it('should evaluate ((lambda () ())) to null', function (done) {
            var parsedProgram = {
                kind: 'list',
                elements: [
                    {
                        kind: 'list',
                        elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: []},
                            {kind: 'list', elements: []}
                        ]
                    }
                ]
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                should(value).be.null;
                return done();
            });
        });

        it('should evaluate ((lambda (x) x) 42) to 42', function (done) {
            var parsedProgram = {
                kind: 'list',
                elements: [
                    {
                        kind: 'list',
                        elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'x'}
                            ]},
                            {kind: 'atom', value: 'x'}
                        ]
                    },
                    {kind: 'atom', value: '42'}
                ]
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(42);
                return done();
            });
        });

        it('should evaluate ((lambda (x) x) ()) to null', function (done) {
            var parsedProgram = {
                kind: 'list',
                elements: [
                    {
                        kind: 'list',
                        elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'x'}
                            ]},
                            {kind: 'atom', value: 'x'}
                        ]
                    },
                    {kind: 'list', elements: []}
                ]
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                should(value).be.null;
                return done();
            });
        });

        it('should evaluate ((lambda (x y) y) () 2) to 2', function (done) {
            var parsedProgram = {
                kind: 'list',
                elements: [
                    {
                        kind: 'list',
                        elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'x'},
                                {kind: 'atom', value: 'y'}
                            ]},
                            {kind: 'atom', value: 'y'}
                        ]
                    },
                    {kind: 'list', elements: []},
                    {kind: 'atom', value: '2'}
                ]
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.equal(2);
                return done();
            });
        });

        it('should evaluate ((lambda (x y) x) () 2) to null', function (done) {
            var parsedProgram = {
                kind: 'list',
                elements: [
                    {
                        kind: 'list',
                        elements: [
                            {kind: 'atom', value: 'lambda'},
                            {kind: 'list', elements: [
                                {kind: 'atom', value: 'x'},
                                {kind: 'atom', value: 'y'}
                            ]},
                            {kind: 'atom', value: 'x'}
                        ]
                    },
                    {kind: 'list', elements: []},
                    {kind: 'atom', value: '2'}
                ]
            };

            interpreter.evaluate(parsedProgram, function (error, value) {
                should(value).be.null;
                return done();
            });
        });
    });
});

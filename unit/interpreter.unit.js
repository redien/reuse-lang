
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

        it('should evaluate () to null', function (done) {
            var parsedProgram = {kind: 'list', elements: []};

            interpreter.evaluate(parsedProgram, function (error, value) {
                should(value).be.null;
                return done();
            });
        });

        it('should evaluate (tuple 1 ()) to [1, null]', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'tuple'},
                    {kind: 'atom', value: '1'},
                    {kind: 'list', elements: []}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(2);
                value[0].should.equal(1);
                should(value[1]).be.null;
                return done();
            });
        });

        it('should evaluate (tuple 2 (tuple 3 ())) to [2, [3, null]]', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'tuple'},
                    {kind: 'atom', value: '2'},
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'tuple'},
                        {kind: 'atom', value: '3'},
                        {kind: 'list', elements: []}
                    ]}
                ]};

            debugger;
            interpreter.evaluate(parsedProgram, function (error, value) {
                value.should.be.Array;
                value.length.should.equal(2);
                value[0].should.equal(2);
                value[1].should.be.Array;
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

        it('should evaluate ((lambda () ())) to null', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: []},
                        {kind: 'list', elements: []}
                    ]}
                ]};

            interpreter.evaluate(parsedProgram, function (error, value) {
                should(value).be.null;
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

        it('should evaluate ((lambda (x) x) ()) to null', function (done) {
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
                should(value).be.null;
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

        it('should evaluate ((lambda (x y) x) () 2) to null', function (done) {
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
                should(value).be.null;
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
    });
});

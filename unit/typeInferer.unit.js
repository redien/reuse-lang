
var should = require('should');
var typeInferer = require('../lib/typeInferer');

describe('typeInferer', function () {
    describe('infer', function () {
        it('should return atoms of only digits with type int32', function () {
            var parsedProgram = {
                kind: 'atom',
                value: '123'
            };

            var typedProgram = typeInferer.infer(parsedProgram);

            typedProgram.type.should.equal('int32');
            typedProgram.should.match(parsedProgram);
        });

        it('should return atoms of only digits prepended with a dash with type int32', function () {
            var parsedProgram = {
                kind: 'atom',
                value: '-321'
            };
            var typedProgram = typeInferer.infer(parsedProgram);

            typedProgram.type.should.equal('int32');
            typedProgram.should.match(parsedProgram);
        });

        it('should return () with type ()', function () {
            var parsedProgram = {
                kind: 'list',
                elements: []
            };
            var typedProgram = typeInferer.infer(parsedProgram);

            typedProgram.type.should.equal('()');
            typedProgram.should.match(parsedProgram);
        });

        it('should return (tuple 123 321) with type (int32 int32)', function () {
            var parsedProgram = {
                kind: 'list',
                elements: []
            };
            var typedProgram = typeInferer.infer(parsedProgram);

            typedProgram.type.should.equal('()');
            typedProgram.should.match(parsedProgram);
        });

        it('should return ((lambda () 1)) with type int32', function () {
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
            var typedProgram = typeInferer.infer(parsedProgram);

            typedProgram.type.should.equal('int32');
            typedProgram.should.match(parsedProgram);
        });

        it('should return ((lambda () ())) with type ()', function () {
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
            var typedProgram = typeInferer.infer(parsedProgram);

            typedProgram.type.should.equal('()');
            typedProgram.should.match(parsedProgram);
        });
    });
});

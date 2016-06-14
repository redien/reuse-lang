
var should = require('should');
var translator = require('./translator');
var Immutable = require('immutable');

var input, result;

describe('javascript translator', function () {
    describe('translate', function () {
        describe('integer arithmetic', function () {
            it('should translate (+ a b) into a + b', function () {
                input = Immutable.List(['+', 'a', 'b']);

                result = translator.translate(input);

                result.should.equal('a + b');
            });

            it('should translate (+ 1 2) into 1 + 2', function () {
                input = Immutable.List(['+', '1', '2']);

                result = translator.translate(input);

                result.should.equal('1 + 2');
            });

            it('should translate (* 1 2) into 1 * 2', function () {
                input = Immutable.List(['*', '1', '2']);

                result = translator.translate(input);

                result.should.equal('1 * 2');
            });

            it('should translate (* 1 (+ 2 3)) into 1 * (2 + 3)', function () {
                input = Immutable.List.of('*', '1', Immutable.List.of('+', '2', '3'));

                result = translator.translate(input);

                result.should.equal('1 * (2 + 3)');
            });

            it('should translate (* (+ 1 2) (- 3 4)) into (1 + 2) * (3 - 4)', function () {
                input = Immutable.List.of('*', Immutable.List.of('+', '1', '2'), Immutable.List.of('-', '3', '4'));

                result = translator.translate(input);

                result.should.equal('(1 + 2) * (3 - 4)');
            });

            it('should Math.floor division results', function () {
                input = Immutable.List(['/', 'a', 'b']);

                result = translator.translate(input);

                result.should.equal('Math.floor(a / b)');
            });
        });

        describe('Function application', function () {
            it('should translate (f a b) into f(a, b)', function () {
                input = Immutable.List.of('f', 'a', 'b');

                result = translator.translate(input);

                result.should.equal('f(a, b)');
            });
        });
    });
});

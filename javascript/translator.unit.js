
var should = require('should');
var translator = require('./translator');
var Immutable = require('immutable');

var input, result;

describe('translator', function () {
    describe('translate', function () {
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
    });
});


var should = require('should');
var Immutable = require('immutable');

var parser = require('./parser');

describe('parser', function () {
    describe('parse', function () {
        it('should parse a single-character atom', function () {
            var input = '1';

            var result = parser.parse(input);

            result.should.equal('1');
        });

        it('should parse a multi-character atom', function () {
            var input = 'ab';

            var result = parser.parse(input);

            result.should.equal('ab');
        });

        it('should parse an empty list', function () {
            var input = '()';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(0);
        });

        it('should parse a list with a single atom', function () {
            var input = '(a)';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(1);
            result.get(0).should.equal('a');
        });

        it('should parse a list with a multiple atoms', function () {
            var input = '(a b)';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(2);
            result.get(0).should.equal('a');
            result.get(1).should.equal('b');
        });

        it('should parse an empty list within a list', function () {
            var input = '(())';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(1);
            result.get(0).should.be.instanceOf(Immutable.List);
            result.get(0).size.should.equal(0);
        });

        it('should parse a list with multiple atoms within a list', function () {
            var input = '((a b))';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(1);
            result.get(0).should.be.instanceOf(Immutable.List);
            result.get(0).size.should.equal(2);
            result.get(0).get(0).should.equal('a');
            result.get(0).get(1).should.equal('b');
        });

        it('should parse an atom after a list', function () {
            var input = '(() a)';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(2);
            result.get(0).should.be.instanceOf(Immutable.List);
            result.get(0).size.should.equal(0);
            result.get(1).should.equal('a');
        });

        it('should parse two lists within a list', function () {
            var input = '((a) (b))';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(2);
            result.get(0).should.be.instanceOf(Immutable.List);
            result.get(0).size.should.equal(1);
            result.get(0).get(0).should.equal('a');
            result.get(1).should.be.instanceOf(Immutable.List);
            result.get(1).size.should.equal(1);
            result.get(1).get(0).should.equal('b');
        });

        it('should ignore extra leading whitespace', function () {
            var input = '   a';

            var result = parser.parse(input);

            result.should.equal('a');
        });

        it('should ignore extra trailing whitespace', function () {
            var input = '(a  )';

            var result = parser.parse(input);

            result.should.be.instanceOf(Immutable.List);
            result.size.should.equal(1);
            result.get(0).should.equal('a');
        });
    });
});


var should = require('should');
var Immutable = require('immutable');

var parser = require('./parser');

var parseSingleExpression = function (input) {
    var result = parser.parse(input);
    result.ast.should.be.an.instanceOf(Immutable.List);
    result.ast.size.should.equal(1);
    return result.ast.get(0);
};

var parseAndExpectError = function (input) {
    var result = parser.parse(input);
    result.error.should.be.an.instanceOf(Error);
    return result.error;
};

describe('parser.parse', function () {
    it('should parse a single-character atom', function () {
        var input = '1';

        var expression = parseSingleExpression(input);

        expression.should.equal('1');
    });

    it('should parse a multi-character atom', function () {
        var input = 'ab';

        var expression = parseSingleExpression(input);

        expression.should.equal('ab');
    });

    it('should parse several expressions', function () {
        var input = 'a b';

        var result = parser.parse(input).ast;

        result.should.be.an.instanceOf(Immutable.List);
        result.size.should.equal(2);
        result.get(0).should.equal('a');
        result.get(1).should.equal('b');
    });

    it('should parse an empty list', function () {
        var input = '()';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(0);
    });

    it('should parse a list with a single atom', function () {
        var input = '(a)';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(1);
        expression.get(0).should.equal('a');
    });

    it('should parse a list with a multiple atoms', function () {
        var input = '(a b)';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(2);
        expression.get(0).should.equal('a');
        expression.get(1).should.equal('b');
    });

    it('should parse an empty list within a list', function () {
        var input = '(())';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(1);
        expression.get(0).should.be.instanceOf(Immutable.List);
        expression.get(0).size.should.equal(0);
    });

    it('should parse a list with multiple atoms within a list', function () {
        var input = '((a b))';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(1);
        expression.get(0).should.be.instanceOf(Immutable.List);
        expression.get(0).size.should.equal(2);
        expression.get(0).get(0).should.equal('a');
        expression.get(0).get(1).should.equal('b');
    });

    it('should parse an atom after a list', function () {
        var input = '(() a)';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(2);
        expression.get(0).should.be.instanceOf(Immutable.List);
        expression.get(0).size.should.equal(0);
        expression.get(1).should.equal('a');
    });

    it('should parse two lists within a list', function () {
        var input = '((a) (b))';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(2);
        expression.get(0).should.be.instanceOf(Immutable.List);
        expression.get(0).size.should.equal(1);
        expression.get(0).get(0).should.equal('a');
        expression.get(1).should.be.instanceOf(Immutable.List);
        expression.get(1).size.should.equal(1);
        expression.get(1).get(0).should.equal('b');
    });

    it('should ignore extra leading whitespace', function () {
        var input = '   a';

        var expression = parseSingleExpression(input);

        expression.should.equal('a');
    });

    it('should ignore extra trailing whitespace', function () {
        var input = '(a  )';

        var expression = parseSingleExpression(input);

        expression.should.be.instanceOf(Immutable.List);
        expression.size.should.equal(1);
        expression.get(0).should.equal('a');
    });

    it('should throw an "Unbalanced parenthesis" error given too few end parenthesis', function () {
        var input = '(a b c';

        var error = parseAndExpectError(input);

        error.message.should.equal('Unbalanced parenthesis');
        error.column.should.equal(6);
        error.line.should.equal(0);
    });

    it('should throw an "Unbalanced parenthesis" error given too few start parenthesis', function () {
        var input = 'a b c)';

        var error = parseAndExpectError(input);

        error.message.should.equal('Unbalanced parenthesis');
        error.column.should.equal(5);
        error.line.should.equal(0);
    });
});

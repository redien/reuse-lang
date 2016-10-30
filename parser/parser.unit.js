
var should = require('should');
var ast = require('./ast');

var parser = require('./parser');

var parseSingleExpression = function (input) {
    var result = parser.parse(input);
    ast.isList(result.ast).should.be.true();
    ast.listSize(result.ast).should.equal(1);
    return ast.listChild(result.ast, 0);
};

var parseLocationInformation = function (input) {
    var result = parser.parse(input);
    return result.locationInformation.get(0);
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

        ast.atomValue(expression).should.equal('1');
    });

    it('should parse a multi-character atom', function () {
        var input = 'ab';

        var expression = parseSingleExpression(input);

        ast.atomValue(expression).should.equal('ab');
    });

    it('should parse several expressions', function () {
        var input = 'a b';

        var result = parser.parse(input).ast;

        ast.isList(result).should.be.true();
        ast.listSize(result).should.equal(2);
        ast.atomValue(ast.listChild(result, 0)).should.equal('a');
        ast.atomValue(ast.listChild(result, 1)).should.equal('b');
    });

    it('should parse an empty list', function () {
        var input = '()';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(0);
    });

    it('should parse a list with a single atom', function () {
        var input = '(a)';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(1);
        ast.atomValue(ast.listChild(expression, 0)).should.equal('a');
    });

    it('should parse a list with a multiple atoms', function () {
        var input = '(a b)';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(2);
        ast.atomValue(ast.listChild(expression, 0)).should.equal('a');
        ast.atomValue(ast.listChild(expression, 1)).should.equal('b');
    });

    it('should parse an empty list within a list', function () {
        var input = '(())';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(1);
        ast.isList(ast.listChild(expression, 0)).should.be.true();
        ast.listSize(ast.listChild(expression, 0)).should.equal(0);
    });

    it('should parse a list with multiple atoms within a list', function () {
        var input = '((a b))';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(1);
        ast.isList(ast.listChild(expression, 0)).should.be.true();
        ast.listSize(ast.listChild(expression, 0)).should.equal(2);
        ast.atomValue(ast.listChild(ast.listChild(expression, 0), 0)).should.equal('a');
        ast.atomValue(ast.listChild(ast.listChild(expression, 0), 1)).should.equal('b');
    });

    it('should parse an atom after a list', function () {
        var input = '(() a)';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(2);
        ast.isList(ast.listChild(expression, 0)).should.be.true();
        ast.listSize(ast.listChild(expression, 0)).should.equal(0);
        ast.atomValue(ast.listChild(expression, 1)).should.equal('a');
    });

    it('should parse two lists within a list', function () {
        var input = '((a) (b))';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(2);
        ast.isList(ast.listChild(expression, 0)).should.be.true();
        ast.listSize(ast.listChild(expression, 0)).should.equal(1);
        ast.atomValue(ast.listChild(ast.listChild(expression, 0), 0)).should.equal('a');
        ast.isList(ast.listChild(expression, 1)).should.be.true();
        ast.listSize(ast.listChild(expression, 1)).should.equal(1);
        ast.atomValue(ast.listChild(ast.listChild(expression, 1), 0)).should.equal('b');
    });

    it('should ignore extra leading whitespace', function () {
        var input = '   a';

        var expression = parseSingleExpression(input);

        ast.atomValue(expression).should.equal('a');
    });

    it('should ignore extra trailing whitespace', function () {
        var input = '(a  )';

        var expression = parseSingleExpression(input);

        ast.isList(expression).should.be.true();
        ast.listSize(expression).should.equal(1);
        ast.atomValue(ast.listChild(expression, 0)).should.equal('a');
    });

    // TODO: Replace column/row information with index as column/row can be
    // calculated given the input string and an index.
    describe('Errors', function () {
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

    describe('Location information', function () {
        it('should return range for atom', function () {
            var input = 'a';

            var context = parseLocationInformation(input);

            context.range.should.deepEqual([0, 1]);
        });

        it('should return range for long atom', function () {
            var input = 'abcdefg';

            var context = parseLocationInformation(input);

            context.range.should.deepEqual([0, 7]);
        });

        it('should return range for list', function () {
            var input = '(a)';

            var context = parseLocationInformation(input);

            context.range.should.deepEqual([0, 3]);
        });

        it('should return range for atom in list', function () {
            var input = '(a)';

            var context = parseLocationInformation(input);

            context.get(0).range.should.deepEqual([1, 1]);
        });

        it('should return range for deeply nested atom', function () {
            var input = '(a (b ((c) d e)))';

            var context = parseLocationInformation(input);

            context.get(1).get(1).get(0).get(0).range.should.deepEqual([8, 1]);
        });

        it('should return range for deeply nested list', function () {
            var input = '(a (b ((c) d e)))';

            var context = parseLocationInformation(input);

            context.get(1).get(1).range.should.deepEqual([6, 9]);
        });
    });
});

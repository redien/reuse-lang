
var Immutable = require('immutable');
var should = require('should');
var ast = require('./ast');
var unifyAst = require('./unify-ast');
var variable = unifyAst.variable;

describe('unifyAst', function () {
    it('should unify with {} given two identical atoms', function () {
        var first = ast.atom('a');
        var second = ast.atom('a');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(0);
    });

    it('should not unify given two different atoms', function () {
        var first = ast.atom('a');
        var second = ast.atom('b');

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should unify with {a: ...} given a variable "a" and an AST', function () {
        var first = variable('a');
        var second = ast.atom('_');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('a')).should.be.true();
        ast.atomValue(output.get('a')).should.equal('_');
    });

    it('should unify with {b: ...} given an AST and a variable "b"', function () {
        var first = ast.atom('_');
        var second = variable('b');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('b')).should.be.true();
        ast.atomValue(output.get('b')).should.equal('_');
    });

    it('should unify with {1: ...} given a variable "1" and an AST', function () {
        var first = variable('1');
        var second = ast.atom('_');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('1')).should.be.true();
        ast.atomValue(output.get('1')).should.equal('_');
    });

    it('should unify with {2: ...} given an AST and a variable "2"', function () {
        var first = ast.atom('_');
        var second = variable('2');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('2')).should.be.true();
        ast.atomValue(output.get('2')).should.equal('_');
    });

    it('should unify with {...: "1"} given an atom "1" and a variable', function () {
        var first = ast.atom('1');
        var second = variable('_');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('_')).should.be.true();
        ast.atomValue(output.get('_')).should.equal('1');
    });

    it('should unify with {...: "2"} given a variable and an atom "2"', function () {
        var first = variable('_');
        var second = ast.atom('2');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('_')).should.be.true();
        ast.atomValue(output.get('_')).should.equal('2');
    });

    it('should not unify given two variables', function () {
        var first = variable('a');
        var second = variable('b');

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should unify with {} given two identical lists', function () {
        var first = ast.list(ast.atom('a'));
        var second = ast.list(ast.atom('a'));

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(0);
    });

    it('should not unify given an atom and a list', function () {
        var first = ast.atom('a');
        var second = ast.list();

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should not unify given a list and an atom', function () {
        var first = ast.list();
        var second = ast.atom('a');

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should not unify given two lists of different sizes', function () {
        var first = ast.list(ast.atom('a'));
        var second = ast.list(ast.atom('a'), ast.atom('b'));

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should unify with {a: ...} given a list with a variable and a list with an AST', function () {
        var first = ast.list(variable('a'));
        var second = ast.list(ast.atom('_'));

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('a')).should.be.true();
        ast.atomValue(output.get('a')).should.equal('_');
    });

    it('should unify with {a: ..., b: ...} given a list with two variables "a" and "b" and a list with two ASTs', function () {
        var first = ast.list(variable('a'), variable('b'));
        var second = ast.list(ast.atom('1'), ast.atom('2'));

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(2);
        ast.isAtom(output.get('a')).should.be.true();
        ast.atomValue(output.get('a')).should.equal('1');
        ast.isAtom(output.get('b')).should.be.true();
        ast.atomValue(output.get('b')).should.equal('2');
    });

    it('should unify with {a: atom, b: atom} given (atom, a) and (b, atom)', function () {
        var first = ast.list(variable('a'), ast.atom('2'));
        var second = ast.list(ast.atom('1'), variable('b'));

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(2);
        ast.isAtom(output.get('a')).should.be.true();
        ast.atomValue(output.get('a')).should.equal('1');
        ast.isAtom(output.get('b')).should.be.true();
        ast.atomValue(output.get('b')).should.equal('2');
    });

    it('should unify two deeply nested ASTs', function () {
        var first = ast.list(ast.list(ast.atom('1'), ast.atom('2')), ast.atom('3'), ast.list());
        var second = ast.list(ast.list(variable('a'), ast.atom('2')), variable('b'), ast.list());

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(2);
        ast.isAtom(output.get('a')).should.be.true();
        ast.atomValue(output.get('a')).should.equal('1');
        ast.isAtom(output.get('b')).should.be.true();
        ast.atomValue(output.get('b')).should.equal('3');
    });

    it('should throw an error given two variables with the same name', function () {
        var first = ast.list(variable('a'), variable('a'));
        var second = ast.list(ast.atom('1'), ast.atom('2'));

        should.throws(() => unifyAst(first, second));
    });

    it('should unify with {a: ...} given a variable "a" with kind "atom" and an atom', function () {
        var first = variable('a', 'atom');
        var second = ast.atom('_');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('a')).should.be.true();
        ast.atomValue(output.get('a')).should.equal('_');
    });

    it('should not unify given a variable "a" with kind "atom" and a list', function () {
        var first = variable('a', 'atom');
        var second = ast.list();

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should unify with {b: ...} given an atom and a variable "b" with kind "atom"', function () {
        var first = ast.atom('_');
        var second = variable('a', 'atom');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isAtom(output.get('a')).should.be.true();
        ast.atomValue(output.get('a')).should.equal('_');
    });

    it('should not unify given a list and a variable "a" with kind "atom"', function () {
        var first = ast.list();
        var second = variable('a', 'atom');

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should unify with {a: ...} given a variable "a" with kind "list" and a list', function () {
        var first = variable('a', 'list');
        var second = ast.list();

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isList(output.get('a')).should.be.true();
    });

    it('should not unify given a variable "a" with kind "list" and an atom', function () {
        var first = variable('a', 'list');
        var second = ast.atom('b');

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });

    it('should unify with {a: ...} given a list and a variable "a" with kind "list"', function () {
        var first = ast.list();
        var second = variable('a', 'list');

        var output = unifyAst(first, second);

        output.should.be.an.instanceOf(Immutable.Map);
        output.size.should.equal(1);
        ast.isList(output.get('a')).should.be.true();
    });

    it('should not unify given an atom and a variable "a" with kind "list"', function () {
        var first = ast.atom('b');
        var second = variable('a', 'list');

        var output = unifyAst(first, second);

        output.should.equal(unifyAst.NOT_UNIFIED);
    });
});

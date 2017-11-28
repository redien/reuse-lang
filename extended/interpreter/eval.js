
const first = (list) => list[1];
const rest = (list) => list[2];

function reduce (reducer, initial, list) {
    if (list === 'Empty') {
        return initial;
    } else {
        return reducer(first(list), reduce(reducer, initial, rest(list)));
    }
}


const map = f => reduce.bind(null, (x, xs) => ['Cons', f(x), xs], 'Empty');

const toJsString = reduce.bind(null, (x, xs) => String.fromCharCode(x) + xs, '');

const equalToJsString = (expression, string) => {
    return string === toJsString(expression);
};

const apply = (lambda, _arguments) => {
    const parameters = first(lambda);
    const body = first(rest(lambda));

};

function _eval (expression, context) {
    if (expression[0] === 'List') {
        const evaluated = map(_eval, expression[1]);
        const lambda = first(evaluated);
        const _arguments = rest(evaluated);
        return apply(lambda, _arguments);
    } else if (expression[0] === 'Atom') {
        return { value: context(expression[1]), context };
    } else {
        throw new Error('Expected List or Atom but got ' + expression[0]);
    }
};

module.exports.interpret = (programSource, expressionSource, initialContext) => {
    const parser = require('../../parser/bootstrap/parser');
    const ast = require('../../parser/bootstrap/ast');

    const parsedProgram = parser.parse(programSource).ast;
    const parsedExpression = ast.child(parser.parse(expressionSource).ast, 0);

    function toList(expression) {
        const reducer = (xs, x) => ['Cons', toList(x), xs];
        const empty = 'Empty';
        if (ast.isList(expression)) {
            return ['List', ast.reduce(ast.reverse(expression), reducer, empty)];
        } else if (Array.isArray(expression)) {
            return expression.reverse().reduce(reducer, empty);
        } else if (ast.isAtom(expression)) {
            return ['Atom', toList(ast.value(expression).split('').map(s => s.charCodeAt(0)))];
        } else {
            return expression;
        }
    }

    const program = toList(parsedProgram);
    const expression = toList(parsedExpression);

    const { context } = _eval(program, (symbol) => initialContext(toJsString(symbol)));
    const { value } = _eval(expression, context);
    return value;
};


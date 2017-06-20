var fs = require('fs');
var ast = require(__dirname + '/../../parser/ast');
var parser = require(__dirname + '/../../parser/parser');

function newSymbol(state) {
    state.counter += 1;
    return ast.atom('anonymous' + state.counter);
}

function translateExpression(state, expression) {
    if (ast.isList(expression) && ast.size(expression) > 0) {
        const first = ast.child(expression, 0);

        if (ast.isAtom(first) && ast.value(first) === 'fun') {
            let definition = ast.setIn(expression, [0], ast.atom('def'));
            const name = newSymbol(state);
            definition = ast.insert(definition, 1, name);
            state.definitions.push(definition);
            return name;
        } else {
            return ast.map(expression, translateExpression.bind(null, state));
        }
    }
    return expression;
}

function translateFunction(state, definition) {
    return ast.updateIn(definition, [3], translateExpression.bind(null, state));
}

function translateDefinition(state, definition) {
    var type = ast.value(ast.child(definition, 0));
    if (type === 'def') {
        state.definitions.push(translateFunction(state, definition));
    } else {
        state.definitions.push(definition);
    }
}

function rewriteModule(state, definitions) {
    ast.map(definitions, translateDefinition.bind(null, state));
    return ast.listFrom(state.definitions);
}

var input = fs.readFileSync(process.argv[2], 'utf8');
var expressions = parser.parse(input).ast;
var rewrittenExpression = rewriteModule({ definitions: [], counter: 0 }, expressions);
var output = ast.join(ast.map(rewrittenExpression, ast.toString), ' ');
fs.writeFileSync(process.argv[3], output, 'utf8');

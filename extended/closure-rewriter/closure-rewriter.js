var fs = require('fs');
var ast = require(__dirname + '/../../parser/ast');
var parser = require(__dirname + '/../../parser/parser');

function newSymbol(state) {
    state.counter += 1;
    return ast.atom('anonymous' + state.counter);
}

function constructorEqualsSymbol(symbol, constructor) {
    if (ast.isList(constructor)) {
        return ast.value(ast.child(constructor, 0)) === ast.value(symbol);
    } else {
        return ast.value(constructor) === ast.value(symbol);
    }
}

function symbolIsConstructor(state, symbol) {
    return state.definitions.some(definition => ast.value(ast.child(definition, 0)) === 'data' && ast.some(ast.slice(definition, 2), constructorEqualsSymbol.bind(null, symbol)));
}

function symbolIsFunction(state, symbol) {
    return state.definitions.some(definition => ast.value(ast.child(definition, 0)) === 'def' && ast.value(ast.child(definition, 1)) === ast.value(symbol));
}

function findFunction(state, symbol) {
    return state.definitions.find(definition => ast.value(ast.child(definition, 0)) === 'def' && ast.value(ast.child(definition, 1)) === ast.value(symbol));
}

function isSpecialOperator(symbol) {
    return ast.value(symbol) === '+' || ast.value(symbol) === '-' || ast.value(symbol) === '*' || ast.value(symbol) === '/' || ast.value(symbol) === '%' || ast.value(symbol) === 'int32-compare';
}

function isCurrentFunction(state, symbol) {
    return ast.value(ast.child(state.currentFunction, 1)) === ast.value(symbol);
}

function translateExpression(state, expression) {
    if (ast.isList(expression) && ast.size(expression) > 0) {
        const first = ast.child(expression, 0);

        if (ast.isAtom(first) && ast.value(first) === 'fun') {
            const args = ast.child(expression, 1);
            const name = newSymbol(state);

            let definition = ast.setIn(expression, [0], ast.atom('def'));
            definition = ast.setIn(definition, [1], ast.insert(args, 0, ast.atom('_')));
            definition = ast.insert(definition, 1, name);
            state.definitions.push(definition);

            return ast.list(ast.atom('Closure' + ast.size(args)), name, ast.atom('0'));
        } else if (ast.isAtom(first) && ast.value(first) === 'match') {
            let match = ast.updateIn(expression, [1], translateExpression.bind(null, state));
            for (let i = 2; i < ast.size(expression); i += 2) {
                match = ast.updateIn(match, [i + 1], translateExpression.bind(null, state));
            }
            return match;
        } else if (ast.isAtom(first) && isCurrentFunction(state, first)) {
            const args = ast.map(ast.slice(expression, 1), translateExpression.bind(null, state));
            let definition = ast.insert(args, 0, ast.atom('0'));
            definition = ast.insert(definition, 0, ast.child(expression, 0));
            return definition;
        } else if (ast.isAtom(first) && (isSpecialOperator(first) || symbolIsConstructor(state, first))) {
            const args = ast.map(ast.slice(expression, 1), translateExpression.bind(null, state));
            return ast.insert(args, 0, ast.child(expression, 0));
        } else {
            const args = ast.map(expression, translateExpression.bind(null, state));
            const argCount = ast.size(args) - 1;
            const apply = ast.atom('apply' + argCount);
            state.maxApply = Math.max(argCount, state.maxApply);
            return ast.insert(args, 0, apply);
        }
    } else if (ast.isAtom(expression) && symbolIsFunction(state, expression)) {
        const f = findFunction(state, expression);
        const args = ast.child(f, 2);
        return ast.list(ast.atom('Closure' + (ast.size(args) - 1)), expression, ast.atom('0'));
    }
    return expression;
}

function translateFunction(state, definition) {
    state.currentFunction = definition;
    const args = ast.child(definition, 2);
    definition = ast.setIn(definition, [2], ast.insert(args, 0, ast.atom('_')));
    return ast.updateIn(definition, [3], translateExpression.bind(null, state));
}

function translateType(state, type) {
    if (ast.isList(type) && ast.value(ast.child(type, 0)) === 'fun') {
        const parameterTypes = ast.map(ast.child(type, 1), translateType.bind(null, state));
        const returnType = translateType(state, ast.child(type, 2));
        return ast.concat(ast.list(ast.atom('closure' + ast.size(parameterTypes)), returnType), parameterTypes);
    } else if (ast.isList(type)) {
        const types = ast.map(ast.slice(type, 1), translateType.bind(null, state));
        return ast.concat(ast.slice(type, 0, 1), types);
    } else {
        return type;
    }
}

function translateDataConstructor(state, definition) {
    if (ast.isList(definition)) {
        const types = ast.map(ast.slice(definition, 1), translateType.bind(null, state));
        return ast.concat(ast.slice(definition, 0, 1), types);
    } else {
        return definition;
    }
}

function translateData(state, definition) {
    const cons = ast.map(ast.slice(definition, 2), translateDataConstructor.bind(null, state));
    return ast.concat(ast.slice(definition, 0, 2), cons);
}

function translateDefinition(state, definition) {
    var type = ast.value(ast.child(definition, 0));
    if (type === 'def') {
        state.definitions.push(translateFunction(state, definition));
    } else {
        state.definitions.push(translateData(state, definition));
    }
}

function args(count) {
    let array = [];
    for (let i = 0; i < count; ++i) {
        array.push('x' + i);
    }
    return array.join(' ');
}

function generateApplyFunction(argCount) {
    return ast.child(
        parser.parse(`
(def apply${argCount} (closure ${args(argCount)}) (match closure (Closure${argCount} f s) (f s ${args(argCount)})))
`).ast,
        0
    );
}

function generateClosureData(argCount) {
    return ast.child(
        parser.parse(`
(data (closure${argCount} a (exists s) ${args(argCount)}) (Closure${argCount} (fun (s ${args(argCount)}) a) s))
`).ast,
        0
    );
}

function generateClosures(state) {
    let applyDefinitions = ast.list();
    for (let i = 0; i <= state.maxApply; ++i) {
        applyDefinitions = ast.push(applyDefinitions, generateClosureData(i));
        applyDefinitions = ast.push(applyDefinitions, generateApplyFunction(i));
    }
    return applyDefinitions;
}

function rewriteModule(state, definitions) {
    ast.map(definitions, translateDefinition.bind(null, state));
    return ast.concat(generateClosures(state), ast.listFrom(state.definitions));
}

var input = fs.readFileSync(process.argv[2], 'utf8');
var expressions = parser.parse(input).ast;
var rewrittenExpression = rewriteModule({ definitions: [], counter: 0, maxApply: 0 }, expressions);
var output = ast.join(ast.map(rewrittenExpression, ast.toString), ' ');
fs.writeFileSync(process.argv[3], output, 'utf8');

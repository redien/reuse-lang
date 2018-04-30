
import { parse } from '../../../sexp-parser/bootstrap/parser';
import { isList, flatMap, some, concat, atom, list, filter, slice, child, size, isAtom, value, map, toString, toArray, getMeta } from '../../../sexp-parser/bootstrap/ast';
const assert = require('assert');
const util = require('util');

const stringifyValue = (value) => {
    if (Number.isInteger(value)) {
        return value.toString();
    } else if (value.type === 'constructor') {
        return value.name;
    } else if (isList(value)) {
        return '(' + toArray(map(value, stringifyValue)).join(' ') + ')';
    } else {
        return '!!!';
    }
};

const stringifyStackTrace = (stackTrace) => {
    const lines = [...stackTrace].map(s => '    ' + s);
    lines.reverse();
    return `
Stack trace:
${lines.join('\n')}
`;
};

const firstAtomValue = (expression) => value(child(expression, 0));
const secondAtomValue = (expression) => value(child(expression, 1));

const distanceToNewLine = (input, start) => {
    let index;

    for (index = start; index < input.length; index++) {
        if (input[index] == '\n')
            return index - start;
    }

    return index - start;
};

const showSexpLocation = (sexp) => {
    const input = getMeta(sexp, 'input');
    if (input == undefined)
        return '';

    const range = getMeta(sexp, 'range');
    const string = toString(sexp);
    const contextSizeLeft = 5;
    const contextSizeRight = distanceToNewLine(input, range[0] + range[1]);
    const context = input.slice(range[0] - contextSizeLeft, range[0] + range[1] + contextSizeRight);

    return `

${context}
${' '.repeat(contextSizeLeft)}${string.replace(/./g, '^')}

`;
};

const zip = (first, second) =>
    first.map((value, index) => [value, second[index]]);

const contextFromArgsAndParams = (argumentList, parameterList) =>
    zip(toArray(argumentList), 
        toArray(parameterList))
        .map((pair) => 
            ({
                name: value(pair[0]), 
                value: pair[1]
            }));

const apply = (stackTrace, lambda, parameters) => {
    if (lambda.type === 'function') {
        return lambda.value.apply(null, toArray(parameters));
    }
   
    const lambdaExpression = lambda.value;
    const argumentList = child(lambdaExpression, 0);
    const body = child(lambdaExpression, 1);

    if (size(parameters) < size(argumentList)) {
       return {
           type: 'lambda',
           value: list(slice(argumentList, size(parameters)), body),
           context: lambda.context.concat(contextFromArgsAndParams(slice(argumentList, 0, size(parameters)), parameters))
       };
    }

    if (size(parameters) > size(argumentList)) {
        return {type: 'error', message: `Function expects ${size(argumentList)} arguments but got ${size(parameters)} ${stringifyStackTrace(stackTrace)}`};
    }

    const argumentContext = contextFromArgsAndParams(argumentList, parameters);

    let newContext = [];
    if (lambda.context) {
        newContext = newContext.concat(lambda.context);
    }

    return evalExpression.bind(null, stackTrace, newContext.concat(argumentContext), body);
};

const evalApplication = (stackTrace, context, expression) => {
    const evaluated = map(expression, _eval.bind(null, stackTrace, context));

    const parameters = slice(evaluated, 1);
    const lambda = child(evaluated, 0);

    if (lambda.type === 'constructor') {
        return evaluated;
    }

    assert(lambda.type, `
    Internal Error: ${toString(child(expression, 0))} failed to evaluate. Value has no type information.
        ${lambda} ${stringifyStackTrace(stackTrace)}`);
    assert(lambda.type === 'lambda' || lambda.type === 'function', `${toString(child(expression, 0))} is not a lambda expression ${stringifyStackTrace(stackTrace)}`);

    const result = apply([...stackTrace, toString(child(expression, 0))], lambda, parameters);
    if (result.type === 'error') {
        throw new Error(`${result.message} in ${toString(expression)} ${stringifyStackTrace(stackTrace)}`);
    } else {
        return result;
    }
};

const findInContext = (context, name) => {
    for (let i = context.length - 1; i >= 0; --i) {
        if (context[i].name === name) {
            return context[i].value;
        }
    }

    return null;
};

const atomIsConstructor = (context, atom) => {
    const found = findInContext(context, value(atom));
    return found !== null && found.type === 'constructor';
};

const match = (stackTrace, context, pattern, input) => {
    if (isAtom(pattern)) {
        if (Number.isInteger(parseFloat(value(pattern)))) {
            return parseFloat(value(pattern)) === input;
        } else {
            if (!atomIsConstructor(context, pattern)) {
                return true;
            }
            const patternType = findInContext(context, value(pattern)).typeName;
            const inputType = input.typeName;
            if (input.type === 'constructor' && input.name === value(pattern)) {
                assert(patternType === inputType, `Expected types of pattern ${toString(pattern)} and input ${stringifyValue(input)} to match. ${patternType} != ${inputType} at:${showSexpLocation(pattern)}${stringifyStackTrace(stackTrace)}`);
                return true;
            } else {
                return false;
            }
        }
    } else if (isList(input)) {
        assert(size(pattern) > 0, 'expected size of pattern to be > 0');
        assert(size(input) > 0, 'expected size of input to be > 0');
        assert(atomIsConstructor(context, child(pattern, 0)), `Expected constructor in pattern ${toString(pattern)}`);

        const patternConstructor = child(pattern, 0);
        const patternType = findInContext(context, value(patternConstructor)).typeName;
        const inputType = child(input, 0).typeName;
        assert(patternType === inputType, `Expected types of pattern ${toString(patternConstructor)} and input ${stringifyValue(child(input, 0))} to match. ${patternType} != ${inputType} at:${showSexpLocation(pattern)}${stringifyStackTrace(stackTrace)}`);

        if (firstAtomValue(pattern) === child(input, 0).name) {
            const patterns = slice(pattern, 1);
            const inputs = slice(input, 1);
            assert(size(patterns) === size(inputs), `Expected size of pattern and input to be the same at ${toString(pattern)}. Pattern is ${size(patterns)}, input is ${size(inputs)} ${stringifyValue(input)}.${stringifyStackTrace(stackTrace)}`);
            for (let i = 0; i < size(patterns); ++i) {
                if (!match(stackTrace, context, child(patterns, i), child(inputs, i))) {
                    return false;
                }
            }
            return true;
        }
    }
    return false;
};

const c = (name) => ({name, value: {name, type: 'constructor', typeName: 'type'}}); 

assert.deepEqual(true, match([], [], atom('x'), 42), "matches variable with value");
assert.deepEqual(true, match([], [c('C')], list(atom('C'), atom('a')), list({type: 'constructor', name: 'C', typeName: 'type'}, 42)), "matches constructor with value");
assert.deepEqual(true, match([], [c('C'), c('D')], list(atom('C'), atom('D')), list({type: 'constructor', name: 'C', typeName: 'type'}, {type: 'constructor', name: "D", typeName: 'type'})), "matches no-args constructors");
assert.deepEqual(true, match([], [c('C')], list(atom('C'), atom('b')), list({type: 'constructor', name: 'C', typeName: 'type'}, {type: 'constructor', name: "D", typeName: 'type'})), "matches no-args constructors");

const matchContext = (context, pattern, input) => {
    if (isAtom(pattern)) {
        if (Number.isInteger(parseFloat(value(pattern))) || atomIsConstructor(context, pattern)) {
            return [];
        } else {
            return [{name: value(pattern), value: input}];
        }
    } else {
        if (firstAtomValue(pattern) === child(input, 0).name) {
            let context = [];
            const patterns = slice(pattern, 1);
            const inputs = slice(input, 1);
            for (let i = 0; i < size(patterns); ++i) {
                context = context.concat(matchContext(context, child(patterns, i), child(inputs, i)));
            }
            return context;
        }

        return [{name: value(pattern), value: input}];
    }
};

assert.deepEqual([{name: 'a', value: 42}], matchContext([c('C')], list(atom('C'), atom('a')), list({name: 'C', type: 'constructor'}, 42)));

const evalMatch = (stackTrace, context, expression) => {
    const input = _eval(stackTrace, context, child(expression, 1));
    const cases = slice(expression, 2);
    
    assert(size(cases) % 2 === 0, `expected pairs of pattern/result at match expression but found ${size(cases)} expressions`);

    for (let i = 0; i < size(cases); i += 2) {
        const pattern = child(cases, i);
        const result = child(cases, i + 1);
        
        if (match(stackTrace, context, pattern, input)) {
            return evalExpression.bind(null, stackTrace, context.concat(matchContext(context, pattern, input)), result);
        }
    }

    throw new Error(`No case matching ${toString(expression)}`);
};

const evalExpression = (stackTrace, context, expression) => {
    if (isAtom(expression)) {
        if (!isNaN(value(expression))) {
            return parseInt(value(expression), 10) | 0;
        } else {
            const foundValue = findInContext(context, value(expression));
            if (foundValue === null) {
                throw Error(`Could not find symbol ${value(expression)} ${stringifyStackTrace(stackTrace)}`);
            }
            return foundValue;
        }
    } else {
        if (isAtom(child(expression, 0))) {
            const first = value(child(expression, 0));  
            if (first === 'fn') {
                return {type: 'lambda', value: slice(expression, 1), context};
            } else if (first === 'match') {
                return evalMatch(stackTrace, context, expression);
            }
        }

        return evalApplication(stackTrace, context, expression);
    }
};

const _eval = (stackTrace, context, expression) => {
    let result = evalExpression.bind(null, stackTrace, context, expression);
    while (typeof result === 'function') {
        result = result();
    }
    return result;
};

const createGlobalContext = (parsedProgram) => {
    const isTypeDefinition = (definition) => 
        firstAtomValue(definition) === 'typ';

    const isFunctionDefinition = (definition) => 
        firstAtomValue(definition) === 'def' || firstAtomValue(definition) === 'export';

    const nameOfDefinition = (definition) => {
        if (isAtom(child(definition, 1))) {
            return value(child(definition, 1));
        } else {
            return value(child(child(definition, 1), 0));
        }
    };

    const pipe = (...fs) => {
        return {
            type: 'function',
            value: (x) => {
                fs.forEach(f => {
                    x = apply([], f, list(x));
                });
                return x;
            }
        };
    };

    const listForm = (...elements) => {
        if (elements.length > 0) {
            return list({ type: 'constructor', name: 'Cons', typeName: 'list' }, elements[0], listForm(...elements.slice(1)));
        } else {
            return { type: 'constructor', name: 'Empty', typeName: 'list' };
        }
    };

    const definitionToLambda = (definition) => ({type: 'lambda', value: slice(definition, 2)});

    const constructorsFromType = (definition) => {
        const constructors = slice(definition, 2);
        const typeName = child(definition, 1);
        return map(constructors, (constructor) => {
            const name = isAtom(constructor) ? value(constructor) : value(child(constructor, 0));
            return {
                name,
                value: {type: 'constructor', name, typeName: isAtom(typeName) ? value(typeName) : value(child(typeName, 0))}
            };
        });
    };

    const functionDefinitions = filter(parsedProgram, isFunctionDefinition);
    const typeDefinitions = filter(parsedProgram, isTypeDefinition);

    const contextWithBuiltIns = [
        {name: '+', value: {type: 'function', value: (a, b) => a + b | 0}},
        {name: '-', value: {type: 'function', value: (a, b) => a - b | 0}},
        {name: '*', value: {type: 'function', value: (a, b) => a * b | 0}},
        {name: '/', value: {type: 'function', value: (a, b) => a / b | 0}},
        {name: '%', value: {type: 'function', value: (a, b) => a % b | 0}},
        {name: 'int32-less-than', value: {type: 'function', value: (a, b, x, y) => a < b ? x : y}},
        {name: 'pipe', value: {type: 'function', value: pipe}},
        {name: 'list', value: {type: 'function', value: listForm}},
    ];

    const contextWithFunctions = map(
        functionDefinitions,
        (definition) => 
            ({
                name: nameOfDefinition(definition), 
                value: definitionToLambda(definition)
            }));

    const contextWithTypes = map(
        typeDefinitions,
        (definition) =>
            ({
                name: nameOfDefinition(definition),
                value: definition
            }));

    const contextWithConstructors = flatMap(
        typeDefinitions,
        constructorsFromType
    );
    
    const context = toArray(contextWithTypes)
            .concat(contextWithBuiltIns)
            .concat(toArray(contextWithFunctions))
            .concat(toArray(contextWithConstructors));

    map(contextWithFunctions, (entry) => {
        entry.value.context = context;
    });

    return context;
};

module.exports.interpret = (program, expression, context) => {
    const parseResult = parse(program);
    if (parseResult.error) {
        const error = parseResult.error;
        console.error(`Parse error: ${error} at ${error.line}:${error.column}.`);
        process.exit(1);
    }
    const parsedProgram = parseResult.ast;
    const globalContext = createGlobalContext(parsedProgram);
    
    const parsedExpression = child(parse(expression).ast, 0);
    const stackTrace = [`Expression '${toString(parsedExpression)}'`];
    return _eval(stackTrace, context.concat(globalContext), parsedExpression);
};


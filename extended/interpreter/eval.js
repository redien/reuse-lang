
import { parse } from '../../parser/bootstrap/parser';
import { isList, flatMap, some, concat, atom, list, filter, slice, child, size, isAtom, value, map, toString, toArray } from '../../parser/bootstrap/ast';
const assert = require('assert');
const util = require('util');

const firstAtomValue = (expression) => value(child(expression, 0));
const secondAtomValue = (expression) => value(child(expression, 1));

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

const apply = (lambda, parameters) => {
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
        return {type: 'error', message: `Function expects ${size(argumentList)} arguments but got ${size(parameters)}`}; 
    }

    const argumentContext = contextFromArgsAndParams(argumentList, parameters);

    let newContext = [];
    if (lambda.context) {
        newContext = newContext.concat(lambda.context);
    }

    return evalExpression.bind(null, newContext.concat(argumentContext), body);

};

const evalApplication = (context, expression) => {
    const evaluated = map(expression, _eval.bind(null, context));
 
    const parameters = slice(evaluated, 1);
    const lambda = child(evaluated, 0);

    if (lambda.type === 'constructor') {
        return evaluated;
    }
    
    assert(lambda.type === 'lambda' || lambda.type === 'function', `${toString(child(expression, 0))} is not a lambda expression`);
     
    const result = apply(lambda, parameters);
    if (result.type === 'error') {
        throw new Error(`${result.message} in ${toString(expression)}`);
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

const match = (context, pattern, input) => {
    if (isAtom(pattern)) {
        return !atomIsConstructor(context, pattern) || (input.type === 'constructor' && input.name === value(pattern));
    } else {
        assert(size(pattern) > 0, 'expected size of list to be > 0');
        assert(atomIsConstructor(context, child(pattern, 0)), `Expected constructor in pattern ${toString(pattern)}`);
        assert(isList(input), `Expected ${input} to be list`);
        if (firstAtomValue(pattern) === child(input, 0).name) {
            const patterns = slice(pattern, 1);
            const inputs = slice(input, 1);
            for (let i = 0; i < size(patterns); ++i) {
                if (!match(context, child(patterns, i), child(inputs, i))) {
                    return false;
                }
            }
            return true;
        }
    }
};

const c = (name) => ({name, value: {name, type: 'constructor'}}); 

assert.deepEqual(true, match([], atom('x'), 42), "matches variable with value");
assert.deepEqual(true, match([c('C')], list(atom('C'), atom('a')), list({type: 'constructor', name: 'C'}, 42)), "matches constructor with value");
assert.deepEqual(true, match([c('C'), c('D')], list(atom('C'), atom('D')), list({type: 'constructor', name: 'C'}, {type: 'constructor', name: "D"})), "matches no-args constructors");
assert.deepEqual(true, match([c('C')], list(atom('C'), atom('b')), list({type: 'constructor', name: 'C'}, {type: 'constructor', name: "D"})), "matches no-args constructors");

const matchContext = (context, pattern, input) => {
    if (isAtom(pattern)) {
        if (atomIsConstructor(context, pattern)) {
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

const evalMatch = (context, expression) => {
    const input = _eval(context, child(expression, 1));
    const cases = slice(expression, 2);

    for (let i = 0; i < size(cases); i += 2) {
        const pattern = child(cases, i);
        const result = child(cases, i + 1);
        
        if (match(context, pattern, input)) {
            return evalExpression.bind(null, context.concat(matchContext(context, pattern, input)), result);
        }
    }

    throw new Error(`No case matching ${toString(expression)}`);
};

const evalExpression = (context, expression) => {
    if (isAtom(expression)) {
        if (!isNaN(value(expression))) {
            return parseInt(value(expression), 10) | 0;
        } else {
            const foundValue = findInContext(context, value(expression));
            if (foundValue === null) {
                throw Error(`Could not find symbol ${value(expression)}`);
            }
            return foundValue;
        }
    } else {
        if (isAtom(child(expression, 0))) {
            const first = value(child(expression, 0));  
            if (first === 'fn') {
                return {type: 'lambda', value: slice(expression, 1), context};
            } else if (first === 'match') {
                return evalMatch(context, expression);
            }
        }

        return evalApplication(context, expression);
    }
};

const _eval = (context, expression) => {
    let result = evalExpression.bind(null, context, expression);
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
                    x = apply(f, list(x));
                });
                return x;
            }
        };
    };

    const definitionToLambda = (definition) => ({type: 'lambda', value: slice(definition, 2)});

    const constructorsFromType = (definition) => {
        const constructors = slice(definition, 2);
        return map(constructors, (constructor) => {
            const name = isAtom(constructor) ? value(constructor) : value(child(constructor, 0)); 
            return {
                name,
                value: {type: 'constructor', name}
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
    
    const context = contextWithBuiltIns
            .concat(toArray(contextWithFunctions))
            .concat(toArray(contextWithTypes))
            .concat(toArray(contextWithConstructors)); 

    map(contextWithFunctions, (entry) => {
        entry.value.context = context;
    });

    return context;
};

module.exports.interpret = (program, expression, context) => {
    const parsedProgram = parse(program).ast;
    const globalContext = createGlobalContext(parsedProgram);
    
    const parsedExpression = child(parse(expression).ast, 0);
    return _eval(context.concat(globalContext), parsedExpression);
};


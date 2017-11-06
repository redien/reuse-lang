
import { parse } from '../../parser/bootstrap/parser';
import { isList, flatMap, some, concat, atom, list, filter, slice, child, size, isAtom, value, map, toString, toArray } from '../../parser/bootstrap/ast';
const assert = require('assert');
const util = require('util');

const firstAtomValue = (expression) => value(child(expression, 0));
const secondAtomValue = (expression) => value(child(expression, 1));

const isTypeDefinition = (definition) => 
    firstAtomValue(definition) === 'typ';

const isFunctionDefinition = (definition) => 
    firstAtomValue(definition) === 'def' || firstAtomValue(definition) === 'export';

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

const evalApplication = (context, expression) => {
    const evaluated = map(expression, evalExpression.bind(null, context));
    
    if (child(evaluated, 0).type === 'constructor') {
        return evaluated;
    }

    if (typeof child(evaluated, 0) === 'function') {
        return child(evaluated, 0).apply(null, toArray(evaluated).slice(1));
    }

    const lambda = child(evaluated, 0);
    const argumentList = child(lambda, 1);
    
    assert(size(evaluated) === size(argumentList) + 1, `Function expects ${size(argumentList)} arguments but got ${size(evaluated) - 1} in ${toString(expression)}.`);

    const argumentContext = contextFromArgsAndParams(argumentList, slice(evaluated, 1));
    const body = child(lambda, 2);
    return evalExpression(context.concat(argumentContext), body);
};

const evalMatch = (context, expression) => {
    const input = evalExpression(context, child(expression, 1));
    const cases = slice(expression, 2);

    for (let i = 0; i < size(cases); i += 2) {
        const pattern = child(cases, i);
        const result = child(cases, i + 1);

        if (isAtom(pattern) && value(pattern) === input.name) {
            return evalExpression(context, result);
        }

        if (isList(pattern) && firstAtomValue(pattern) === child(input, 0).name) {
            return evalExpression(
                context.concat(
                    contextFromArgsAndParams(
                        slice(pattern, 1),
                        slice(input, 1))),
                result);
        }
    }

    throw new Error(`No case matching ${toString(expression)}`);
};

const nameOfDefinition = (definition) => {
    if (isAtom(child(definition, 1))) {
        return value(child(definition, 1));
    } else {
        return value(child(child(definition, 1), 0));
    }
};

const findInContext = (context, name) => 
    (context.filter((pair) => pair.name === name)[0] || {}).value;

const evalExpression = (context, expression) => {
    if (isAtom(expression)) {
        if (!isNaN(value(expression))) {
            return parseInt(value(expression), 10) | 0;
        } else {
            const foundValue = findInContext(context, value(expression));
            if (!foundValue) {
                throw Error(`Could not find symbol ${value(expression)}`);
            }
            return foundValue;
        }
    } else {
        if (isAtom(child(expression, 0))) {
            const first = value(child(expression, 0));  
            if (first === 'fn') {
                return expression;
            } else if (first === 'match') {
                return evalMatch(context, expression);
            }
        }

        return evalApplication(context, expression);
    }
};

const definitionToLambda = (definition) => concat(list(atom('fn')), slice(definition, 2));

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

module.exports.interpret = (program, expression, context) => {
    context = context.concat([
        {name: '+', value: (a, b) => a + b | 0},
        {name: '-', value: (a, b) => a - b | 0},
        {name: '*', value: (a, b) => a * b | 0},
        {name: '/', value: (a, b) => a / b | 0},
        {name: '%', value: (a, b) => a % b | 0},
        {name: 'int32-compare', value: (a, x, b, y) => a < b ? x : y},
    ]);

    const parsedExpression = child(parse(expression).ast, 0);
    const parsedProgram = parse(program).ast;

    const functionDefinitions = filter(parsedProgram, isFunctionDefinition);
    const typeDefinitions = filter(parsedProgram, isTypeDefinition);

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
   
    return evalApplication(
        context
            .concat(toArray(contextWithFunctions))
            .concat(toArray(contextWithTypes))
            .concat(toArray(contextWithConstructors)),
        parsedExpression);
};


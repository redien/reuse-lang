
// reuse-lang - a pure functional lisp-like language for writing
// reusable algorithms in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var fs = require('fs');
var path = require('path');
var symbolNameEncoder = require(__dirname + '/../symbol-name-encoder');
var ast = require(__dirname + '/../ast-builder');

var intrinsics = fs.readFileSync(__dirname + '/intrinsics.js').toString();

var error = function (type, line, column) {
    return [1, [type, [line, [column, null]]]];
};
module.exports.error = error;
var isError = function (expression) {
    return expression[0] === 1;
};
module.exports.isError = isError;
var errorType = function (expression) {
    return expression[1][0];
};
module.exports.errorType = errorType;
var errorLine = function (expression) {
    return expression[1][1][0];
};
module.exports.errorLine = errorLine;
var errorColumn = function (expression) {
    return expression[1][1][1][0];
};
module.exports.errorColumn = errorColumn;

var result = function (program) {
    return [0, program];
};
module.exports.result = result;
var value = function (expression) {
    return expression[1];
};
module.exports.value = value;


var symbolIsNumber = function (symbol) {
    return ast.value(symbol).match(/^[0-9]/) !== null;
};

var translateParameters = function (parameters, offset, stride) {
    var translatedString = '';

    var parameterIndex;
    var parameterCount = ast.count(parameters);
    for (parameterIndex = offset; parameterIndex < parameterCount; parameterIndex += stride) {
        var parameter = ast.expression(parameters, parameterIndex);

        if (parameterIndex !== offset) {
            translatedString += ', ';
        }

        if (symbolIsNumber(parameter)) {
            translatedString += ast.value(parameter);
        } else {
            translatedString += symbolNameEncoder.encode(ast.value(parameter));
        }
    }

    return translatedString;
};

var translateFunctionApplication = function (functionExpression, imports) {
    var functionName = ast.value(ast.expression(functionExpression, 0));

    if (imports[functionName] === 'stdlib/vector.ru') {
        if (functionName === 'vector:new') {
            return '[]';
        } else if (functionName === 'vector:length') {
            return translateFunctionArguments(functionExpression, 1, 1, imports) + '.length';
        } else if (functionName === 'vector:push') {
            return '(function (vector) { return vector.push(' + translateFunctionArguments(functionExpression, 2, 1, imports) + '), vector; })(' + translateExpression(ast.expression(functionExpression, 1), imports) + '.slice())'
        } else if (functionName === 'vector:pop') {
            return translateFunctionArguments(functionExpression, 1, 1, imports) + '.slice(0, -1)';
        } else if (functionName === 'vector:element-at-index') {
            return translateExpression(ast.expression(functionExpression, 1), imports) + '[' + translateFunctionArguments(functionExpression, 2, 1, imports) + ']';
        } else if (functionName === 'vector:last-element') {
            return '(function (vector) { return vector[vector.length - 1]; })(' + translateFunctionArguments(functionExpression, 1, 1, imports) + ')';
        }
    }

    if (imports[functionName] === 'stdlib/string.ru') {
        if (functionName === 'string:new') {
            return "''";
        } else if (functionName === 'string:length') {
            return translateFunctionArguments(functionExpression, 1, 1, imports) + '.length';
        } else if (functionName === 'string:push') {
            return '(' + translateExpression(ast.expression(functionExpression, 1), imports) + ' + String.fromCharCode(' + translateFunctionArguments(functionExpression, 2, 1, imports) + '))';
        } else if (functionName === 'string:code-point-at-index') {
            return '_charCodeAt(' + translateExpression(ast.expression(functionExpression, 1), imports) + ', ' + translateFunctionArguments(functionExpression, 2, 1, imports) + ')';
        } else if (functionName === 'string:concatenate') {
            return '(' + translateExpression(ast.expression(functionExpression, 1), imports) + ' + ' + translateExpression(ast.expression(functionExpression, 2), imports) + ')';
        } else if (functionName === 'string:substring') {
            return translateExpression(ast.expression(functionExpression, 1), imports) + '.substr(' + translateFunctionArguments(functionExpression, 2, 1, imports) + ')';
        } else if (functionName === 'string:equal?') {
            return '(' + translateExpression(ast.expression(functionExpression, 1), imports) + ' === ' + translateExpression(ast.expression(functionExpression, 2), imports) + ')';
        }
    }

    return translateExpression(ast.expression(functionExpression, 0), imports) + '(' + translateFunctionArguments(functionExpression, 1, 1, imports) + ')'
};

var translateFunctionArguments = function (arguments, offset, stride, imports) {
    var result = '';

    var argumentIndex;
    var argumentCount = ast.count(arguments);
    for (argumentIndex = offset; argumentIndex < argumentCount; argumentIndex += stride) {
        var argument = ast.expression(arguments, argumentIndex);

        if (argumentIndex !== offset) {
            result += ', ';
        }

        result += translateExpression(argument, imports);
    }

    return result;
};

var expressionContainsRecursiveCall = function expressionContainsRecursiveCall(expression, functionName) {
    if (ast.kind(expression) === 'atom') {
        return false;
    } else {
        var itemCount = ast.count(expression);
        if (itemCount > 0 && ast.value(ast.expression(expression, 0)) === 'lambda') {
            return false;
        } else if (itemCount > 0 && ast.value(ast.expression(expression, 0)) === 'self') {
            return true;
        } else {
            var subExpressionIndex;
            for (subExpressionIndex = 0; subExpressionIndex < itemCount; ++subExpressionIndex) {
                var subExpression = ast.expression(expression, subExpressionIndex);

                if (expressionContainsRecursiveCall(subExpression)) {
                    return true;
                }
            }

            return false;
        }
    }
};

var translateLambda = function (lambda, imports) {
    if (expressionContainsRecursiveCall(ast.expression(lambda, 2))) {
        return '(function (' + translateParameters(ast.expression(lambda, 1), 0, 1) + ') { ' +
            'var self = _generate_recursive_function(arguments); while (true) { var result; result = ' + translateExpression(ast.expression(lambda, 2), imports) + '; if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result;' +
        ' })';
    } else {
        return '(function (' + translateParameters(ast.expression(lambda, 1), 0, 1) + ') { ' +
            'return ' + translateExpression(ast.expression(lambda, 2), imports) +
        '; })';
    }
};

var translateDefine = function (define, imports) {
    return '(function (' + translateParameters(ast.expression(define, 1), 0, 2) + ') { return ' + translateExpression(ast.expression(define, 2), imports) + '; })(' + translateFunctionArguments(ast.expression(define, 1), 1, 2, imports) + ')';
};

var translateIfStatement = function (statement, imports) {
    return '(' + translateExpression(ast.expression(statement, 1), imports) + ' ? ' + translateExpression(ast.expression(statement, 2), imports) + ' : ' + translateExpression(ast.expression(statement, 3), imports) + ')';
};

var translateExpression = function (expression, imports) {
    if (ast.kind(expression) === 'atom') {
        var atomValue = ast.value(expression);

        if (symbolIsNumber(expression)) {
            var integer = parseInt(atomValue, 10);
            if (integer > 2147483647) {
                throw error(
                    'invalid_integer_constant',
                    ast.line(expression),
                    ast.column(expression)
                );
            }
            return atomValue;
        } else {
            return symbolNameEncoder.encode(atomValue);
        }
    } else {
        var expressionKind = ast.value(ast.expression(expression, 0));
        if (expressionKind === 'lambda') {
            return translateLambda(expression, imports);
        } else if (expressionKind === 'define') {
            return translateDefine(expression, imports);
        } else if (expressionKind === 'if') {
            return translateIfStatement(expression, imports);
        } else {
            return translateFunctionApplication(expression, imports);
        }
    }
};

var nameCanBeExported = function (name) {
    return name.match(/^[a-zA-Z0-9_]+$/) !== null;
};

var indexOfFirstInvalidCharacter = function (name) {
    return name.match(/[^a-zA-Z0-9_]+/).index;
}

var findErrorFromInvalidExportedSymbols = function (program) {
    var statementIndex;
    var statementCount = ast.count(program);

    for (statementIndex = 0; statementIndex < statementCount; ++statementIndex) {
        var statement = ast.expression(program, statementIndex);

        if (ast.count(statement) > 1) {
            var name = ast.expression(statement, 1);

            if (ast.value(ast.expression(statement, 0)) === 'export' && !nameCanBeExported(ast.value(name))) {
                throw error(
                    "exported_symbol_contains_invalid_character",
                    ast.line(name),
                    ast.column(name) + indexOfFirstInvalidCharacter(ast.value(name))
                );
            }
        }
    }
};

exports.translate = function (program) {
    try {
        findErrorFromInvalidExportedSymbols(program);

        var translatedString =
            intrinsics;

        var translatedFirstStatement = false;
        var imports = [];

        var statementIndex;
        var statementCount = ast.count(program);
        for (statementIndex = 0; statementIndex < statementCount; ++statementIndex) {

            if (translatedFirstStatement) {
                translatedString += '\n';
            }

            var statement = ast.expression(program, statementIndex);
            var statementKind = ast.value(ast.expression(statement, 0));

            if (statementKind === 'export') {
                var name = ast.value(ast.expression(statement, 1));
                var localName = symbolNameEncoder.encode(name);
                var expression = translateExpression(ast.expression(statement, 2), imports);

                translatedString +=
                    'var ' + localName + ' = ' + expression +
                    '; module.exports.' + name + ' = ' + localName + ';';

                translatedFirstStatement = true;

            } else if (statementKind === 'define' || statementKind === 'define-from-import') {
                var name = symbolNameEncoder.encode(ast.value(ast.expression(statement, 1)));
                var expression = translateExpression(ast.expression(statement, 2), imports);

                translatedString +=
                    'var ' + name + ' = ' + expression + ';';

                translatedFirstStatement = true;

                if (statementKind === 'define-from-import') {
                    imports[ast.value(ast.expression(statement, 1))] = ast.value(ast.expression(statement, 3));
                }

            } else {
                return error(
                    'invalid_statement',
                    ast.line(ast.expression(statement, 0)),
                    ast.column(ast.expression(statement, 0)) - 1
                );
            }
        }

        return result(translatedString);

    } catch (parseError) {
        if (isError(parseError)) {
            return parseError;
        } else {
            throw parseError;
        }
    }
};

exports.listToArray = function (list) {
    var array = [];

    while (list !== null) {
        array.push(list[0]);
        list = list[1];
    }

    return array;
};

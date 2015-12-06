
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

var symbolsToOverride = {
    'stdlib/vector.ru': [
        'vector:new',
        'vector:length',
        'vector:push',
        'vector:pop',
        'vector:element-at-index'
    ],
    'stdlib/string.ru': [
        'string:new',
        'string:push'
    ]
};

var shouldOverrideSymbol = function (moduleName, symbolName) {
    if (symbolsToOverride[moduleName] === undefined) {
        return false;
    }

    return symbolsToOverride[moduleName].indexOf(symbolName) !== -1
};

var encodeLocalSymbolName = function (symbolName) {
    if (symbolName === 'import') { return '_reserved_' + symbolName; }
    return symbolNameEncoder.encode(symbolName);
};

var symbolIsNumber = function (symbol) {
    return ast.value(symbol).match(/^[0-9]/) !== null;
};

var encodeExportedSymbol = function (name) {
    if (name.match(/\?$/)) {
        name = 'is_' + name.replace(/\?$/, '');
    }
    return name.replace(/[^a-zA-Z0-9_]/g, '_');
};

var translateList = function (parameters, offset, stride, translator) {
    var translatedString = '';

    var parameterIndex;
    var parameterCount = ast.count(parameters);
    for (parameterIndex = offset; parameterIndex < parameterCount; parameterIndex += stride) {
        var parameter = ast.expression(parameters, parameterIndex);

        if (parameterIndex !== offset) {
            translatedString += ', ';
        }

        translatedString += translator(parameter);
    }

    return translatedString;
};

var translateParameters = function (parameters, offset, stride) {
    return translateList(parameters, offset, stride, function (parameter) {
        if (symbolIsNumber(parameter)) {
            return ast.value(parameter);
        } else {
            return encodeLocalSymbolName(ast.value(parameter));
        }
    });
};

var translateFunctionArguments = function (arguments, offset, stride, imports) {
    return translateList(arguments, offset, stride, function (argument) {
        return translateExpression(argument, imports);
    });
};

var translateFunctionApplication = function (functionExpression, imports) {
    return translateExpression(ast.expression(functionExpression, 0), imports) + '(' + translateFunctionArguments(functionExpression, 1, 1, imports) + ')'
};

var expressionContainsCallTo = function expressionContainsCallTo(expression, functionName) {
    if (ast.kind(expression) === 'atom') {
        return false;
    } else {
        var itemCount = ast.count(expression);
        if (itemCount > 0 && ast.value(ast.expression(expression, 0)) === 'lambda') {
            return false;
        } else if (itemCount > 0 && ast.value(ast.expression(expression, 0)) === functionName) {
            return true;
        } else {
            var subExpressionIndex;
            for (subExpressionIndex = 0; subExpressionIndex < itemCount; ++subExpressionIndex) {
                var subExpression = ast.expression(expression, subExpressionIndex);

                if (expressionContainsCallTo(subExpression, functionName)) {
                    return true;
                }
            }

            return false;
        }
    }
};

var translateLambda = function (lambda, imports) {
    var lambdaName = '';

    if (expressionContainsCallTo(ast.expression(lambda, 2), 'self')) {
        lambdaName = 'self';
    }

    if (expressionContainsCallTo(ast.expression(lambda, 2), 'recur')) {
        return '(function ' + lambdaName + '(' + translateParameters(ast.expression(lambda, 1), 0, 1) + ') { ' +
            'var recur = _generate_recursive_function(arguments); while (true) { var result; result = ' + translateExpression(ast.expression(lambda, 2), imports) + '; if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result;' +
        ' })';
    } else {
        return '(function ' + lambdaName + '(' + translateParameters(ast.expression(lambda, 1), 0, 1) + ') { ' +
            'return ' + translateExpression(ast.expression(lambda, 2), imports) +
        '; })';
    }
};

var translateLet = function (expression, imports) {
    var letName = translateExpression(ast.expression(ast.expression(expression, 1), 0), imports);
    var letExpression = translateExpression(ast.expression(ast.expression(expression, 1), 1), imports);
    var expression = translateExpression(ast.expression(expression, 2), imports);
    return '(function (' + letName + ') { return ' + expression + '; })(' + letExpression + ')';
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
            return encodeLocalSymbolName(atomValue);
        }
    } else {
        var expressionKind = ast.value(ast.expression(expression, 0));
        if (expressionKind === 'lambda') {
            return translateLambda(expression, imports);
        } else if (expressionKind === 'let') {
            return translateLet(expression, imports);
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

exports.translate = function (program) {

    try {
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
                var localName = encodeLocalSymbolName(name);
                var expression = translateExpression(ast.expression(statement, 2), imports);

                translatedString +=
                    'var ' + localName + ' = ' + expression +
                    '; module.exports.' + encodeExportedSymbol(name) + ' = _export(' + localName + ');';

                translatedFirstStatement = true;

            } else if (statementKind === 'define' || statementKind === 'define-from-import') {
                var name = encodeLocalSymbolName(ast.value(ast.expression(statement, 1)));
                var expression = translateExpression(ast.expression(statement, 2), imports);


                if (statementKind === 'define-from-import' && shouldOverrideSymbol(ast.value(ast.expression(statement, 3)), ast.value(ast.expression(statement, 1)))) {
                    imports[ast.value(ast.expression(statement, 1))] = ast.value(ast.expression(statement, 3));

                } else {
                    translatedString +=
                        'var ' + name + ' = ' + expression + ';';

                    translatedFirstStatement = true;
                }

            } else if (statementKind === 'comment') {
                // Do nothing for comments.
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

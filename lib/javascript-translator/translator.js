
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

var intrinsics = fs.readFileSync(__dirname + '/intrinsics.js').toString();

var symbolIsNumber = function (symbol) {
    return symbol.value.match(/^[0-9]/) !== null;
};

var translateParameters = function (parameters, offset, stride) {
    var translatedString = '';

    var parameterIndex;
    for (parameterIndex = offset; parameterIndex < parameters.length; parameterIndex += stride) {
        var parameter = parameters[parameterIndex];

        if (parameterIndex !== offset) {
            translatedString += ', ';
        }

        if (symbolIsNumber(parameter)) {
            translatedString += parameter.value;
        } else {
            translatedString += symbolNameEncoder.encode(parameter.value);
        }
    }

    return translatedString;
};

var translateFunctionApplication = function (ast, imports) {
    if (imports.indexOf('stdlib/vector.ru') !== -1) {
        if (ast.elements[0].value === 'vector:new') {
            return '[]';
        } else if (ast.elements[0].value === 'vector:length') {
            return translateFunctionArguments(ast.elements, 1, 1, imports) + '.length';
        } else if (ast.elements[0].value === 'vector:push') {
            return '(function (vector) { return vector.push(' + translateFunctionArguments(ast.elements, 2, 1, imports) + '), vector; })(' + translateFunctionArguments([ast.elements[1]], 0, 1, imports) + ')'
        } else if (ast.elements[0].value === 'vector:pop') {
            return translateFunctionArguments(ast.elements, 1, 1, imports) + '.slice(0, -1)';
        } else if (ast.elements[0].value === 'vector:element-at-index') {
            return translateFunctionArguments([ast.elements[1]], 0, 1, imports) + '[' + translateFunctionArguments(ast.elements, 2, 1, imports) + ']';
        } else if (ast.elements[0].value === 'vector:last-element') {
            return '(function (vector) { return vector[vector.length - 1]; })(' + translateFunctionArguments(ast.elements, 1, 1, imports) + ')';
        }
    }

    return translateExpression(ast.elements[0], imports) + '(' + translateFunctionArguments(ast.elements, 1, 1, imports) + ')'
};

var translateFunctionArguments = function (arguments, offset, stride, imports) {
    var result = '';

    var argumentIndex;
    for (argumentIndex = offset; argumentIndex < arguments.length; argumentIndex += stride) {
        var argument = arguments[argumentIndex];

        if (argumentIndex !== offset) {
            result += ', ';
        }

        result += translateExpression(argument, imports);
    }

    return result;
};

var expressionContainsRecursiveCall = function expressionContainsRecursiveCall(ast, functionName) {
    if (ast.kind === 'atom') {
        return false;
    } else {
        if (ast.elements.length > 0 && ast.elements[0].value === 'lambda') {
            return false;
        } else if (ast.elements.length > 0 && ast.elements[0].value === 'self') {
            return true;
        } else {
            var expressionIndex;
            for (expressionIndex = 0; expressionIndex < ast.elements.length; ++expressionIndex) {
                var expression = ast.elements[expressionIndex];

                if (expressionContainsRecursiveCall(expression)) {
                    return true;
                }
            }

            return false;
        }
    }
};

var translateLambda = function (ast, imports) {
    if (expressionContainsRecursiveCall(ast.elements[2])) {
        return '(function (' + translateParameters(ast.elements[1].elements, 0, 1) + ') { ' +
            'var self = _generate_recursive_function(arguments); while (true) { var result; result = ' + translateExpression(ast.elements[2], imports) + '; if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result;' +
        ' })';
    } else {
        return '(function (' + translateParameters(ast.elements[1].elements, 0, 1) + ') { ' +
            'return ' + translateExpression(ast.elements[2], imports) +
        '; })';
    }
};

var translateDefine = function (ast, imports) {
    return '(function (' + translateParameters(ast.elements[1].elements, 0, 2) + ') { return ' + translateExpression(ast.elements[2], imports) + '; })(' + translateFunctionArguments(ast.elements[1].elements, 1, 2, imports) + ')';
};

var translateIfStatement = function (ast, imports) {
    return '(' + translateExpression(ast.elements[1], imports) + ' ? ' + translateExpression(ast.elements[2], imports) + ' : ' + translateExpression(ast.elements[3], imports) + ')';
};

var translateExpression = function (ast, imports) {
    if (ast.kind === 'atom') {
        if (symbolIsNumber(ast)) {
            var integer = parseInt(ast.value, 10);
            if (integer > 2147483647) {
                var error = new Error('invalid_integer_constant');
                error.line = ast.line;
                error.column = ast.column;
                throw error;
            }
            return ast.value;
        } else {
            return symbolNameEncoder.encode(ast.value);
        }
    } else {
        if (ast.elements[0].value === 'lambda') {
            return translateLambda(ast, imports);
        } else if (ast.elements[0].value === 'define') {
            return translateDefine(ast, imports);
        } else if (ast.elements[0].value === 'if') {
            return translateIfStatement(ast, imports);
        } else {
            return translateFunctionApplication(ast, imports);
        }
    }
};

var nameCanBeExported = function (name) {
    return name.match(/^[a-zA-Z0-9_]+$/) !== null;
};

var indexOfFirstInvalidCharacter = function (name) {
    return name.match(/[^a-zA-Z0-9_]+/).index;
}

var findErrorFromInvalidExportedSymbols = function (ast) {
    var statementIndex;

    for (statementIndex = 0; statementIndex < ast.elements.length; ++statementIndex) {
        var statement = ast.elements[statementIndex];

        if (statement.elements[0].value === 'export' && !nameCanBeExported(statement.elements[1].value)) {
            var error = new Error("exported_symbol_contains_invalid_character");
            error.line = statement.elements[1].line;
            error.column = statement.elements[1].column + indexOfFirstInvalidCharacter(statement.elements[1].value);

            return error;
        }
    }
};

exports.translate = function (ast) {
    var error = findErrorFromInvalidExportedSymbols(ast);
    if (error !== undefined) {
        return {
            error: error
        };
    }

    try {
        var translatedString =
            intrinsics;

        var statementIndex;
        var translatedFirstStatement = false;
        var imports = [];
        for (statementIndex = 0; statementIndex < ast.elements.length; ++statementIndex) {

            if (translatedFirstStatement) {
                translatedString += '\n';
            }

            var statement = ast.elements[statementIndex];

            if (statement.elements[0].value === 'export') {
                var name = statement.elements[1].value;
                var localName = symbolNameEncoder.encode(name);
                var expression = translateExpression(statement.elements[2], imports);

                translatedString +=
                    'var ' + localName + ' = ' + expression +
                    '; module.exports.' + name + ' = ' + localName + ';';

                translatedFirstStatement = true;

            } else if (statement.elements[0].value === 'define') {
                var name = symbolNameEncoder.encode(statement.elements[1].value);
                var expression = translateExpression(statement.elements[2], imports);

                translatedString +=
                    'var ' + name + ' = ' + expression + ';';

                translatedFirstStatement = true;

            } else if (statement.elements[0].value === 'import') {
                // At this point all import statements have already been
                // handled. This import statement must therefore be a part of
                // a unit test; and we can safely ignore it.

                // We keep the names of the modules around to specialize certain
                // modules.
                imports.push(statement.elements[1].value);

            } else {
                var error = new Error("invalid_statement");
                return {
                    error: error
                };
            }
        }

        return {error: null, value: translatedString};

    } catch (error) {
        return {error: error};
    }
};

exports.stringToCodePointList = function (string) {
    var list = null;
    var index;
    for (index = string.length - 1; index >= 0; --index) {
        var character = string.charCodeAt(index);

        if (character >= 0xDC00 && character <= 0xDFFF && index - 1 >= 0) {
            var low = character - 0xDC00;
            index -= 1;
            var high = string.charCodeAt(index) - 0xD800;

            character = (low | (high << 10)) + 0x10000;
        }

        list = [character, list];
    }

    return list;
};

exports.listToArray = function (list) {
    var array = [];

    while (list !== null) {
        array.push(list[0]);
        list = list[1];
    }

    return array;
};

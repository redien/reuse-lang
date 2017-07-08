var ast = require('../../../parser/ast');

var constructorNames = ast.list();
var mangledNames = {};
var noArgumentFunctions = ast.list();

var escapeNonAscii = function(name) {
    var newName = '';
    for (var i = 0; i < name.length; ++i) {
        var char = name.charCodeAt(i);

        if ((char >= 65 && char <= 90) || (char >= 97 && char <= 122)) {
            newName += String.fromCharCode(char);
        } else {
            newName += '_' + char;
        }
    }
    return newName;
};

var mangle = function(prefix, name) {
    var newName = prefix + '_' + escapeNonAscii(name);
    mangledNames[name] = newName;
    return newName;
};

var translateConstructor = function(expression) {
    if (ast.isList(expression)) {
        return 'C' + escapeNonAscii(ast.value(ast.child(expression, 0))) + ' (' + ast.join(ast.map(ast.slice(expression, 1), translateExpression), ', ') + ')';
    } else {
        return 'C' + escapeNonAscii(ast.value(expression));
    }
};

var translateMatch = function(match) {
    var cases = [];

    for (var i = 2; i < ast.size(match); i += 2) {
        cases.push(translateExpression(ast.child(match, i)) + ' -> ' + translateExpression(ast.child(match, i + 1)));
    }

    return '(match ' + translateExpression(ast.child(match, 1)) + ' with ' + cases.join(' | ') + ')';
};

var translateExpressionWithParen = function(expression) {
    if (ast.isList(expression)) {
        return '(' + translateExpression(expression) + ')';
    } else {
        return translateExpression(expression);
    }
};

var translateExpression = function(expression) {
    if (ast.isList(expression)) {
        if (ast.value(ast.child(expression, 0)) === 'match') {
            return translateMatch(expression);
        } else if (
            ast.value(ast.child(expression, 0)) === '+' ||
            ast.value(ast.child(expression, 0)) === '-' ||
            ast.value(ast.child(expression, 0)) === '*' ||
            ast.value(ast.child(expression, 0)) === '/'
        ) {
            return translateExpressionWithParen(ast.child(expression, 1)) + ' ' + ast.value(ast.child(expression, 0)) + ' ' + translateExpressionWithParen(ast.child(expression, 2));
        } else if (ast.value(ast.child(expression, 0)) === '%') {
            return translateExpressionWithParen(ast.child(expression, 1)) + ' mod ' + translateExpressionWithParen(ast.child(expression, 2));
        } else if (ast.value(ast.child(expression, 0)) === 'int32-compare') {
            return (
                'if ' +
                translateExpressionWithParen(ast.child(expression, 1)) +
                ' < ' +
                translateExpressionWithParen(ast.child(expression, 3)) +
                ' then ' +
                translateExpressionWithParen(ast.child(expression, 2)) +
                ' else ' +
                translateExpressionWithParen(ast.child(expression, 4))
            );
        } else if (ast.value(ast.child(expression, 0)) === 'fun') {
            const args = ast.child(expression, 1);
            const body = ast.child(expression, 2);
            const argString = ast.size(args) > 0 ? ast.join(ast.map(args, ast.value), ' ') : '_';
            return 'fun ' + argString + ' -> ' + translateExpression(body);
        } else if (ast.contains(constructorNames, ast.value(ast.child(expression, 0)))) {
            return translateConstructor(expression);
        } else {
            var extraArgument = '';
            if (ast.size(expression) === 1) {
                extraArgument = ' ()';
            }
            return ast.join(ast.map(expression, translateExpressionWithParen), ' ') + extraArgument;
        }
    } else {
        var name = ast.value(expression);
        if (ast.contains(constructorNames, name)) {
            return translateConstructor(expression);
        } else if (mangledNames[name]) {
            return mangledNames[name];
        } else if (Number.isInteger(parseFloat(name))) {
            return name;
        } else {
            return escapeNonAscii(name);
        }
    }
};

var translateDefinition = function(definition, mangleName) {
    var name = ast.value(ast.child(definition, 1));

    var parameters = ast.child(definition, 2);
    if (ast.size(parameters) === 0) {
        noArgumentFunctions = ast.push(noArgumentFunctions, name);
    }

    if (mangleName) {
        name = mangle('fn', name);
    }

    var expression = translateExpression(ast.child(definition, 3));

    var parameterString = '_';
    if (ast.size(parameters) > 0) {
        parameterString = ast.join(ast.map(parameters, translateExpression), ' ');
    }

    return 'let rec ' + name + ' = fun ' + parameterString + ' -> ' + expression + ';;';
};

var typeTranslator = function(typeParameters) {
    var self = function(type) {
        if (ast.isList(type)) {
            if (ast.value(ast.child(type, 0)) === 'fun') {
                var parameterString = ast.join(ast.map(ast.child(type, 1), self), ' -> ');
                return '(' + (parameterString.length > 0 ? parameterString : 'unit') + ' -> ' + self(ast.child(type, 2)) + ')';
            } else {
                var parameters = ast.map(ast.slice(type, 1), self);
                return '(' + ast.join(parameters, ', ') + ')' + ' ' + translateExpression(ast.child(type, 0));
            }
        } else {
            var value = ast.value(type);

            if (value === 'int32') {
                return 'int';
            } else {
                if (ast.contains(typeParameters, value)) {
                    return "'" + value;
                } else {
                    return translateExpression(type);
                }
            }
        }
    };

    return self;
};

var constructorTranslator = function(typeParameters, typeString) {
    return function(expression) {
        if (ast.isList(expression)) {
            var parameters = ast.map(ast.slice(expression, 1), typeTranslator(typeParameters));
            parameters = ast.map(parameters, function(parameter) {
                if (ast.contains(typeParameters, parameter)) {
                    return "'" + parameter;
                } else {
                    return parameter;
                }
            });

            constructorNames = ast.push(constructorNames, ast.value(ast.child(expression, 0)));

            return translateExpression(ast.child(expression, 0)) + ' : ' + ast.join(parameters, ' * ') + ' -> ' + typeString;
        } else {
            constructorNames = ast.push(constructorNames, translateExpression(expression));
            return translateExpression(expression);
        }
    };
};

var translateDataParameter = function(parameter) {
    if (ast.isList(parameter)) {
        return ast.value(ast.child(parameter, 1));
    } else {
        return ast.value(parameter);
    }
};

var addSingleQuote = function(parameter) {
    return "'" + parameter;
};

var translateData = function(definition) {
    var name;
    var parameters = ast.list();

    if (ast.isList(ast.child(definition, 1))) {
        var list = ast.child(definition, 1);

        name = ast.value(ast.child(list, 0));
        name = mangle('type', name);

        parameters = ast.slice(list, 1);
    } else {
        name = translateExpression(ast.child(definition, 1));
        name = mangle('type', name);
    }

    var parameterNames = ast.map(parameters, translateDataParameter);
    var finalParameters = ast.map(
        ast.filter(parameters, function(parameter) {
            return ast.isAtom(parameter);
        }),
        translateDataParameter
    );

    var parameterString = ast.join(ast.map(finalParameters, addSingleQuote), ', ');
    var typeString = (parameterString.length > 0 ? ' (' + parameterString + ')' : '') + ' ' + name;

    var constructors = ast.join(ast.map(ast.slice(definition, 2), constructorTranslator(parameterNames, typeString)), ' | ');
    return 'type' + typeString + ' = ' + constructors + ';;';
};

var translateExport = function(definition) {
    return translateDefinition(definition, false);
};

var translateModuleEntry = function(definition) {
    if (ast.isList(definition)) {
        if (ast.value(ast.child(definition, 0)) === 'def') {
            return translateDefinition(definition, true);
        } else if (ast.value(ast.child(definition, 0)) === 'export') {
            return translateExport(definition);
        } else {
            return translateData(definition);
        }
    } else {
        return '';
    }
};

var translateModule = function(definitions) {
    return ast.join(ast.map(definitions, translateModuleEntry), '\n');
};

module.exports.translate = function(expression) {
    return [{ filename: 'source.ml', contents: translateModule(expression) }];
};

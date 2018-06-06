var ast = require('../../../sexp-parser/bootstrap/ast');

var constructorNames = ast.list();
var mangledNames = {};
var noArgumentFunctions = ast.list();

var escapeNonAscii = function(name) {
    if (name === 'end') { return '_end'; }
    if (name === 'if') { return '_if'; }
    if (name === 'then') { return '_then'; }
    if (name === 'else') { return '_else'; }
    if (name === 'type') { return '_type'; }
    if (name === 'of') { return '_of'; }
    if (name === 'in') { return '_in'; }
    if (name === 'with') { return '_with'; }
    if (name === 'fun') { return '_fun'; }
    if (name === 'let') { return '_let'; }
    if (name === 'class') { return '_class'; }
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

var translateConstructor = function(expression, translator) {
    if (ast.isList(expression)) {
        return 'C' + escapeNonAscii(ast.value(ast.child(expression, 0))) + ' (' + ast.join(ast.map(ast.slice(expression, 1), translator), ', ') + ')';
    } else {
        return 'C' + escapeNonAscii(ast.value(expression));
    }
};

var translatePattern = function(pattern) {
    if (ast.isList(pattern)) {
        return translateConstructor(pattern, translatePattern);
    } else {
        var name = ast.value(pattern);
        if (Number.isInteger(parseFloat(name))) {
            return name + 'l';
        } else if (ast.contains(constructorNames, name)) {
            return translateConstructor(pattern, translatePattern);
        } else {
            return mangle('ptrn', name);
        }
    }
};

var translateMatch = function(match) {
    var cases = [];

    for (var i = 2; i < ast.size(match); i += 2) {
        cases.push(translatePattern(ast.child(match, i)) + ' -> ' + translateExpression(ast.child(match, i + 1)));
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

const operatorMap = {
    '+': 'Int32.add',
    '-': 'Int32.sub',
    '*': 'Int32.mul',
    '/': 'Int32.div',
    '%': 'Int32.rem'
};

var nestFunctionApplications = function(functions, argument) {
    if (ast.size(functions) === 0) {
        return argument;
    } else {
        var f = ast.child(functions, 0);
        return '(' + translateExpressionWithParen(f) + ' ' + nestFunctionApplications(ast.slice(functions, 1), argument) + ')';
    }
};

var isSpecialForm = function(expression, name) {
    return ast.size(expression) > 0 && ast.isAtom(ast.child(expression, 0)) && ast.value(ast.child(expression, 0)) === name;
};

var listFromArray = function(array) {
    if (ast.size(array) === 0) {
	return 'CEmpty';
    } else {
	return 'CCons (' + translateExpression(ast.child(array, 0)) + ', ' + listFromArray(ast.slice(array, 1)) + ')';
    }
};

var translateExpression = function(expression) {
    if (ast.isList(expression)) {
        if (isSpecialForm(expression, 'match')) {
            return translateMatch(expression);
        } else if (
            isSpecialForm(expression, '+') ||
            isSpecialForm(expression, '-') ||
            isSpecialForm(expression, '*') ||
            isSpecialForm(expression, '/') ||
            isSpecialForm(expression, '%')
        ) {
            return operatorMap[ast.value(ast.child(expression, 0))] + ' ' + translateExpressionWithParen(ast.child(expression, 1)) + ' ' + translateExpressionWithParen(ast.child(expression, 2));
        } else if (isSpecialForm(expression, 'int32-less-than')) {
            return (
                'if ' +
                translateExpressionWithParen(ast.child(expression, 1)) +
                ' < ' +
                translateExpressionWithParen(ast.child(expression, 2)) +
                ' then ' +
                translateExpressionWithParen(ast.child(expression, 3)) +
                ' else ' +
                translateExpressionWithParen(ast.child(expression, 4))
            );
        } else if (isSpecialForm(expression, 'fn')) {
            const args = ast.child(expression, 1);
            const body = ast.child(expression, 2);
            const argString = ast.size(args) > 0 ? ast.join(ast.map(args, translateExpression), ' ') : '_';
            return 'fun ' + argString + ' -> ' + translateExpression(body);
        } else if (isSpecialForm(expression, 'pipe')) {
            const args = ast.reverse(ast.slice(expression, 1));
            return 'fun _x1 -> ' + nestFunctionApplications(args, '_x1');
	} else if (isSpecialForm(expression, 'list')) {
            const args = ast.slice(expression, 1);
            return listFromArray(args);

       } else if (ast.isAtom(ast.child(expression, 0)) && ast.contains(constructorNames, ast.value(ast.child(expression, 0)))) {
            return translateConstructor(expression, translateExpression);
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
            return translateConstructor(expression, translateExpression);
        } else if (mangledNames[name]) {
            return mangledNames[name];
        } else if (Number.isInteger(parseFloat(name))) {
            return '(Int32.of_int (' + name + '))';
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
            if (ast.value(ast.child(type, 0)) === 'fn') {
                var parameterString = ast.join(ast.map(ast.child(type, 1), self), ' -> ');
                return '(' + (parameterString.length > 0 ? parameterString : 'unit') + ' -> ' + self(ast.child(type, 2)) + ')';
            } else {
                var parameters = ast.map(ast.slice(type, 1), self);
                return '(' + ast.join(parameters, ', ') + ')' + ' ' + translateExpression(ast.child(type, 0));
            }
        } else {
            var value = ast.value(type);

            if (value === 'int32') {
                return value;
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
        name = ast.value(ast.child(definition, 1));
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

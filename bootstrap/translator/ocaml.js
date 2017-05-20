
var ast = require('../parser/ast');

var constructorNames = ast.list();
var mangledNames = {};
var noArgumentFunctions = ast.list();

var escapeNonAscii = function (name) {
    var newName = '';
    for (var i = 0; i < name.length; ++i) {
        var char = name.charCodeAt(i);

        if ((char >= 65 && char <= 90) || (char >= 97 && char <= 122))  {
            newName += String.fromCharCode(char);
        } else {
            newName += '_' + char;
        }
    }
    return newName;
};

var mangle = function (prefix, name) {
    var newName = prefix + '_' + escapeNonAscii(name);
    mangledNames[name] = newName;
    return newName;
};

var translateConstructor = function (expression) {
    if (ast.isList(expression)) {
        return translateExpression(ast.child(expression, 0)) + ' (' + ast.join(ast.map(ast.slice(expression, 1), translateExpression), ', ') + ')';
    } else {
        return translateExpression(expression);
    }
};

var translateMatch = function (match) {
    var cases = [];

    for (var i = 2; i < ast.size(match); i += 2) {
        cases.push(translateExpression(ast.child(match, i)) + ' -> ' + translateExpression(ast.child(match, i + 1)));
    }

    return 'match ' + translateExpression(ast.child(match, 1)) + ' with ' + cases.join(' | ');
};

var translateExpressionWithParen = function (expression) {
    if (ast.isList(expression)) {
        return '(' + translateExpression(expression) + ')';
    } else {
        return translateExpression(expression);
    }
}

var translateExpression = function (expression) {
    if (ast.isList(expression)) {
        if (ast.value(ast.child(expression, 0)) === 'match') {
            return translateMatch(expression);
        } else if (ast.value(ast.child(expression, 0)) === '+'
                || ast.value(ast.child(expression, 0)) === '-'
                || ast.value(ast.child(expression, 0)) === '*'
                || ast.value(ast.child(expression, 0)) === '/') {
            return translateExpressionWithParen(ast.child(expression, 1)) + ' ' + ast.value(ast.child(expression, 0)) + ' ' + translateExpressionWithParen(ast.child(expression, 2));
        } else if (ast.value(ast.child(expression, 0)) === '%') {
            return translateExpressionWithParen(ast.child(expression, 1)) + ' mod ' + translateExpressionWithParen(ast.child(expression, 2));
        } else if (ast.value(ast.child(expression, 0)) === 'int32-compare') {
            return 'if ' + translateExpressionWithParen(ast.child(expression, 1)) + ' < ' + translateExpressionWithParen(ast.child(expression, 3)) + ' then ' + translateExpressionWithParen(ast.child(expression, 2)) + ' else ' + translateExpressionWithParen(ast.child(expression, 4));
        } else if (ast.contains(constructorNames, ast.value(ast.child(expression, 0)))) {
            return translateConstructor(expression);
        } else {
            var extraArgument = '';
            if (ast.contains(noArgumentFunctions, ast.value(ast.child(expression, 0)))) {
                extraArgument = ' ()';
            }
            return ast.join(ast.map(expression, translateExpressionWithParen), ' ') + extraArgument;
        }
    } else {
        var name = ast.value(expression);
        if (mangledNames[name]) {
            return mangledNames[name];
        } else {
            return name;
        }
    }
};

var translateDefinition = function (definition, mangleName) {
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

var typeTranslator = function (typeParameters) {
    var self = function (type) {
        if (ast.isList(type)) {
            var parameters = ast.map(ast.slice(type, 1), self);

            parameters = ast.map(parameters, function (parameter) {
                if (ast.contains(typeParameters, parameter)) {
                    return '\'' + parameter;
                } else {
                    return parameter;
                }
            });

            return ast.join(parameters, ' ') + ' ' + translateExpression(ast.child(type, 0));
        } else {
            return translateExpression(type);
        }
    };

    return self;
};

var constructorTranslator = function (typeParameters) {
    return function (expression) {
        if (ast.isList(expression)) {
            var parameters = ast.map(ast.slice(expression, 1), typeTranslator(typeParameters));
            parameters = ast.map(parameters, function (parameter) {
                if (ast.contains(typeParameters, parameter)) {
                    return '\'' + parameter;
                } else {
                    return parameter;
                }
            });

            constructorNames = ast.push(constructorNames, translateExpression(ast.child(expression, 0)));

            return translateExpression(ast.child(expression, 0)) + ' of ' + ast.join(parameters, ' * ');
        } else {
            constructorNames = ast.push(constructorNames, translateExpression(expression));
            return translateExpression(expression);
        }
    };
};

var translateData = function (definition) {
    var name;
    var parameters = ast.list();

    if (ast.isList(ast.child(definition, 1))) {
        var list = ast.child(definition, 1);

        name = ast.value(ast.child(list, 0));
        name = mangle('type', name);

        parameters = ast.map(ast.slice(list, 1), translateExpression);
    } else {
        name = translateExpression(ast.child(definition, 1));
        name = mangle('type', name);
    }

    var constructors = ast.join(ast.map(ast.slice(definition, 2), constructorTranslator(parameters)), ' | ');
    parameters = ast.join(ast.map(parameters, function (p) { return '\'' + p; }), ', ');
    return 'type ' + (parameters.length > 0 ? '(' + parameters + ')' : '') + ' ' + name + ' = ' + constructors + ';;';
};

var translateExport = function (definition) {
    return translateDefinition(definition, false);
};

var translateModuleEntry = function (definition) {
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

var translateModule = function (definitions) {
    return ast.join(ast.map(definitions, translateModuleEntry), '\n');
};

module.exports.translate = function (expression) {
    return [
        {filename: 'src/source.ml', contents: translateModule(expression)},
        {filename: 'bsconfig.json', contents: '{"name" : "hello", "sources" : { "dir" : "src" }}'},
        {filename: 'package.json', contents: '{ "dependencies": { "bs-platform": "1.7.0" }, "scripts" : { "compile" : "bsb", "watch" : "bsb -w" } }'}
    ];
};

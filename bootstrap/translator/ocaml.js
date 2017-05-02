
var ast = require('../parser/ast');

var translateConstructor = function (expression) {
    if (ast.isList(expression)) {
        return ast.value(ast.child(expression, 0)) + ' (' + ast.join(ast.map(ast.slice(expression, 1), ast.value), ', ') + ')';
    } else {
        return ast.value(expression);
    }
};

var translateMatch = function (match) {
    var cases = [];

    for (var i = 2; i < ast.size(match); i += 2) {
        cases.push(translateConstructor(ast.child(match, i)) + ' -> ' + translateExpression(ast.child(match, i + 1)));
    }

    return 'match ' + translateConstructor(ast.child(match, 1)) + ' with ' + cases.join(' | ');
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
        } else {
            return ast.join(ast.map(expression, translateExpressionWithParen), ' ');
        }
    } else {
        return ast.value(expression);
    }
};

var translateDefinition = function (definition) {
    var name = ast.value(ast.child(definition, 1));
    var parameters = ast.child(definition, 2);
    var expression = translateExpression(ast.child(definition, 3));

    var parameterString = '_';
    if (ast.size(parameters) > 0) {
        parameterString = ast.join(ast.map(parameters, ast.value), ' ');
    }

    return 'let rec ' + name + ' = fun ' + parameterString + ' -> ' + expression + ';;';
};

var typeTranslator = function (typeParameters) {
    return function (type) {
        if (ast.isList(type)) {
            var parameters = ast.map(ast.slice(type, 1), ast.value);

            parameters = ast.map(parameters, function (parameter) {
                if (ast.contains(typeParameters, parameter)) {
                    return '\'' + parameter;
                } else {
                    return parameter;
                }
            });

            return ast.join(parameters, ' ') + ' ' + ast.value(ast.child(type, 0));
        } else {
            return ast.value(type);
        }
    };
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
            return ast.value(ast.child(expression, 0)) + ' of ' + ast.join(parameters, ' * ');
        } else {
            return ast.value(expression);
        }
    };
};

var translateData = function (definition) {
    var name;
    var parameters = ast.list();

    if (ast.isList(ast.child(definition, 1))) {
        var list = ast.child(definition, 1);
        var translations = ast.map(list, translateExpression);

        parameters = ast.slice(translations, 1);
        name = ast.child(translations, 0);
    } else {
        name = ast.value(ast.child(definition, 1));
    }

    var constructors = ast.join(ast.map(ast.slice(definition, 2), constructorTranslator(parameters)), ' | ');
    parameters = ast.join(ast.map(parameters, function (p) { return '\'' + p; }), ' ');
    return 'type ' + parameters + ' ' + name + ' = ' + constructors + ';;';
};

var translateModuleEntry = function (definition) {
    if (ast.isList(definition)) {
        if (ast.value(ast.child(definition, 0)) === 'define') {
            return translateDefinition(definition);
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
        {filename: 'package.json', contents: '{ "dependencies": { "bs-platform": "1.7.0" }, "scripts" : { "build" : "bsb", "watch" : "bsb -w" } }'}
    ];
};

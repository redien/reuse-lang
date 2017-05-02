
var ast = require('../parser/ast');

var translateExpression = function (expression) {
    if (ast.isList(expression)) {
        var translations = [];

        for (var i = 0; i < ast.size(expression); ++i) {
            var subExpression = ast.child(expression, i);
            translations.push(translateExpression(subExpression));
        }

        return '(' + translations.join(' ') + ')';
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
        var translations = [];

        for (var i = 0; i < ast.size(parameters); ++i) {
            translations.push(ast.value(ast.child(parameters, i)));
        }

        parameterString = translations.join(' ');
    }

    return 'let ' + name + ' = fun ' + parameterString + ' -> ' + expression + ';;';
};

var translateModule = function (definitions) {
    var translations = [];

    for (var i = 0; i < ast.size(definitions); ++i) {
        var definition = ast.child(definitions, i);
        if (ast.isList(definition)) {
            translations.push(translateDefinition(definition));
        }
    }

    return translations.join('\n');
};

module.exports.translate = function (expression) {
    return [
        {filename: 'src/source.ml', contents: translateModule(expression)},
        {filename: 'bsconfig.json', contents: '{"name" : "hello", "sources" : { "dir" : "src" }}'},
        {filename: 'package.json', contents: '{ "dependencies": { "bs-platform": "1.7.0" }, "scripts" : { "build" : "bsb", "watch" : "bsb -w" } }'}
    ];
};

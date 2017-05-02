
var ast = require('../parser/ast');

var translateExpression = function (expression) {
    return ast.value(expression);
};

var translateDefinition = function (definition) {
    var name = ast.value(ast.child(definition, 1));
    var expression = translateExpression(ast.child(definition, 3));

    return 'let ' + name + ' = fun _ -> ' + expression + ';;';
};

module.exports.translate = function (expression) {
    return [
        {filename: 'src/source.ml', contents: translateDefinition(expression)},
        {filename: 'bsconfig.json', contents: '{"name" : "hello", "sources" : { "dir" : "src" }}'},
        {filename: 'package.json', contents: '{ "dependencies": { "bs-platform": "1.7.0" }, "scripts" : { "build" : "bsb", "watch" : "bsb -w" } }'}
    ];
};

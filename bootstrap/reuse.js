
var parser = require(__dirname + '/parser/parser');
var ast = require(__dirname + '/parser/ast');
var Immutable = require('immutable');
var fs = require('fs');

var translate = function (expression) {
    var parseResult = parser.parse(expression);
    if (parseResult.error) {
        return {
            errors: Immutable.List.of(parseResult.error)
        };
    }

    var expression = ast.child(parseResult.ast, 0);

    return require(__dirname + '/translator/ocaml').translate(expression);
};

if (!fs.existsSync(__dirname + '/../generated')) {
    fs.mkdirSync(__dirname + '/../generated');
}

if (!fs.existsSync(__dirname + '/../generated/bootstrap')) {
    fs.mkdirSync(__dirname + '/../generated/bootstrap');
}

if (!fs.existsSync(__dirname + '/../generated/bootstrap/src')) {
    fs.mkdirSync(__dirname + '/../generated/bootstrap/src');
}

var source = fs.readFileSync(__dirname + '/../minimal-interpreter/source.lisp', 'utf8');
var compiled = translate(source);
compiled.forEach(function (entry) {
    fs.writeFileSync(__dirname + '/../generated/bootstrap/' + entry.filename, entry.contents, 'utf8');
});

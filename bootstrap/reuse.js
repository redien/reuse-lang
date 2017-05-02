
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

if (!fs.existsSync(__dirname + '/../generated/' + process.argv[3] + '')) {
    fs.mkdirSync(__dirname + '/../generated/' + process.argv[3] + '');
}

if (!fs.existsSync(__dirname + '/../generated/' + process.argv[3] + '/src')) {
    fs.mkdirSync(__dirname + '/../generated/' + process.argv[3] + '/src');
}

var source = fs.readFileSync(process.argv[2], 'utf8');
var compiled = translate(source);
compiled.forEach(function (entry) {
    fs.writeFileSync(__dirname + '/../generated/' + process.argv[3] + '/' + entry.filename, entry.contents, 'utf8');
});

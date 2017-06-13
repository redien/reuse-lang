
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

    return require(__dirname + '/translator/' + (process.argv[4] || 'ocaml')).translate(parseResult.ast);
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

if (compiled.errors) {
    compiled.errors.forEach(function (error) {
        console.error(error.message);
        console.error('at line', error.line, 'and column', error.column);
    });
    process.exit(1);
}

compiled.forEach(function (entry) {
    var path = __dirname + '/../generated/' + process.argv[3] + '/' + entry.filename;
    console.error('writing file', path);
    fs.writeFileSync(path, entry.contents, 'utf8');
});
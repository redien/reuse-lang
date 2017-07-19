var parser = require('../../parser/bootstrap/parser');
var ast = require('../../parser/bootstrap/ast');
var Immutable = require('immutable');
var fs = require('fs');

var translate = function(expression) {
    var parseResult = parser.parse(expression);
    if (parseResult.error) {
        return {
            errors: Immutable.List.of(parseResult.error)
        };
    }

    return require('./translator/' + (process.argv[4] || 'ocaml')).translate(parseResult.ast);
};

var source = fs.readFileSync(process.argv[2], 'utf8');
var compiled = translate(source);

if (compiled.errors) {
    compiled.errors.forEach(function(error) {
        console.error(error.message);
        console.error('at line', error.line, 'and column', error.column);
    });
    process.exit(1);
}

compiled.forEach(function(entry) {
    var path = process.argv[3] + '/' + entry.filename;
    console.error('writing file', path);
    fs.writeFileSync(path, entry.contents, 'utf8');
});

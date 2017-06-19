var fs = require('fs');
var ast = require(__dirname + '/../../parser/ast');
var parser = require(__dirname + '/../../parser/parser');

function translateDefinition(state, definition) {
    return definition;
}

function rewriteModule(state, definitions) {
    return ast.map(definitions, translateDefinition.bind(null, state));
}

function parse(source) {
    var result = parser.parse(source);
    return result.ast;
}

var input = fs.readFileSync(process.argv[2], 'utf8');
var expressions = parse(input);
var rewrittenExpression = rewriteModule({}, expressions);
var output = ast.join(ast.map(rewrittenExpression, ast.toString), ' ');
fs.writeFileSync(process.argv[3], output, 'utf8');

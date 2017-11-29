
var fs = require('fs');
var interpret = require(__dirname + '/eval.js').interpret;
var Immutable = require('immutable');
var ast = require('../../../parser/bootstrap/ast');

var source = fs.readFileSync(process.argv[2], 'utf8');
var expression = process.argv[3];
var stdin = fs.readFileSync(process.argv[4], 'utf8');

function fromJs(stdin) {
   return stdin.split('').reverse().reduce((xs, x) => ast.list({type: 'constructor', name: 'Cons'}, x.codePointAt(0), xs), {type: 'constructor', name: 'Empty'});
}

function toJs(value) {
    if (ast.isList(value)) {
        return String.fromCharCode(ast.child(value, 1)) + toJs(ast.child(value, 2));
    } else {
        return '';
    }
}

const result = interpret(source, expression, [{name: 'stdin', value: fromJs(stdin)}]);
if (typeof result === 'number') {
    console.log(result);
} else {
    console.log(toJs(result));
}


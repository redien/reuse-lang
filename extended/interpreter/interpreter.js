
var fs = require('fs');
var interpret = require(__dirname + '/eval.js').interpret;
var Immutable = require('immutable');

var source = fs.readFileSync(process.argv[2], 'utf8');
var expression = process.argv[3];
var stdin = fs.readFileSync(process.argv[4], 'utf8');

function jsToImmutableString(stdin) {
   return stdin.split('').reduce(function (list, character) {
       return [...list, character.codePointAt(0)];
   }, []);
}

console.log(interpret(source, expression, [{name: 'stdin', value: jsToImmutableString(stdin)}]));


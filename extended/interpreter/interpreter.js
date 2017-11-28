
var fs = require('fs');
var interpret = require(__dirname + '/eval.js').interpret;
var Immutable = require('immutable');

var source = fs.readFileSync(process.argv[2], 'utf8');
var expression = process.argv[3];
var stdin = fs.readFileSync(process.argv[4], 'utf8');

console.log(interpret(source, expression, (symbol) => {
    console.error(symbol + ' is not defined');
}));


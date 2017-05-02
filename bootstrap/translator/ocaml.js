
var ast = require('../parser/ast');

module.exports.translate = function (expression) {
    return [
        {filename: 'src/source.ml', contents: 'let execute = fun _ -> 1;;'},
        {filename: 'bsconfig.json', contents: '{"name" : "hello", "sources" : { "dir" : "src" }}'},
        {filename: 'package.json', contents: '{ "dependencies": { "bs-platform": "1.7.0" }, "scripts" : { "build" : "bsb", "watch" : "bsb -w" } }'}
    ];
};

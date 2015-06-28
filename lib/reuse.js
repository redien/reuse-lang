
// reuse-lang - a pure functional lisp-like language for writing
// reusable algorithms in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var parser = require('../lib/parser');
var translator = require('../lib/translator');
var map = require('../lib/ast-map');
var i32Constructor = require('../lib/i32-constructor');

exports.translate = function (program) {
    var ast = parser.parse(program);
    if (ast.error) { return ast; }

    try {
        ast = map(i32Constructor, ast.asts[0]);
    } catch (error) {
        return {error: error};
    }

    return translator.translate(ast);
};


var ast = require('../parser/ast');

var counter = 0;

var constructorNames = [];

var escapeNonAscii = function (name) {
    var newName = '';
    for (var i = 0; i < name.length; ++i) {
        var char = name.charCodeAt(i);

        if ((char >= 65 && char <= 90) || (char >= 97 && char <= 122))  {
            newName += String.fromCharCode(char);
        } else {
            newName += '_' + char;
        }
    }
    return newName;
};

var translateConstructorVariables = function (variables) {
    var result = '';

    for (var i = 0; i < ast.size(variables); ++i) {
        result += 'var ' + escapeNonAscii(ast.value(ast.child(variables, i))) + '=$.values[' + i + '];';
    }

    return result;
};

var translateMatch = function (match) {
    var cases = [];

    for (var i = 2; i < ast.size(match); i += 2) {
        var _constructor = ast.child(match, i);
        if (ast.isList(_constructor)) {
            cases.push('case ' + escapeNonAscii(ast.value(ast.child(_constructor, 0))) + ':' + translateConstructorVariables(ast.slice(_constructor, 1)) + 'return ' + translateExpression(ast.child(match, i + 1)) + ';');
        } else {
            cases.push('case ' + escapeNonAscii(ast.value(_constructor)) + ':return ' + translateExpression(ast.child(match, i + 1)) + ';');
        }
    }

    return '(function($){switch($.type){' + cases.join('') + '}})(' + translateExpression(ast.child(match, 1)) + ')';
};

var translateExpression = function (expression) {
    if (ast.isList(expression)) {
        if (ast.value(ast.child(expression, 0)) === 'match') {
            return translateMatch(expression);
        } else if (ast.value(ast.child(expression, 0)) === '+'
                || ast.value(ast.child(expression, 0)) === '-'
                || ast.value(ast.child(expression, 0)) === '*'
                || ast.value(ast.child(expression, 0)) === '/'
                || ast.value(ast.child(expression, 0)) === '%') {
            return '(' + translateExpression(ast.child(expression, 1)) + ast.value(ast.child(expression, 0)) + translateExpression(ast.child(expression, 2)) + '|0)';
        } else if (ast.value(ast.child(expression, 0)) === 'int32-compare') {
            return '(' + translateExpression(ast.child(expression, 1)) + '<' + translateExpression(ast.child(expression, 3)) + '?' + translateExpression(ast.child(expression, 2)) + ':' + translateExpression(ast.child(expression, 4)) + ')';
        } else {
            return translateExpression(ast.child(expression, 0)) + '(' + ast.join(ast.map(ast.slice(expression, 1), translateExpression), ',') + ')';
        }
    } else {
        var name = ast.value(expression);
        if (!isNaN(parseFloat(name)) && isFinite(name)) {
            return (parseInt(name, 10) | 0).toString();
        } else {
            return escapeNonAscii(name);
        }
    }
};

var translateDefinition = function (definition, exportStatement) {
    var name = ast.value(ast.child(definition, 1));

    var expression = translateExpression(ast.child(definition, 3));

    var parameters = ast.child(definition, 2);
    var parameterString = ast.join(ast.map(parameters, translateExpression), ',');

    var moduleExport = '';
    if (exportStatement) {
        moduleExport = 'module.exports.' + name + '=' + escapeNonAscii(name) + ';'
    }

    return 'function ' + escapeNonAscii(name) + '(' + parameterString + '){return ' + expression + ';}' + moduleExport;
};

var translateDataConstructor = function (expression) {
    if (ast.isList(expression)) {
        return 'var ' + escapeNonAscii(ast.value(ast.child(expression, 0))) + '=function _self(){return {type:_self,values:arguments}};';
    } else {
        return 'var ' + escapeNonAscii(ast.value(expression)) + '={};' + escapeNonAscii(ast.value(expression)) + '.type=' + escapeNonAscii(ast.value(expression)) + ';';
    }
};

var translateData = function (definition) {
    return ast.join(ast.map(ast.slice(definition, 2), translateDataConstructor), '\n');
};

var translateModuleEntry = function (definition) {
    if (ast.isList(definition)) {
        if (ast.value(ast.child(definition, 0)) === 'def') {
            return translateDefinition(definition, false);
        } else if (ast.value(ast.child(definition, 0)) === 'export') {
            return translateDefinition(definition, true);
        } else {
            return translateData(definition);
        }
    } else {
        return '';
    }
};

var translateModule = function (definitions) {
    return ast.join(ast.map(definitions, translateModuleEntry), '\n');
};

module.exports.translate = function (expression) {
    return [
        {filename: 'src/source.js', contents: translateModule(expression)}
    ];
};

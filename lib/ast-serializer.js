
module.exports = function serialize (ast) {
    if (ast.kind === 'atom') {
        return ast.value;
    } else {
        var str = '(';
        var index;
        for (index = 0; index < ast.elements.length; ++index) {
            var element = ast.elements[index];
            if (index !== 0) {
                str += ' ';
            }
            str += serialize(element);
        }

        return str + ')';
    }
};

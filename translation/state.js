
var Immutable = require('immutable');

var state = module.exports;

state.new = function (expression, artifacts) {
    expression = expression || Immutable.List();
    artifacts = artifacts || Immutable.List();
    return Immutable.Map.of('expression', expression, 'artifacts', artifacts, 'uniqueId', 0);
};

state.setExpression = function (state, expression) {
    return state.set('expression', expression);
};

state.addDefinition = function (state, definitions) {
    var artifacts = state.get('artifacts');
    artifacts = artifacts.concat(definitions.map(function (definition) {
        return {
            type: 'definition',
            value: definition
        };
    }));
    return state.set('artifacts', artifacts);
};

state.addLambda = function (state, expression) {
    state = state.incrementUniqueId(state);
    var id = 'reuse_gen_lambda' + state.uniqueId(state);

    var artifacts = state.get('artifacts');
    artifacts = artifacts.push({
        type: 'lambda',
        id: id,
        expression: expression
    });
    state = state.set('artifacts', artifacts);
    return state.set('expression', id);
};

state.findLambda = function (state, id) {
    var artifacts = state.get('artifacts');
    for (var index = artifacts.size - 1; index >= 0; --index) {
        var artifact = artifacts.get(index);
        if (artifact.type === 'lambda' && artifact.id === id) {
            return artifact.expression;
        }
    }
    return null;
};

state.incrementUniqueId = function (state) {
    var id = state.get('uniqueId');
    id += 1;
    return state.set('uniqueId', id);
};

state.expression = function (state) {
    var expression = state.get('expression');
    return Immutable.List.isList(expression) ? expression.join('') : expression;
};

state.definitions = function (state) {
    return state.get('artifacts').filter(function (artifact) {
        return artifact.type === 'definition';
    }).map(function (artifact) {
        return artifact.value;
    }).join('');
};

state.uniqueId = function (state) {
    return state.get('uniqueId');
};

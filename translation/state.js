
var Immutable = require('immutable');

var state = module.exports;

state.new = function (expression, definitions) {
    expression = expression || '';
    definitions = definitions || '';
    return Immutable.Map.of('expression', expression, 'definitions', definitions, 'lambdaId', 0);
};

state.setExpression = function (state, expression) {
    return state.set('expression', expression);
};

state.addDefinition = function (state, definition) {
    var definitions = state.get('definitions');
    definitions += definition;
    return state.set('definitions', definitions);
};

state.incrementLambdaId = function (state) {
    var id = state.get('lambdaId');
    id += 1;
    return state.set('lambdaId', id);
}

state.expression = function (state) {
    return state.get('expression');
};

state.definitions = function (state) {
    return state.get('definitions');
};

state.lambdaId = function (state) {
    return state.get('lambdaId');
};

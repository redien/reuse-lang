
var $textEncoder = typeof TextEncoder != "undefined" ? new TextEncoder() : null;
var $textDecoder = typeof TextDecoder != "undefined" ? new TextDecoder() : null;
var $textEncode = $textEncoder ? $textEncoder.encode : Buffer.from;
var $textDecode = $textDecoder ? (bytes => $textDecoder.decode(new Uint8Array(bytes))) : (bytes => Buffer.from(bytes).toString());

function js_string_to_reuse(s) {
    var view = $textEncode(s);
    var reuse_string = string_empty();
    for (var byte of view) {
        reuse_string = string_append(byte)(reuse_string);
    }
    return reuse_string;
}
module.exports.js_string_to_reuse = js_string_to_reuse;

function js_list_to_reuse(l) {
    return l.reduceRight(function (a, b) { return list_cons(b)(a); }, list_empty());
}
module.exports.js_list_to_reuse = js_list_to_reuse;

function reuse_string_to_js(s) {
    var bytes = [];
    string_foldl(a => _ => bytes.push(a))(undefined)(s);
    return $textDecode(bytes);
}
module.exports.reuse_string_to_js = reuse_string_to_js;

function reuse_boolean_to_js(b) {
    return b === True;
}
module.exports.reuse_boolean_to_js = reuse_boolean_to_js;

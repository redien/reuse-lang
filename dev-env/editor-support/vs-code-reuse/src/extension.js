
const vscode = require('vscode');
const formatter = require('./formatter');
const { match, $, Result, Cons, Empty, Pair } = formatter;

function replaceDocument(document, text) {
    const firstLine = document.lineAt(0);
    const lastLine = document.lineAt(document.lineCount - 1);
    return [vscode.TextEdit.replace(new vscode.Range(firstLine.range.start, lastLine.range.end), text)];
}

function activate(context) {
    vscode.languages.registerDocumentFormattingEditProvider('reuse', {
        provideDocumentFormattingEdits: document => {
            const text = document.getText();
            const buffer = Buffer.from(text);
            const sourceFile = formatter.source_file_of(formatter.ModuleSelf, formatter.string_empty(), buffer)
            const result = formatter.format_source_files(formatter.list_from(sourceFile));
            return match(result, [
                [Result, [Cons, [Pair, $, $], Empty]], (x, formattedFile) =>
                    replaceDocument(document, (Buffer.from(formattedFile).toString())),
                $, () =>
                    []
            ]);
        }
    });
}

function deactivate() {

}

module.exports = {
    activate,
    deactivate
};

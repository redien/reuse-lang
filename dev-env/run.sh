#!/usr/bin/env bash

project_root=$(dirname $0)/..

run() {
    case $1 in
        test)                   run test-compilers && run test-sexp-parser && run test-parser && run test-standard-library ;;
        test-compilers)         run test-ocaml-compiler && run test-minimal-compiler ;;
        test-ocaml-compiler)    $project_root/extended/ocaml-compiler/build.sh && IMPL=extended/ocaml-compiler run test-extended && IMPL=extended/ocaml-compiler run test-minimal ;;
        test-minimal-compiler)  $project_root/extended/minimal-compiler/build.sh && IMPL=extended/minimal-compiler run test-minimal && IMPL=extended/minimal-compiler run test-extended ;;
        test-sexp-parser)       $project_root/sexp-parser/build.sh && $project_root/dev-env/spec-runner/run.sh sexp-parser/specification $project_root/sexp-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-parser)            $project_root/parser/build.sh && $project_root/dev-env/spec-runner/run.sh parser/specification $project_root/parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-standard-library)  $project_root/standard-library/build.sh && $project_root/dev-env/spec-runner/run.sh standard-library/specification $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-inference)    $project_root/type-inference/build.sh && $project_root/dev-env/spec-runner/run.sh type-inference/specification $project_root/type-inference/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-unification)  $project_root/type-unification/build.sh && $project_root/dev-env/spec-runner/run.sh type-unification/specification $project_root/type-unification/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-string-gen)        $project_root/string-gen/build.sh && $project_root/dev-env/spec-runner/run.sh string-gen/specification $project_root/string-gen/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-minimal)           $project_root/dev-env/spec-runner/run.sh minimal/specification $project_root/$IMPL/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-extended)          $project_root/dev-env/spec-runner/run.sh extended/specification $project_root/$IMPL/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        diagnostics)            $project_root/extended/ocaml-compiler/diagnostics.sh ;;
        line-count)             (cd $project_root ; git ls-files | grep '\.reuse' | xargs wc -l) ;;
        vscode-install)         ln -s $PWD/$project_root/dev-env/editor-support/vs-code-reuse ~/.vscode/extensions/vs-code-reuse ;;
    esac
}

run $1

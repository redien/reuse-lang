#!/usr/bin/env bash

run() {
    case $1 in
        test)                   run test-compilers && run test-sexp-parser && run test-parser && run test-standard-library ;;
        test-compilers)         run test-ocaml-compiler && run test-minimal-compiler ;;
        test-ocaml-compiler)    extended/ocaml-compiler/build.sh && IMPL=extended/ocaml-compiler run test-extended && IMPL=extended/ocaml-compiler run test-minimal ;;
        test-minimal-compiler)  extended/minimal-compiler/build.sh && IMPL=extended/minimal-compiler run test-minimal && IMPL=extended/minimal-compiler run test-extended ;;
        test-sexp-parser)       sexp-parser/build.sh && ./dev-env/spec-runner/run.sh sexp-parser/specification ./sexp-parser/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        test-parser)            parser/build.sh && ./dev-env/spec-runner/run.sh parser/specification ./parser/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        test-standard-library)  standard-library/build.sh && ./dev-env/spec-runner/run.sh standard-library/specification ./standard-library/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        test-type-inference)    type-inference/build.sh && ./dev-env/spec-runner/run.sh type-inference/specification ./type-inference/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        test-type-unification)  type-unification/build.sh && ./dev-env/spec-runner/run.sh type-unification/specification ./type-unification/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        test-string-gen)        string-gen/build.sh && ./dev-env/spec-runner/run.sh string-gen/specification ./string-gen/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        test-minimal)           ./dev-env/spec-runner/run.sh minimal/specification ./$IMPL/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        test-extended)          ./dev-env/spec-runner/run.sh extended/specification ./$IMPL/eval.sh | ./dev-env/tap-format/tap-format.sh ;;
        line-count)             git ls-files | grep '\.reuse' | xargs wc -l ;;
        vscode-install)         ln -s $PWD/dev-env/editor-support/vs-code-reuse ~/.vscode/extensions/vs-code-reuse ;;
    esac
}

run $1

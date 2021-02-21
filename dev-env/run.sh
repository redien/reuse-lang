#!/usr/bin/env bash

script_path=$(dirname $0)
project_root=$script_path/..

run() {
    case $1 in
        test)                           run test-string-gen && run test-sexp-parser && run test-parser && run test-compilers && run test-interpreter && run test-standard-library;;
        test-interpreter)               $project_root/interpreter/build-for-test.sh && IMPL=interpreter run test-minimal && IMPL=interpreter run test-extended ;;
        test-compilers)                 run test-ocaml-compiler && run test-haskell-compiler && run test-javascript-compiler ;;
        test-module-compiler)           $project_root/compiler-backend/module/build-for-test.sh && IMPL=compiler-backend/module run test-minimal && IMPL=compiler-backend/module run test-extended ;;
        test-ocaml-compiler)            $project_root/compiler-backend/ocaml/build-for-test.sh && IMPL=compiler-backend/ocaml run test-minimal && IMPL=compiler-backend/ocaml run test-extended ;;
        test-haskell-compiler)          $project_root/compiler-backend/haskell/build-for-test.sh && IMPL=compiler-backend/haskell run test-minimal && IMPL=compiler-backend/haskell run test-extended ;;
        test-javascript-compiler)       $project_root/compiler-backend/javascript/build-for-test.sh && IMPL=compiler-backend/javascript run test-minimal && IMPL=compiler-backend/javascript run test-extended ;;
        test-sexp-parser)               $project_root/sexp-parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh sexp-parser/specification $project_root/sexp-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-parser)                    $project_root/parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh parser/specification $project_root/parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-standard-library)          $project_root/standard-library/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh standard-library/specification $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-inference)            $project_root/type-inference/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh type-inference/specification $project_root/type-inference/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-unification)          $project_root/type-unification/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh type-unification/specification $project_root/type-unification/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-string-gen)                $project_root/string-gen/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh string-gen/specification $project_root/string-gen/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-minimal)                   $project_root/dev-env/spec-runner/run.sh specification/minimal $project_root/$IMPL/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-extended)                  $project_root/dev-env/spec-runner/run.sh specification/extended $project_root/$IMPL/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        line-count)                     (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings)' | xargs wc -l) ;;
        line-count-with-spec)           (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings|spec)' | xargs wc -l) ;;
        vscode-install)                 ln -s $PWD/$project_root/dev-env/editor-support/vs-code-reuse ~/.vscode/extensions/vs-code-reuse ;;
        build-docker)                   docker build -t redien/reuse-lang-dev-env $script_path ;;
        docker)                         docker run --rm -it -v"$PWD/$project_root":/home/opam/reuse-lang redien/reuse-lang-dev-env bash ;;
    esac
}

run $1

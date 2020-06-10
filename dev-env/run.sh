#!/usr/bin/env bash

script_path=$(dirname $0)
project_root=$script_path/..

run() {
    case $1 in
        test)                           run test-string-gen && run test-sexp-parser && run test-parser && run test-compilers && run test-interpreter && run test-standard-library;;
        test-interpreter)               $project_root/extended/interpreter/build.sh && IMPL=extended/interpreter run test-minimal && IMPL=extended/interpreter run test-extended ;;
        test-compilers)                 run test-haskell-compiler && run test-ocaml-compiler ;;
        test-module-compiler)           $project_root/extended/module-compiler/build.sh && IMPL=extended/module-compiler run test-minimal && IMPL=extended/module-compiler run test-extended ;;
        test-ocaml-compiler)            $project_root/extended/ocaml-compiler/build.sh && IMPL=extended/ocaml-compiler run test-minimal && IMPL=extended/ocaml-compiler run test-extended ;;
        test-haskell-compiler)          $project_root/extended/haskell-compiler/build.sh && IMPL=extended/haskell-compiler run test-minimal && IMPL=extended/haskell-compiler run test-extended ;;
        test-javascript-node-compiler)  $project_root/extended/javascript-node-compiler/build.sh && IMPL=extended/javascript-node-compiler run test-minimal && IMPL=extended/javascript-node-compiler run test-extended ;;
        test-sexp-parser)               $project_root/sexp-parser/build.sh && $project_root/dev-env/spec-runner/run.sh sexp-parser/specification $project_root/sexp-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-parser)                    $project_root/parser/build.sh && $project_root/dev-env/spec-runner/run.sh parser/specification $project_root/parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-standard-library)          $project_root/standard-library/build.sh && $project_root/dev-env/spec-runner/run.sh standard-library/specification $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-inference)            $project_root/type-inference/build.sh && $project_root/dev-env/spec-runner/run.sh type-inference/specification $project_root/type-inference/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-unification)          $project_root/type-unification/build.sh && $project_root/dev-env/spec-runner/run.sh type-unification/specification $project_root/type-unification/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-string-gen)                $project_root/string-gen/build.sh && $project_root/dev-env/spec-runner/run.sh string-gen/specification $project_root/string-gen/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-minimal)                   $project_root/dev-env/spec-runner/run.sh minimal/specification $project_root/$IMPL/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-extended)                  $project_root/dev-env/spec-runner/run.sh extended/specification $project_root/$IMPL/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        line-count)                     (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings)' | xargs wc -l) ;;
        line-count-with-spec)           (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings|spec)' | xargs wc -l) ;;
        vscode-install)                 ln -s $PWD/$project_root/dev-env/editor-support/vs-code-reuse ~/.vscode/extensions/vs-code-reuse ;;
        build-docker)                   docker build -t redien/reuse-lang-dev-env $script_path ;;
        docker)                         docker run --rm -it -v"$PWD/$project_root":/home/opam/reuse-lang redien/reuse-lang-dev-env bash ;;
    esac
}

run $1

#!/usr/bin/env bash

script_path=$(dirname $0)
project_root=$script_path/..

run() {
    case $1 in
        test)                           run test-string-gen && run test-sexp-parser && run test-parser && run test-compilers && run test-interpreter && run test-standard-library;;
        test-interpreter)               $project_root/interpreter/build.sh && $project_root/dev-env/spec-runner/run.sh specification/minimal $project_root/interpreter/eval.sh | $project_root/dev-env/tap-format/tap-format.sh && $project_root/dev-env/spec-runner/run.sh specification/extended $project_root/interpreter/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-compilers)                 run test-ocaml-compiler && run test-haskell-compiler && run test-javascript-compiler && run test-module-compiler ;;
        test-module-compiler)           $project_root/interpreter/build.sh && $project_root/cli/build.sh && IMPL=module SOURCE=executable.reuse run test-minimal && IMPL=module SOURCE=executable.reuse run test-extended ;;
        test-ocaml-compiler)            $project_root/cli/build.sh && IMPL=ocaml SOURCE=executable.ml run test-minimal && IMPL=ocaml SOURCE=executable.ml run test-extended ;;
        test-haskell-compiler)          $project_root/cli/build.sh && IMPL=haskell SOURCE=Executable.hs run test-minimal && IMPL=haskell SOURCE=Executable.hs run test-extended ;;
        test-javascript-compiler)       $project_root/cli/build.sh && IMPL=javascript SOURCE=executable.js run test-minimal && IMPL=javascript SOURCE=executable.js run test-extended ;;
        test-sexp-parser)               $project_root/sexp-parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh sexp-parser/specification $project_root/sexp-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-parser)                    $project_root/parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh parser/specification $project_root/parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-argument-parser)           $project_root/argument-parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh argument-parser/specification $project_root/argument-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-standard-library-impl)     $project_root/dev-env/spec-runner/run.sh standard-library/specification $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-standard-library)          $project_root/interpreter/build.sh && $project_root/cli/build.sh && IMPL=ocaml SOURCE=executable.ml run test-standard-library-impl && IMPL=haskell SOURCE=Executable.hs run test-standard-library-impl && IMPL=javascript SOURCE=executable.js run test-standard-library-impl ;;
        test-stdlib-string)             $project_root/standard-library/build.sh && $project_root/dev-env/spec-runner/run.sh standard-library/specification/string.spec $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-stdlib-bigint)             $project_root/standard-library/build.sh && $project_root/dev-env/spec-runner/run.sh standard-library/specification/bigint.spec $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-inference)            $project_root/type-inference/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh type-inference/specification $project_root/type-inference/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-unification)          $project_root/type-unification/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh type-unification/specification $project_root/type-unification/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-string-gen)                $project_root/string-gen/build-for-test.sh && $project_root/dev-env/spec-runner/run.sh string-gen/specification $project_root/string-gen/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-minimal)                   $project_root/dev-env/spec-runner/run.sh specification/minimal $project_root/cli/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-extended)                  $project_root/dev-env/spec-runner/run.sh specification/extended $project_root/cli/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        line-count)                     (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings)' | xargs wc -l) ;;
        line-count-with-spec)           (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings|spec)' | xargs wc -l) ;;
        vscode-install)                 ln -s $PWD/$project_root/dev-env/editor-support/vs-code-reuse ~/.vscode/extensions/vs-code-reuse ;;
        docker)                         run docker-alpine ;;
        docker-alpine)                  docker build -t redien/reuse-lang-dev-env $script_path/alpine-3.8 && docker run --rm -it -v"$PWD/$project_root":/home/opam/reuse-lang redien/reuse-lang-dev-env bash ;;
        docker-ubuntu)                  docker build -t redien/reuse-lang-dev-env-ubuntu-20.04 $script_path/ubuntu-20.04 && docker run --rm -it -v"$PWD/$project_root":/root/reuse-lang redien/reuse-lang-dev-env-ubuntu-20.04 bash ;;
    esac
}

run $1

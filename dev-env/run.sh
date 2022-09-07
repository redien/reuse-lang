#!/usr/bin/env bash

script_path=$(dirname $0)
project_root=$script_path/..

run() {
    case $1 in
        test)                           run test-string-gen && run test-sexp-parser && run test-parser && run test-formatter && run test-compilers && run test-interpreter && run test-standard-library;;
        test-interpreter)               >&2 echo "Testing interpreter" && $project_root/interpreter/build.sh && $project_root/dev-env/spec-runner/run.js specification/core $project_root/interpreter/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-compilers)                 run test-ocaml-compiler && run test-haskell-compiler && run test-javascript-compiler && run test-module-compiler ;;
        test-module-compiler)           >&2 echo "Testing module backend" && $project_root/interpreter/build.sh && $project_root/cli/build.sh && IMPL=module SOURCE=executable.reuse run test-core ;;
        test-ocaml-compiler)            >&2 echo "Testing ocaml backend" && $project_root/cli/build.sh && IMPL=ocaml SOURCE=executable.ml run test-core && IMPL=ocaml SOURCE=executable.ml run test-modules ;;
        test-haskell-compiler)          >&2 echo "Testing haskell backend" && $project_root/cli/build.sh && IMPL=haskell SOURCE=Executable.hs run test-core && IMPL=haskell SOURCE=Executable.hs run test-modules ;;
        test-javascript-compiler)       >&2 echo "Testing javascript backend" && $project_root/cli/build.sh && IMPL=javascript SOURCE=executable.js run test-core && IMPL=javascript SOURCE=executable.js run test-modules ;;
        test-sexp-parser)               >&2 echo "Testing sexp parser" && $project_root/sexp-parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.js sexp-parser/specification $project_root/sexp-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-parser)                    >&2 echo "Testing parser" && $project_root/parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.js parser/specification $project_root/parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-new-parser)                >&2 echo "Testing new parser" && $project_root/new-parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.js parser/specification $project_root/new-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-argument-parser)           >&2 echo "Testing argument parser" && $project_root/argument-parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.js argument-parser/specification $project_root/argument-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-spec-parser)               >&2 echo "Testing spec parser" && $project_root/spec-parser/build-for-test.sh && $project_root/dev-env/spec-runner/run.js spec-parser/specification $project_root/spec-parser/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-formatter)                 >&2 echo "Testing formatter" && $project_root/cli/build.sh && $project_root/dev-env/spec-runner/run.js formatter/specification $project_root/formatter/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-standard-library-impl)     >&2 echo "Testing standard library using $IMPL backend" && $project_root/dev-env/spec-runner/run.js standard-library/specification $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-standard-library)          $project_root/interpreter/build.sh && $project_root/cli/build.sh && IMPL=ocaml SOURCE=executable.ml run test-standard-library-impl && IMPL=haskell SOURCE=Executable.hs run test-standard-library-impl && IMPL=javascript SOURCE=executable.js run test-standard-library-impl ;;
        test-stdlib-list)               $project_root/cli/build.sh && $project_root/standard-library/build.sh && $project_root/dev-env/spec-runner/run.js standard-library/specification/list.spec $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-stdlib-string)             $project_root/cli/build.sh && $project_root/standard-library/build.sh && $project_root/dev-env/spec-runner/run.js standard-library/specification/string.spec $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-stdlib-bigint)             $project_root/cli/build.sh && $project_root/standard-library/build.sh && $project_root/dev-env/spec-runner/run.js standard-library/specification/bigint.spec $project_root/standard-library/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-inference)            $project_root/type-inference/build-for-test.sh && $project_root/dev-env/spec-runner/run.js type-inference/specification $project_root/type-inference/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-type-unification)          $project_root/type-unification/build-for-test.sh && $project_root/dev-env/spec-runner/run.js type-unification/specification $project_root/type-unification/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-string-gen)                >&2 echo "Testing string-gen" && $project_root/string-gen/build-for-test.sh && $project_root/dev-env/spec-runner/run.js string-gen/specification $project_root/string-gen/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-core)                   $project_root/dev-env/spec-runner/run.js specification/core $project_root/cli/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        test-modules)                  $project_root/dev-env/spec-runner/run.js specification/modules $project_root/cli/eval.sh | $project_root/dev-env/tap-format/tap-format.sh ;;
        line-count)                     (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings)' | xargs wc -l) ;;
        line-count-with-spec)           (cd $project_root ; git ls-files | grep -v 'bootstrap/' | grep -E '\.(reuse|strings|spec)' | xargs wc -l) ;;
        vscode-install)                 ln -s $PWD/$project_root/dev-env/editor-support/vs-code-reuse ~/.vscode/extensions/vs-code-reuse ;;
        docker)                         run docker-alpine ;;
        docker-alpine)                  docker build -t redien/reuse-lang-dev-env $script_path/alpine-3.8 && docker run --rm -it -v"$PWD/$project_root":/home/opam/reuse-lang redien/reuse-lang-dev-env bash ;;
        docker-ubuntu)                  docker build -t redien/reuse-lang-dev-env-ubuntu-20.04 $script_path/ubuntu-20.04 && docker run --rm -it -v"$PWD/$project_root":/root/reuse-lang redien/reuse-lang-dev-env-ubuntu-20.04 bash ;;
    esac
}

run $1

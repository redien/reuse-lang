#!/usr/bin/env bash

working_dir=$(pwd)
script_path=$(dirname "$0")
project_root=$script_path/..

build_dir=$($project_root/dev-env/builddir.sh measure)
repo_dir=$($project_root/dev-env/builddir.sh measure-repo)

clone_repo() {
    [ -d $repo_dir/.git ] || git clone https://github.com/redien/reuse-lang $repo_dir --quiet
    cd $repo_dir
    git reset --hard
    git checkout base --quiet
    git pull --rebase --quiet
    cd $working_dir
}

list_commits() {
    cd $repo_dir
    git log -n $1 --pretty=format:'%h'
    cd $working_dir
}

checkout_commit() {
    cd $repo_dir
    git checkout $1 --quiet
    echo Checked out $1 >&2
    cd $working_dir
}

format_time() {
    cd $repo_dir
    echo "\"$1\",\"$(git log -n 1 --format=%ai --no-color $2)\",\"$2\",\"$(git log -n 1 --format=%s --no-color $2)\",$3"
    cd $working_dir
}

run_test() {
    echo "Running test for $1..." >&2
    time_result=$($script_path/$3)
    if [ "$?" == "0" ]; then
        format_time $1 $2 $time_result
        format_time $1 $2 $time_result >&2
    fi
}

test_commits() {
    for commit in $1; do
        checkout_commit $commit
        echo Building compiler... >&2
        $repo_dir/build.sh >&2
        if [ "$?" != "0" ]; then
            continue
        fi

        run_test 'sexp-parser' "$commit" 'sexp-parser/time-sexp-parser.sh'
        run_test 'ocaml-compiler' "$commit" 'ocaml-compiler/time.sh'
        run_test 'stdlib-dictionary-set' "$commit" 'stdlib-dictionary/time.sh DictionarySet'
        run_test 'stdlib-dictionary-set-duplicate' "$commit" 'stdlib-dictionary/time.sh DictionarySetDuplicate'
        run_test 'stdlib-dictionary-get' "$commit" 'stdlib-dictionary/time.sh DictionaryGet'
    done
}

clone_repo
echo Test,Date,Commit,Commit Message,Time \(s\) > $build_dir/report.csv
test_commits "$(list_commits 50)" | tac >> $build_dir/report.csv

echo Wrote report to \'$build_dir/report.csv\'

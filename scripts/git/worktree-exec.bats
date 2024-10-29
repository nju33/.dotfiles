#!/usr/bin/env bash

declare -A then_run_logs

generate_then_run_log() {
    local -r file_path="$BATS_RUN_TMPDIR"/then_run.log
    then_run_logs["$BATS_TEST_NUMBER"]="$file_path"
    touch "$file_path"
}

setup() {
    project_root=$(git rev-parse --show-toplevel)
    load "$project_root"/test/test_helper/bats-support/load
    load "$project_root"/test/test_helper/bats-assert/load

    dirname=$(dirname "$BATS_TEST_FILENAME")
    basename=$(basename "$BATS_TEST_FILENAME")
    stem="${basename/.bats/}"

    source "$dirname"/"$stem".sh
}

@test "into_inline(): should return 2 lines" {
    run into_inline <<EOT
worktree /private/tmp/foo
HEAD 83dde7499c61e8439b9e2df5a46904fcdb9f5c83
branch refs/heads/foo

worktree /private/tmp/bar
HEAD a86912c42ec4a7a6ae837a5e37b06b98ec5d191d
branch refs/heads/bar

EOT

    assert_output <<EOT
/private/tmp/foo;83dde7499c61e8439b9e2df5a46904fcdb9f5c83;refs/heads/foo
/private/tmp/bar;83dde7499c61e8439b9e2df5a46904fcdb9f5c83;refs/heads/bar
EOT
}

@test "execute_in(): should properly call the then_run()" {
    generate_then_run_log

    then_run() {
        dir="$(cat </dev/stdin)"
        command="$1"

        printf "%s;%s" "$dir" "$command" >"${then_run_logs["$BATS_TEST_NUMBER"]}"
    }
    export -f then_run

    run execute_in git ls-files <<EOT
/private/tmp/foo;83dde7499c61e8439b9e2df5a46904fcdb9f5c83;refs/heads/foo

EOT

    assert [ "$(cat <"${then_run_logs["$BATS_TEST_NUMBER"]}")" = "/private/tmp/foo;git ls-files" ]
}

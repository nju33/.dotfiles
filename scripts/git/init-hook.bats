#!/usr/bin/env bash

declare -A result_logs

generate_result_log() {
    local -r file_path="$BATS_RUN_TMPDIR"/result.log
    result_logs["$BATS_TEST_NUMBER"]="$file_path"
    touch "$file_path"
}

delete_result_log() {
    local -r file_path="$BATS_RUN_TMPDIR"/result.log

    rm "$file_path"
}

setup() {
    project_root=$(git rev-parse --show-toplevel)
    load "$project_root"/test/test_helper/bats-support/load
    load "$project_root"/test/test_helper/bats-assert/load

    dirname=$(dirname "$BATS_TEST_FILENAME")
    basename=$(basename "$BATS_TEST_FILENAME")
    stem="${basename/.bats/}"

    source "$dirname"/"$stem".sh
    generate_result_log

    # result_logs["$BATS_RUN_TMPDIR"]="$BATS_RUN_TMPDIR"/result.txt
}

teardown() {
    delete_result_log
}

@test "main(): should call create_dir_and_file and set_config when given '.githooks;y;y' by user" {
    local -r result_log=${result_logs[$BATS_TEST_NUMBER]}

    local expected=$(
        cat <<EOT
.githooks
.githooks
EOT
    )

    eval 'prompt() { echo .githooks\;y\;y; }'
    create_dir_and_file() { echo "$@" >>"$result_log"; }
    set_config() { echo "$@" >>"$result_log"; }
    export -f create_dir_and_file set_config

    run main

    assert [ "$(cat <"$result_log")" = "$expected" ]
}

@test "main(): should call only create_dir_and_file when given '.githooks;n;y' by user" {
    local -r result_log=${result_logs[$BATS_TEST_NUMBER]}

    local expected=$(
        cat <<EOT
.githooks
EOT
    )

    eval 'prompt() { echo .githooks\;n\;y; }'
    create_dir_and_file() { echo "$@" >>"$result_log"; }
    set_config() { echo "$@" >>"$result_log"; }
    export -f create_dir_and_file set_config

    run main

    assert [ "$(cat <"$result_log")" = "$expected" ]
}

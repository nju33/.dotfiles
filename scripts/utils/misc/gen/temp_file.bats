#!/usr/bin/env bash

declare -A make_temp_logs move_logs

generate_make_temp_logs() {
    local -r file_path="$BATS_TEST_TMPDIR"/make_temp.log

    make_temp_logs["$BATS_TEST_NUMBER"]="$file_path"
    touch "$file_path"
}

generate_move_logs() {
    local -r file_path="$BATS_TEST_TMPDIR"/move.log

    move_logs["$BATS_TEST_NUMBER"]="$file_path"
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

    generate_make_temp_logs
    generate_move_logs
}

@test "main(): should succeed when given a filename with extension" {
    make_temp() {
        echo "$@" >"${make_temp_logs[$BATS_TEST_NUMBER]}"
        echo test.123456
    }
    move() {
        echo "$@" >"${move_logs[$BATS_TEST_NUMBER]}"
    }
    export -f make_temp move

    run main test.log

    assert_success
    assert [ "$(cat <"${make_temp_logs[$BATS_TEST_NUMBER]}")" = test ]
    assert [ "$(cat <"${move_logs[$BATS_TEST_NUMBER]}")" = "test.123456 test.123456.log" ]
    assert [ "$output" = test.123456.log ]
}

@test "main(): should succeed when given a filename without extension" {
    make_temp() {
        echo "$@" >"${make_temp_logs[$BATS_TEST_NUMBER]}"
        echo test2.123456
    }
    move() {
        echo "$@" >"${move_logs[$BATS_TEST_NUMBER]}"
    }
    export -f make_temp move

    run main test2

    assert_success
    assert [ "$(cat <"${make_temp_logs[$BATS_TEST_NUMBER]}")" = test2 ]
    assert [ -z "$(cat <"${move_logs[$BATS_TEST_NUMBER]}")" ]
    assert [ "$output" = test2.123456 ]
}

@test "main(): should fail when given no arguments" {
    run main

    assert_failure
}

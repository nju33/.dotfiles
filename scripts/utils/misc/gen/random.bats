#!/usr/bin/env bash

setup() {
    project_root=$(git rev-parse --show-toplevel)
    load "$project_root"/test/test_helper/bats-support/load
    load "$project_root"/test/test_helper/bats-assert/load

    dirname=$(dirname "$BATS_TEST_FILENAME")
    basename=$(basename "$BATS_TEST_FILENAME")
    stem="${basename/.bats/}"

    source "$dirname"/"$stem".sh
}

@test "main(): should return 16 characters" {
    run main

    assert [ ${#output} -eq 16 ]
}

@test "main(): should return 5 characters when given 5" {
    run main 5

    assert [ ${#output} -eq 5 ]
}

@test "main(): should return characters of 5 numbers when given '5' and '0-9'" {
    run main 5 0-9

    assert [ ${#output} -eq 5 ]
    assert grep -qE '^\d{5}$' <<<$output
}

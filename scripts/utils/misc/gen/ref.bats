#!/usr/bin/env bash

setup() {
    project_root=$(git rev-parse --show-toplevel)
    load "$project_root"/test/test_helper/bats-support/load
    load "$project_root"/test/test_helper/bats-assert/load

    dirname=$(dirname "$BATS_TEST_FILENAME")
    basename=$(basename "$BATS_TEST_FILENAME")
    stem="${basename/.bats/}"

    source "$dirname"/"$stem".sh
    eval "random() { "$dirname"/random.sh; }"
}

@test "main(): should return 40 characters" {
    run main

    assert [ ${#output} -eq 40 ]
}

@test "main(): should return the same result when given 'foo'" {
    run main foo
    first_result=$output
    run echo foo | main
    second_result=$output

    assert_equal $first_result $second_result
}

@test "main(): should return 128 characters when given '--dgst -sha3-512'" {
    run main foo --dgst -sha3-512

    assert [ ${#output} -eq 128 ]
}

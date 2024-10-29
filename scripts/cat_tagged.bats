#!/usr/bin/env bash

declare -A read_file_logs

generate_read_file_logs() {
    local -r file_path="$BATS_TEST_TMPDIR"/read_file.log

    read_file_logs["$BATS_TEST_NUMBER"]="$file_path"
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

    generate_read_file_logs
}

@test "main(): should return paths with A tag from a tagged file" {
    read_file() {
        echo "$@" >"${read_file_logs[$BATS_TEST_NUMBER]}"
        cat <<EOT
A:/foo
B:/bar
A:/baz
EOT
    }
    export -f read_file read_file

    run main foo/.ranger/tagged A

    assert_success
    assert [ "$(cat <"${read_file_logs[$BATS_TEST_NUMBER]}")" = foo/.ranger/tagged ]
    assert [ "$output" = /foo$'\n'/baz ]
}

@test "main(): should fail when not given tag name" {
    run main foo/.ranger/tagged

    assert_failure
}

@test "main(): should fail when given a tag name with a character length greater than 1" {
    run main foo/.ranger/tagged

    assert_failure
}

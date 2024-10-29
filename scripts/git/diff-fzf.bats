setup() {
    project_root=$(git rev-parse --show-toplevel)
    load "$project_root"/test/test_helper/bats-support/load
    load "$project_root"/test/test_helper/bats-assert/load

    dirname=$(dirname "$BATS_TEST_FILENAME")
    basename=$(basename "$BATS_TEST_FILENAME")
    stem="${basename/.bats/}"

    source "$dirname"/"$stem".sh
}

@test "extract_filename(): should return '/dev/null' when given '+++ /dev/null'" {
    run extract_filename '+++ /dev/null'

    assert_output '/dev/null'
}

@test "extract_filename(): should return 'foo/bar.txt' when given '+++ b/foo/bar.txt'" {
    run extract_filename '+++ b/foo/bar.txt'

    assert_output 'foo/bar.txt'
}

@test "extract_lineno(): should return '12,41' when given '@@ -8,4 +12,41 @@ foo'" {
    run extract_lineno '@@ -8,4 +12,41 @@ foo'

    assert_output '12,41'
}

# No additional lines
@test "extract_lineno(): should return '10,0' when given '@@ -15 +10,0 @@ foo'" {
    run extract_lineno '@@ -15 +10,0 @@ foo'

    assert_output '10,0'
}

@test "extract_lineno(): should return '67' when given '@@ -50 +67 @@ foo'" {
    run extract_lineno '@@ -50 +67 @@ foo'

    assert_output '67'
}

@test "have_additional_lines(): should fail when given '0'" {
    run have_additional_lines '0'

    assert_failure
}

@test "have_additional_lines(): should fail when given '10,0'" {
    run have_additional_lines '10,0'

    assert_failure
}

@test "have_additional_lines(): should succeed when given '12,4'" {
    run have_additional_lines '12,4'

    assert_success
}

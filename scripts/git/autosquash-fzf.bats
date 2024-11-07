setup() {
    project_root=$(git rev-parse --show-toplevel)
    load "$project_root"/test/test_helper/bats-support/load
    load "$project_root"/test/test_helper/bats-assert/load

    dirname=$(dirname "$BATS_TEST_FILENAME")
    basename=$(basename "$BATS_TEST_FILENAME")
    stem="${basename/.bats/}"

    dirname() {
        echo "$dirname"
    }
    source "$dirname"/"$stem".sh
    unset dirname
}

create_temp_repository() {
    wd=$(printf "%s/%s" "$BATS_TEST_TMPDIR" test)
    mkdir -p "$wd"
    echo "$wd"
}

init_git() {
    git init
    git commit --allow-empty --allow-empty-message --message ''
}

@test "simulate_interactive_rebase_file(): should return a output that second commit is successively followed by fixup and squash" {
    expected='pick create a.txt
fixup fixup! create a.txt
squash squash! create a.txt
pick create b.txt'

    dir=$(create_temp_repository)
    # echo "$dir" >&3
    cd "$dir"
    init_git
    echo a >a.txt && git add a.txt && git commit -m 'create a.txt'
    target_hash=$(git log -1 --pretty=format:"%H" HEAD)
    echo b >b.txt && git add b.txt && git commit -m 'create b.txt'
    echo update with fixup >>a.txt && git add a.txt && git commit --fixup HEAD~1
    echo update with squash >>a.txt && git add a.txt && git commit --squash HEAD~2 --no-edit
    # git log --oneline >&3

    run simulate_interactive_rebase_file "$target_hash"

    omitted_hash_field="$(echo "$output" | awk '{$2="";gsub(/ +/, " ");print}')"
    assert [ "$omitted_hash_field" = "$expected" ]
}

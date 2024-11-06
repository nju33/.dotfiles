#!/bin/sh
#
# A place to put utilities for Git
# Dependencies:
#   core.sh

type _ensure_stdin_is_pipe >/dev/null 2>&1 || {
    echo 'fatal: need to load core.sh before using git.sh' 2>&1
    exit 1
}

# Query the initial commit hash
#
# Outputs:
#   writes hash to stdout
# Returns:
#   0
#   128 issued by Git
query_hash_of_initial_commit() {
    git rev-list --max-parents=0 HEAD
}

# Query the list of refs/notes/*
#
# Outputs:
#   writes a list to stdout
# Returns:
#   0
#   128 issued by Git
query_refs_notes() {
    git for-each-ref --format='%(refname)' refs/notes
}

# Get the subject of the message of a passed commit
#
# Arguments:
#   stdin - a commit
# Outputs:
#   writes a subject text to stdout
# Returns:
#   0
#   1 where not on pipeline
#   128 issued by Git
get_subject() {
    _ensure_stdin_is_pipe
    read -r commit
    git log -1 --pretty=format:"%s" "$commit"
}

# Get the body of the message of a passed commit
#
# Arguments:
#   stdin - a commit
# Outputs:
#   writes a body text to stdout
# Returns:
#   0
#   1 where not on pipeline
#   128 issued by Git
get_body() {
    _ensure_stdin_is_pipe
    read -r commit
    git log -1 --pretty=format:"%b" "$commit"
}

# Whether a passed status code is by Git
#
# Returns:
#   0
#   1
is_fatal_ambiguous_arg() {
    _ensure_stdin_is_pipe
    read -r status
    [ "$status" -eq 128 ]
}

# Whether a passed hash is equal to that of the initial commit
#
# Arguments:
#   stdin: a hash
# Returns:
#   0
#   1
#   128 issued by Git
is_initial_commit() {
    _ensure_stdin_is_pipe
    read -r commit

    current_commit_hash=$(git rev-list "$commit" 2>&1)
    rev_list_status=$?

    if echo "$rev_list_status" | is_fatal_ambiguous_arg; then
        echo "$current_commit_hash" >&2
        exit $rev_list_status
    fi

    initial_commit_hash=$(git rev-list --max-parents=0 HEAD)

    [ "$current_commit_hash" = "$initial_commit_hash" ]
}

# Whether a passed subject starts with either `fixup` or `squash`
#
# Arguments:
#   stdin: a subject string
# Returns:
#   0
#   1
# Examples:
#   ```sh
#   if echo "fixup! foo" | starts_with_either_fixup_or_squash; then
#       echo this is "fixup" prefix-exact-matched comment
#   fi
#   ```
starts_with_either_fixup_or_squash() {
    _ensure_stdin_is_pipe
    read -r subject
    echo "$subject" | grep -q -e '^fixup!' -e '^squash!'
}

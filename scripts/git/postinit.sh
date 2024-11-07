#!/bin/sh

. "$(dirname "$0")"/../utils/core.sh

# Create root commit with empty message
#
# Outputs:
#   writes commit hash string to stdout
root_commit() {
    git commit --allow-empty --allow-empty-message --message '' --quiet || exit 1
    git log -1 --pretty=format:'%H'
}

initialize() {
    _ensure_stdin_is_pipe
    IFS= read -r root_hash

    git update-ref refs/heads/ROOT "$root_hash"
}

output() {
    format='Hash: %C(yellow)%H%C(reset)%nRef names: %C(green)%D'
    git log refs/heads/ROOT --pretty=format:"$format"
}

main() {
    root_commit | initialize
    output
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

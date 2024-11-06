#!/bin/sh

. "$(dirname "$0")"/../utils/core.sh
. "$(dirname "$0")"/../utils/git.sh

# Get the list of the notes' ref involved with a passed commit
#
# Arguments:
#   stdin - a commit
# Outputs:
#   writes a list to stdout
# Returns:
#   0
#   1 where not on pipeline
#   128 issued by Git
get_note_refs() {
    _ensure_stdin_is_pipe
    IFS= read -r hash

    for ref in $(query_refs_notes); do
        if git notes --ref="$ref" list | grep -q "$hash"; then
            echo "${ref##*/}"
        fi
    done
}

# Get the message with all of notes from a passed hash
#
# Arguments:
#   stdin - a commit
# Outputs:
#   writes a content like in Markdown to stdout
# Returns:
#   0
#   1 where not on pipeline
#   128 issued by Git
get_message_with_all_notes() {
    _ensure_stdin_is_pipe
    IFS= read -r hash

    header() {
        subject="$(echo "$hash" | get_subject)"
        if [ -n "$subject" ]; then
            echo \# "$subject"
        fi
    }

    body() {
        echo "$hash" | get_body
    }

    notes() {
        note_refs="$(echo "$hash" | get_note_refs)"
        if [ -n "$note_refs" ]; then
            echo \#\# Notes

            for ref in $note_refs; do
                echo \#\#\# "$ref"
                git notes --ref "$ref" show "$hash"
            done
        fi
    }

    header
    body
    notes
}

main() {
    echo "${1?fatal: need to pass a commit hash as $1}" |
        get_message_with_all_notes |
        glow -w "$(tput col)" -s notty
}

if echo "$0" | grep -qE '\/get-message-with-all-notes\.sh$'; then
    main "$@"
fi

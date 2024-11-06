#!/bin/sh

. "$(dirname "$0")"/../utils/core.sh
. "$(dirname "$0")"/get-message-with-all-notes.sh

render() {
    _ensure_stdin_is_pipe

    message=
    while read -r line; do
        message="$message""${message:+\n}""$line"
    done

    printf '%b' "$message" | glow -w "$_long_range_position" -s notty
}

export _long_range_position
# shellcheck disable=SC3045
export -f _ensure_stdin_is_pipe get_note_refs get_message_with_all_notes render

main() {
    preview_window='top,border-bottom'
    if _has_long_range; then
        preview_window='right,border-left'
    fi

    if ! echo "${1?fatal: need to specify either fixup\|squash as $1 }" |
        grep -q -e '^fixup$' -e '^squash$'; then
        abort() { echo abort: unexpected "$1" as \$1; }
        abort "$1"
    fi

    hash=$(
        (echo "$1" && git l) |
            fzf --ansi \
                --header-lines 1 \
                --preview "get_message_with_all_notes {1} | render" \
                --preview-window "$preview_window" |
            cut -d' ' -f1
    )

    # NOTE: must not `git commit` in a pipeline by fzf because that
    # vim says "Vim: Warning: Input is not from a terminal"
    git commit --"$1" "$hash"
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

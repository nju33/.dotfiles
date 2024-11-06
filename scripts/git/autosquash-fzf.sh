#!/bin/sh

. "$(dirname "$0")"/../utils/core.sh
. "$(dirname "$0")"/../utils/git.sh
. "$(dirname "$0")"/../utils/color.sh
. "$(dirname "$0")"/get-message-with-all-notes.sh

# Simulate to reproduce interactive rebase temp file
#
# Arguments:
#   $1 - a current choosing commit hash
# Outputs:
#   writes result mimiced rebase temp file content to stdout
# Returns:
#   0
#   1
#   128 - issued by Git
simulate_interactive_rebase_file() {
    log_range="${1?fatal: need to specify hash as \$1}"~1..HEAD
    processed_hashes=

    if echo "$1" | is_initial_commit; then
        echo warning: "$1" is the initial commit | ansi yellow | ansi bold >&2
        return 128
    fi

    find_related_root_hash_successively() {
        # The head of semi-colon separated values
        target_commit="${1%%\;*}"
        subject=$(echo "$target_commit" | get_subject)
        # The part of a string that follows fixup! or squash!
        # HACK: the last `| xargs` only means removing head spaces
        grep_text=$(echo "$subject" | awk -F' ' '{if(match($1,/^(fixup|squash)!$/))$1="";print}' | xargs)

        # The means below is the commit message doesn’t prefix-exact-match
        # for neither fixup nor squash
        if [ "$subject" = "$grep_text" ]; then
            processed_hashes="${processed_hashes}""${processed_hashes:+;}""$target_commit"
            echo "$1"
            return
        fi

        nearest_related_commit_hash=$(git log -1 --grep ^"$grep_text" --pretty=format:"%h" "$log_range")

        # The means below is not hitting the result of query for log because
        # the $nearest_related_commit_hash is more older than the target_commit;
        # thus handling last hit commit as root commit
        if [ -z "$nearest_related_commit_hash" ]; then
            processed_hashes="${processed_hashes}""${processed_hashes:+;}""$target_commit"
            echo "$1"
        else
            find_related_root_hash_successively "$nearest_related_commit_hash"\;"$1"
        fi
    }

    for hash in $(git log --pretty=format:"%h" "$log_range"); do
        # In `find_related_root_hash_successively` used below, the hash
        # may be already handled. In such a case, the process for the hash
        # will be skipped
        hash_should_be_skip() {
            echo "$processed_hashes" | grep -q \;"$hash"
        }
        if hash_should_be_skip; then
            continue
        fi

        hashes=$(find_related_root_hash_successively "$hash")
        root_hash="${hashes%%\;*}"

        if [ ! "$hash" = "$root_hash" ]; then
            # Save all commit hashes having common related parent commit in one place
            # NOTE: ordering old -> new
            eval "__hash__$root_hash=\"$hash\"\"\${__hash__$root_hash:+;}\"\"\$__hash__$root_hash\""
        fi
    done

    viewed_list=
    for hash in $(git log --reverse --pretty=format:"%h" "$log_range"); do
        current_subject=$(echo "$hash" | get_subject)
        list=$(eval "echo \"\$__hash__$hash\"")

        # 1. the hash is the commit being `edit` command
        # 2. the hash hasn't showned yet
        if [ -z "$list" ] && ! echo "$viewed_list" | grep -qoE "^$hash|;$hash"; then
            echo pick "$hash" "$current_subject"
            continue
        fi

        if [ -n "$list" ]; then
            echo pick "$hash" "$current_subject"
            viewed_list="$viewed_list""${viewed_list:+;}""$list"
        fi

        (
            IFS=\;
            for current_related_hash in $list; do
                subject=$(echo "$current_related_hash" | get_subject)

                if ! echo "$subject" | starts_with_either_fixup_or_squash; then
                    continue
                fi

                action_name=$(echo "$subject" | grep -o -e '^fixup' -e '^squash')
                if [ -z "$action_name" ]; then
                    action_name=pick
                fi

                echo "$action_name" "$current_related_hash" "$subject"
            done
        )
    done
}

# Decorate rebase mimicked text for increasing visibility almost for command types
#
# Arguments:
#   stdin - a rebase mimicked text
# Returns:
#   0
#   1
render() {
    _ensure_stdin_is_pipe

    while read -r line; do
        echo "$line" | {
            read -r command hash comment

            echo_command() {
                case "$command" in
                fixup)
                    echo "$command" | ansi cyan | ansi bold
                    ;;
                squash)
                    echo "$command" | ansi red | ansi bold
                    ;;
                *)
                    echo "$command" | ansi magenta
                    ;;
                esac
            }

            printf '%b %b %b\n' \
                "$(echo_command)" \
                "$(echo "$hash" | ansi yellow)" \
                "$comment"
        }
    done
}

# shellcheck disable=SC3045
export -f \
    _ensure_stdin_is_pipe \
    is_fatal_ambiguous_arg \
    is_initial_commit \
    get_subject \
    starts_with_either_fixup_or_squash \
    get_note_refs \
    ansi \
    red \
    cyan \
    yellow \
    magenta \
    bold \
    simulate_interactive_rebase_file \
    render

# Apply `git rebase` in autosquash mode with `GIT_SEQUENCE_EDITOR`
main() {
    preview_window='top,border-bottom'
    if _has_long_range; then
        preview_window='right,border-left'
    fi

    hash=$(
        (echo "git rebase --interactive --autosquash" && git l) |
            fzf --ansi \
                --header-lines 1 \
                --preview "simulate_interactive_rebase_file {1} | render" \
                --preview-window "$preview_window" |
            cut -d' ' -f1
    )

    # Enables you immidiately apply autosquash not opening editor
    export GIT_SEQUENCE_EDITOR=true
    # NOTE: must not `git commit` in a pipeline by fzf because that
    # vim says "Vim: Warning: Input is not from a terminal"
    git rebase --interactive --autosquash "$hash"~1
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

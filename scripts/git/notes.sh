#!/bin/sh

. "$(dirname "$0")"/../utils/core.sh
. "$(dirname "$0")"/../utils/git.sh
. "$(dirname "$0")"/../utils/color.sh
. "$(dirname "$0")"/get-message-with-all-notes.sh

# shellcheck disable=SC3045
export -f query_hash_of_initial_commit

# Apply `git rebase` in autosquash mode with `GIT_SEQUENCE_EDITOR`
main() {
    preview_window='top,border-bottom'
    if _has_long_range; then
        preview_window='right,border-left'
    fi

    ref=
    args=

    while [ "$#" -gt 0 ]; do
        case "$1" in
        -r | --ref)
            ref="$2"
            shift 2
            ;;
        *)
            args="$args""${args:+ }""$1"
            shift
            ;;
        esac
    done

    command=$(ps -p $PPID -o command= | cut -d' ' -f2)
    if [ ${#command} -gt 2 ]; then
        echo 'fatal: unexpected arguments error' >&2
        return 1
    fi

    command_initial_char=$(echo "$command" | cut -c1)
    command_second_char=$(echo "$command" | cut -c2)

    object=
    case "$command_initial_char" in
    n) object=$(query_hash_of_initial_commit) ;;
    N) object=HEAD ;;
    *)
        echo 'fatal: unexpected alias name error' >&2
        return 1
        ;;
    esac

    notes_command=
    if [ "${#command}" -eq 1 ]; then
        notes_command=add
        # NOTE: it's "commits" that Git will allocate as a reference name by default
        ref=commits
    else
        case "$command_second_char" in
        a | add) notes_command=add ;;
        s | show) notes_command=show ;;
        e | edit) notes_command=edit ;;
        r | remove) notes_command=remove ;;
        l | list) notes_command=list ;;
        *)
            echo "fatal: unexpected notes' command error" >&2
            return 1
            ;;
        esac
    fi

    if [ -z "$ref" ]; then
        refs=$(
            git for-each-ref --format="%(refname)" refs/notes/* | awk -F'/' '{print $3}'
        )

        ref=$(
            echo "$refs" |
                fzf --ansi \
                    --header="git notes --ref [ref] $notes_command $object" \
                    --prompt="--ref [" \
                    --print-query \
                    --preview "git notes --ref {} show \"$object\"" \
                    --preview-window "$preview_window" | {
                # NOTE: when using with --print-query, the prompting text always
                # appears as the first line of the result. if the prompting text
                # matches something, it will be placed on the second line of the
                # result
                tail -n1
            }
        )
    fi

    # shellcheck disable=SC2086
    git notes --ref "$ref" "$notes_command" "$object" $args
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

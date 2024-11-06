#!/bin/sh

main() {
    command=$(ps -p $PPID -o command=)

    echo "$command" | {
        read -r _ comm args

        case "$comm" in
        a)
            # considered empty arguments under the following
            # conditions:
            #   1. no arguments is passing
            #   2. the arguments, that is existing now, starts with `-`
            #      that may be a flag
            if [ -z "$args" ] || echo "$args" | grep -qE '^-'; then
                status_result=$(git -c color.status=always status --short)
                # NOTE: the `2` is considering the height of out of
                # the fzf's finder pane
                status_result_line_number=$(($(echo "$status_result" | wc -l) + 2))
                file_list=$(
                    echo "$status_result" |
                        fzf --ansi --multi --height="$status_result_line_number" --prompt='git add ' |
                        awk -F' ' '{printf("%s ", $2)}'
                )
                if [ -n "$file_list" ]; then
                    # shellcheck disable=SC2086
                    git add $file_list $args
                fi
            else
                # shellcheck disable=SC2086
                git add $args
            fi
            ;;
        A)
            # shellcheck disable=SC2086
            git add --all $args
            return
            ;;
        *)
            echo 'fatal: unexpected command error' >&2
            return 1
            ;;
        esac
    }
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

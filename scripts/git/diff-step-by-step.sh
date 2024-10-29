#!/usr/bin/env bash

main() {
    local file_path result_git_status logs finder_list oldest_hash

    if [ -z "$1" ]; then
        set -- "$(
            git status --short |
                grep M |
                fzf --ansi --preview-window right:60%:wrap --preview " \
if file_path_is_staged {}; then
    git diff --color=always --staged -- {2}
else
    git diff --color=always -- {2}
fi
                " |
                xargs |
                cut -d' ' -f2
        )"
    fi

    # When nothing was seleted in the above step
    if [ -z "$1" ]; then
        echo "fatal: a file path as the first argv is required" 2>&1
        return 1
    fi

    file_path="${1?fatal: a file path as the first argv is required}"
    result_git_status="$(git status --short -- "$file_path")"

    logs="$(git l --color=always --follow -- "$file_path")"
    if file_path_is_changing "$result_git_status"; then
        if file_path_is_staged "$result_git_status"; then
            logs="$(printf "%s\n%s" "STAGED" "$logs")"
        else
            logs="$(printf "%s\n%s" "NOTSTAGED" "$logs")"
        fi
    fi

    finder_list="$(echo "$logs" | sed '$d')"
    oldest_hash="$(git log --follow --format="%h" -- "$file_path" | tail -n1)"

    echo "$finder_list" |
        fzf --ansi \
            --preview "preview {1} \"$oldest_hash\" \"$file_path\"" \
            --preview-window right:60%:wrap
}

preview() {
    local -r selected="$1"

    if [ "$selected" == "NOTSTAGED" ]; then
        preview_diff_notstaged "$3"
    elif [ "$selected" == "STAGED" ]; then
        preview_diff_staged "$3"
    else
        preview_diff_between "$@"
    fi
}

preview_diff_notstaged() {
    git diff --color=always -- "$1"
}

preview_diff_staged() {
    git diff --color=always --staged -- "$1"
}

preview_diff_between() {
    local -r new="$1" old="$2" file_path="$3"

    git diff --color=always "$old".."$new" -- "$file_path"
}

file_path_is_changing() { [ "$(echo "$1" | grep -c M)" -eq 1 ]; }
file_path_is_staged() { [ "$(echo "$1" | grep -c ^M)" -eq 1 ]; }

# These functions is used in fzf preview
export -f \
    preview \
    preview_diff_notstaged \
    preview_diff_staged \
    preview_diff_between \
    file_path_is_changing \
    file_path_is_staged

if [ ${#BASH_SOURCE[@]} -eq 1 ]; then
    main "$@"
fi

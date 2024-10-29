#!/usr/bin/env bash

extract_filename() {
    local output

    output=$(cut -d' ' -f2 <<<"$1")

    if [[ $output =~ ^b ]]; then
        output=${output:2}
    fi

    echo "$output"
}

extract_lineno() {
    awk -v RS=' ' -F',' '/^\+/ {sub(/\+/,"");print}' <<<"$1"
}

have_additional_lines() {
    [[ ! $1 =~ ^0 && ! $1 =~ ,0$ ]]
}

format() {
    local current_filename lineno

    while read -r line; do
        if [[ $line =~ ^\+\+\+ ]]; then
            current_filename="$(extract_filename "$line")"
        elif [[ $line =~ ^@@ && -n "$current_filename" && $current_filename != "/dev/null" && -f "$current_filename" ]]; then
            lineno="$(extract_lineno "$line")"

            if have_additional_lines "$lineno"; then
                if [[ $lineno == *,* ]]; then
                    echo "$current_filename:${lineno/,/:}"
                else
                    echo "$current_filename:$lineno"
                fi
            fi
        fi
    done
}

_diff_fzf_preview() {
    local -r file_path="$1"
    local -i start_lineno="$2" lineno_range="$3"
    local -a highlight_flags=()

    for ((i = 0; i <= ${lineno_range:-"0"}; i++)); do
        highlight_flags+=("--highlight-line $((start_lineno + i))")
    done

    # shellcheck disable=SC2068
    bat --style=numbers --color=always ${highlight_flags[@]} "$file_path"
}
export -f _diff_fzf_preview

main() {
    local -r comm="$1"
    local selected file
    local -i start_lineno lineno_range
    local -a highlight_flags=()
    shift

    selected=$(git "${comm-diff}" --unified=0 "$@" |
        awk '/^\+\+\+/ || /^@@/' |
        format |
        fzf --no-multi --delimiter : \
            --preview '_diff_fzf_preview {1} {2} {3}' \
            --preview-window "${position-bottom}:${size-50%}:+{2}-/2")

    file=$(awk -F: '{print $1}' <<<"$selected")
    start_lineno=$(awk -F: '{print $2}' <<<"$selected")
    lineno_range=$(awk -F: '{print $3}' <<<"$selected")

    for ((i = 0; i <= ${lineno_range:-"0"}; i++)); do
        highlight_flags+=("--highlight-line $((start_lineno + i))")
    done

    if [[ -n $file ]]; then
        if [[ $TERM_PROGRAM = "vscode" ]]; then
            code -g "$file:$start_lineno"
        else
            # shellcheck disable=SC2068
            bat ${highlight_flags[@]} "$file"
        fi
    fi
}

if [ ${#BASH_SOURCE[@]} -eq 1 ]; then
    main "$@"
fi

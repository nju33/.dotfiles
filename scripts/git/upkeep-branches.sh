#!/usr/bin/env bash

main() {
    local buffer_period="+3mo" now

    now="$(dateconv now)"

    git for-each-ref --format='%(refname:short) %(committerdate:short)' refs/heads | while read -r branch date; do
        diff="$(datediff "$(dateadd "$date" "$buffer_period")" "$now")"
        if [ "$diff" -ge "0" ]; then
            (
                set -x
                git branch -d "$branch"
            )
        fi
    done
}

if [ ${#BASH_SOURCE[@]} -eq 1 ]; then
    main
fi

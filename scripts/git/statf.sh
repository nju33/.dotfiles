#!/usr/bin/env bash

main() {
    if [ "$#" -gt 0 ]; then
        git show --stat "$@"
        return
    fi

    git l --color=always |
        fzf --ansi --preview-window right:60%:wrap --preview " \
git show --stat --color=always {1}
                " >/dev/null
}

if [ ${#BASH_SOURCE[@]} -eq 1 ]; then
    main "$@"
fi

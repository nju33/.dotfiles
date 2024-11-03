#!/usr/bin/env bash

_misc_completion() {
    if [ "$COMP_CWORD" -eq 2 ]; then
        misc_dir="$DOTFILES_LOCATION_DIRECTORY"/scripts/utils/misc/"$3"
        commands="$(
            find "$misc_dir" -type f -name '*.sh' -maxdepth 1 -exec basename {} \; | grep -Eo '^[^.]*'
        )"

        mapfile -t COMPREPLY < <(compgen -W "$commands" -- "${COMP_WORDS[COMP_CWORD]}")

        return
    fi

    mapfile -t COMPREPLY < <(compgen -W "gen print uptodate" -- "${COMP_WORDS[COMP_CWORD]}")
}
complete -o default -F _misc_completion misc

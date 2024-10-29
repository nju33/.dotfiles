#!/usr/bin/env bash

_devch_completion() {
    COMPREPLY=()

    case "$3" in
    -d | --user_data_dir)
        local -r profile_dirs="$HOME/.devch/*"
        local profile

        # shellcheck disable=SC2086
        profile=$(find $profile_dirs -maxdepth 0 -print0 | xargs -0 -I{} echo {} | grep -o '[^/]*$')
        readonly profile

        mapfile -t COMPREPLY < <(compgen -W "$profile" -- "${COMP_WORDS[COMP_CWORD]}")
        return
        ;;
    esac

    mapfile -t COMPREPLY < <(compgen -W "--remote-debugging-port --user_data_dir" -- "${COMP_WORDS[COMP_CWORD]}")
    return
}
complete -o default -F _devch_completion devch

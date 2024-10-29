#!/usr/bin/env bash

_misc_completion() {
    if [ "$COMP_CWORD" -eq 2 ]; then
        case "$3" in
        gen)
            mapfile -t COMPREPLY < <(compgen -W "exf random ref temp_file" -- "${COMP_WORDS[COMP_CWORD]}")
            ;;
        print)
            mapfile -t COMPREPLY < <(compgen -W "env" -- "${COMP_WORDS[COMP_CWORD]}")
            ;;
        uptodate)
            mapfile -t COMPREPLY < <(compgen -W "brew npm" -- "${COMP_WORDS[COMP_CWORD]}")
            ;;
        esac
        return
    fi

    mapfile -t COMPREPLY < <(compgen -W "gen print uptodate" -- "${COMP_WORDS[COMP_CWORD]}")
}
complete -o default -F _misc_completion misc

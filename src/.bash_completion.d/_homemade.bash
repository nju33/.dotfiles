#!/usr/bin/env bash

_gen_ignore_patterns() {
    read -r args <<<"$1"

    awk '{$1="";$2="";$NF="";print}' <<<"$args" |
        awk -v OFS='|' '{for(i=1;i<=NF;i++)$i="^"$i"$";print}'
}

_git_completion() {
    if [ "$COMP_CWORD" -eq 1 ]; then
        commands="$(
            git --help -a |
                awk '/^$/ {next} /^   / {print $1}'
        )"
        mapfile -t COMPREPLY < <(compgen -W "$commands" -- "${COMP_WORDS[COMP_CWORD]}")

        return
    fi

    if [ "$COMP_CWORD" -ge 2 ]; then
        local command ignore_patterns tempfile suggests
        command="$(cut -d' ' -f2 <<<"$COMP_LINE")"
        ignore_patterns="$(_gen_ignore_patterns "$COMP_LINE")"

        map_command_with() {
            local result

            case "$1" in
            a | A | all | ap)
                result="add"
                ;;
            b | bm | bmi)
                result="branch"
                ;;
            bi | bil)
                result="bisect"
                ;;
            c | C | ca)
                result="commit"
                ;;
            d | dy)
                result="diff"
                ;;
            ft)
                result="fetch"
                ;;
            p | pu | pfl | pt)
                result="push"
                ;;
            l | L | lf | lps | lmea | lmec | lgrep)
                result="log"
                ;;
            ll | llr)
                result="pull"
                ;;
            s)
                result="status"
                ;;
            sh)
                result="show"
                ;;
            sw)
                result="switch"
                ;;
            t)
                result="tag"
                ;;
            us)
                result="restore"
                ;;
            wt)
                result="worktree"
                ;;
            *)
                result="$1"
                ;;
            esac

            echo "$result"
        }

        command="$(map_command_with "$command")"
        tempfile="$(mktemp "/tmp/${FUNCNAME[0]}.XXXXXX")"

        if ! git help "$command" 2>/dev/null >"$tempfile"; then
            return
        fi

        suggests="$(
            cat <"$tempfile" |
                col -b |
                awk '/OPTIONS/,/EXAMPLES/' |
                awk '/^[ ]{7}-/' |
                awk -F',' '{for(i=1;i<=NF;i++) print $i}' |
                awk -F'=' '{print $1}' |
                awk -F' ' '{print $1}' |
                awk '/^--$/{next}/\[no-\]/{orig=$0;sub(/\[no-\]/,"no-",orig);sub(/\[no-\]/,"");print $0"\n"orig;next}/\[$/{sub(/\[/,"");print;next}/\]$/{sub(/\[.+\]/,"");print;next}{print}' |
                awk -v p="$ignore_patterns" '$0 !~ p'
        )"

        mapfile -t COMPREPLY < <(compgen -W "$suggests" -- "${COMP_WORDS[COMP_CWORD]}")

        rm "$tempfile"
        return
    fi
}
complete -o default -F _git_completion git

_is_a_flag_typing() { [[ "$cur" =~ ^- ]]; }

_extract_fzf_flags() {
    fzf --help |
        awk '/^[ ]{4}-/' |
        awk -F',' '{for(i=1;i<=NF;i++) if (match($i,/--?[^ =]+/)) print substr($i, RSTART, RLENGTH)}'
}

_fzf_completion() {
    local -r cur="${COMP_WORDS[COMP_CWORD]}"

    if _is_a_flag_typing; then
        mapfile -t COMPREPLY < <(compgen -W "$(_extract_fzf_flags)" -- "${COMP_WORDS[COMP_CWORD]}")
    fi

    return
}
complete -o default -F _fzf_completion fzf

_extract_rg_flags() {
    rg --help | awk '/^[ ]{4}-/' | awk -F, '{for(i=1;i<=NF;i++) print $i}' | awk -F' ' '{print $1}' | awk -F'=' '{print $1}'
}

_rg_completion() {
    local -r cur="${COMP_WORDS[COMP_CWORD]}"

    if _is_a_flag_typing; then
        mapfile -t COMPREPLY < <(compgen -W "$(_extract_rg_flags)" -- "${COMP_WORDS[COMP_CWORD]}")
    fi

    return
}
complete -o default -F _rg_completion rg

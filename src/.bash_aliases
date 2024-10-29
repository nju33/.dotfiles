#!/usr/bin/env bash

_scripts_path() { printf "%s" "$DOTFILES_LOCATION_DIRECTORY"/scripts/"$1"; }
_utils_path() { _scripts_path "utils/$1"; }
print_path() { $(_utils_path print_path.sh) "$@"; }
misc() { $(_utils_path misc.sh) "$@"; }
devch() { $(_scripts_path devch.sh) "$@"; }
cat_tagged() { $(_scripts_path cat_tagged.sh) "$@"; }
rpe() { $(_scripts_path rpe.sh) "$@"; }

# shellcheck disable=SC1090
source "$(_utils_path core.sh)"

# List the README.md files, select one of them, and then read it
alias ream='fzf --query "README.md" --preview "glow -s dark {}" --preview-window "right:60%:wrap:hidden" --bind "ctrl-]:toggle-preview" --bind "ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up" --bind "ctrl-f:preview-page-down,ctrl-b:preview-page-up" --header "CTRL-]: toggle preview, CTRL-D/U: scroll half page, CTRL-F/B: scroll full page" --color "preview-bg:#1c1c1c,border:#333333"'
# Create .gitignore files with gibo and fzf
alias cgitignore='gibo list | fzf --multi | xargs gibo dump > .gitignore'
# Usage: cat _.yml | yaml2json: some method for others
alias yaml2json='dasel -r yaml -w json'
alias toml2json='dasel -r toml -w json'
alias xml2json='dasel -r xml -w json'

#
# NOTE:
#   A function assumed to be utilized exclusively with the [custom.memorization] field setting of starship
#   To help me remember the things I want to memorize
#
# The only task is to replace the Markdown todo syntax with a particular symbol icon
_custom_memorization() {
    local -r path="$HOME"/.custom.memorization.md
    sed -e 's/-\s\[\s\]\s*/󰄱 /g' -e 's/-\s\[x\]\s*/ /g' "$path"
}

# To manage (d)isposable variables declaring with `-(x)`
#
# References:
#   This feature is used on [custom."print disposable vars"] of Starship
declare -A _disposable_export_hashmap=()
declare -x _disposable_exports
dx() {
    [ "$1" == "-h" ] || [ "$1" == "--help" ] && {
        cat <<EOT
Usage: ${FUNCNAME[0]}
    Set a value:
        \`${FUNCNAME[0]} foo bar\`
    Get a value:
        \`${FUNCNAME[0]} foo\`
    Delete a value:
        \`${FUNCNAME[0]} x foo\`
EOT
    }

    # When using this for the first time in a child bash process, the below code
    # tries to restore `_disposable_export_hashmap` from that of the parent
    # process
    if [ -n "$_disposable_exports" ] && [ "${#_disposable_export_hashmap[@]}" -eq 0 ]; then
        IFS=';'
        for record in $_disposable_exports; do
            local key value
            key="$(cut -d= -f1 <<<"$record")"
            value="$(cut -d= -f2 <<<"$record")"

            _disposable_export_hashmap["$key"]="$value"
        done
        unset IFS
    fi

    # The associative array of Bash isn't inherited between parent and its
    # children; thus its circumstance is managed via `_disposable_exports`
    # as string
    post_process() {
        local -a _disposable_exports_array=()
        for key in "${!_disposable_export_hashmap[@]}"; do
            local value=${_disposable_export_hashmap[$key]}
            local record="$key=$value"
            _disposable_exports_array+=("$record")
        done

        _disposable_exports="$(
            IFS=';'
            echo "${_disposable_exports_array[*]}"
        )"
    }

    if [ "$1" = x ] && [ "$#" -gt 1 ]; then
        unset "_disposable_export_hashmap[$2]"
        post_process
        return
    fi

    case "$#" in
    2)
        _disposable_export_hashmap["$1"]="$2"
        post_process
        ;;
    1)
        (
            eval "$(awk -F'=' -v RS=';' '{print $1"=""\""$2"\""}' <<<"$_disposable_exports")"
            printf "%s" "${!1}"
        )
        ;;
    *) ;;
    esac
}

# The abbreviation $(ecm) stands for "edit custom memorization
ecm() {
    local -r path="$HOME"/.custom.memorization.md
    $VISUAL "$path"
}

# Copy a previous command upon looking back in history
cph() {
    _is_platform_mac || {
        pbcopy() {
            echo "caution: it is only on mac that chp works" >&2
            return 1
        }
    }

    local fifo_path
    fifo_path=$(misc gen fifo "${FUNCNAME[0]}")
    readonly fifo_path

    extract_fields_related_to_command() {
        local -r start_nf="$1"

        read -r line
        echo "$line" |
            awk -v ORS=" " -v start_nf="$start_nf" '{for(i=start_nf;i<=NF;i++) print $i}'
    }

    desired_fzf() {
        _is_platform_mac || {
            fzf
            return
        }

        (cat <"$fifo_path" | pbcopy) &
        fzf \
            --header 'C-s: cp NF, C-d: cp !N, C-f: cp Command' \
            --bind "ctrl-z:execute-silent(echo {1} > \"$fifo_path\")+abort" \
            --bind "ctrl-x:execute-silent(echo {2} > \"$fifo_path\")+abort" \
            --bind "ctrl-c:execute-silent(echo {5..} > \"$fifo_path\")+accept"
    }

    if [ "$#" -eq 0 ]; then
        # shellcheck disable=SC2016
        history | sort -r | cat -n | desired_fzf | extract_fields_related_to_command 5 | pbcopy
        return
    fi

    copy_by_nf_at() {
        # WORNING: when not working, examine whether the `HISTIGNORE` setting is inclding `cph*`
        history | tail -n"$1" | head -n1 | extract_fields_related_to_command 4 | pbcopy
    }

    copy_by_history_at() {
        # WORNING: when not working, examine whether the `HISTIGNORE` setting is inclding `cph*`
        history | awk -v at="$1" '$1 ~ at' | extract_fields_related_to_command 4 | pbcopy
    }

    if [[ $1 == "-" ]]; then
        copy_by_nf_at "1"
    elif [[ $1 =~ ^[0-9]+$ ]]; then
        copy_by_history_at "$1"
    elif [[ $1 =~ ^-[0-9]+$ ]]; then
        copy_by_nf_at "$(echo "$1" | grep -Eo "[0-9]+")"
    fi
}

# Rerun the previous commands sequentially upon selecting them
repc() {
    command -v fzf >/dev/null 2>&1 || {
        echo "Failed because the required dep, fzf, is not installed" >&2
        return 1
    }

    local temp_file
    temp_file=$(misc gen temp_file repc)
    readonly temp_file

    # shellcheck disable=SC2317
    cleanup() { rm -rf "${1?temp_file}"; }
    # shellcheck disable=SC2064
    trap "cleanup $temp_file" EXIT HUP INT TERM

    while read -r num; do
        fc -l "$num" "$num" | cut -f2 | sed -e's/^ *//' -e's/ *$//' >>"$temp_file"
    done < <(history | sort -r | fzf --multi | awk '{print $1h}' | sort)

    local command
    command="$(cat <"$temp_file" | awk '{if (NR == 1) {printf $0} else {printf "; "$0}}')"
    readonly command

    eval "$command"
    history -s "$command"
    history -a
}

# My own ranger to manage each bookmarks of git projects
# The abbreviation `sce` is made from `shift+command+e`—VSCode allocates it to `Focus on the Open Editors View`.
#
# Note:
#   It is necessary to add .ranger to the .gitignore of the current workspace to
#   not disturb someone
#
sce() {
    command -v ranger >/dev/null 2>&1 || {
        echo "Failed because the required dep, ranger, is not installed" >&2
        return 1
    }

    local -r home_dir=$HOME
    local current_dir ranger_dir
    current_dir=$(pwd)

    # To avoid treating it as a glob, wrap it with " on the right-hand side below.
    while [[ $home_dir != "$current_dir" && $current_dir != "/" ]]; do
        if [ -d "$current_dir/.git" ]; then
            ranger_dir="$current_dir/.ranger"

            if [ ! -d "$current_dir/.ranger" ]; then
                echo "Failed execution dut to non-existing '$current_dir/.ranger'" >&2
                exit 1
            fi
            break
        fi

        current_dir=$(dirname "$current_dir")
    done

    if [[ -n $ranger_dir ]]; then
        ranger --datadir="$ranger_dir"
    else
        ranger
    fi
}

# Search files, select a file, and view it–if on VSCode, to open by this instead of
# to view
fj() {
    local -r text="${1?fatal: the first argument is required}"
    local selected position="right" size="50%" file line
    shift

    cols="$(tput cols)"
    # Had current terminal been in narrow size, the preview would be located at
    # the bottom
    if [ "$cols" -lt 100 ]; then
        position="bottom"
    fi

    selected=$(rg --line-number --no-heading --color=always --smart-case "$@" "$text" |
        fzf --ansi --no-multi --delimiter : \
            --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
            --preview-window "${position}:${size}:+{2}-/2")

    file=$(awk -F: '{print $1}' <<<"$selected")
    line=$(awk -F: '{print $2}' <<<"$selected")

    if [[ -n $file ]]; then
        if [[ $TERM_PROGRAM = "vscode" ]]; then
            code -g "$file:$line"
        else
            bat --style=numbers --color=always --highlight-line "$line" "$file"
        fi
    fi
}

# Proxy for tmux to implement my desired subcommands
#
# Custom commands are follow these:
#   - `ks`: the abbreviation of `kill-server`
#   - `-`: re-enter the previous session
#   - `g`: establish a new session with its name having related to Git
#          if such a session has been established, you would have re-entered it
#   - ``(nothing): if you're currently in a Git directory, interpreted as `tmux g`, or
#                  `tmux`
tmux() {
    local _tmux_path
    _tmux_path="$(which tmux)"
    readonly _tmux_path

    git_folder_name() {
        basename "$(git rev-parse --show-toplevel)"
    }

    session_name_with() {
        printf "git]%s" "$1"
    }

    is_tmux_session_going_on() {
        tmux ls | cut -d: -f1 | grep -c ^"$1"
    }

    if [ "$#" -eq 0 ]; then
        if git rev-parse --git-dir >/dev/null 2>&1; then
            set -- g
        fi
    fi

    while [ "$#" -gt 0 ]; do
        case "$1" in
        ks)
            shift
            "$_tmux_path" kill-session "$@"
            return
            ;;
        g)
            local project_folder_name session_name

            shift
            # Whether the current directory is where a Git project is located or not
            if ! git rev-parse --git-dir >/dev/null 2>&1; then
                return 1
            fi

            project_folder_name="$(git_folder_name)"
            session_name="$(session_name_with "$project_folder_name")"

            if [ "$(is_tmux_session_going_on "$session_name")" -eq 1 ]; then
                "$_tmux_path" attach-session -t "$session_name" "$@"
            else
                # The session name will be `git]foo`, assuming that the Git
                # project's directory name is `foo`
                "$_tmux_path" new-session -s "$session_name" "$@"
            fi
            return
            ;;
        -)
            "$_tmux_path" attach -d
            return
            ;;
        *)
            $_tmux_path "$@"
            return
            ;;
        esac
    done

    "$_tmux_path"
}

# Tmux completion
_tmux_completion() {
    COMPREPLY=()
    local -a customized_tmux_args tmux_args

    customized_tmux_args=(
        "-"
        "ks" # stands for "kill-session"
        "g"  # establish a new session for a git project
    )

    tmux_args=(
        "new"
        "new-session"
        # "new-window"
        # "split-window"
        # "send-keys"
        "a"
        "attach"
        "attach-session"
        "kill-session"
        "kill-server"
        "ls"
        "list-sessions"
        "list-windows"
        "list-panes"
        "source-files"
        "switch-client"
        "select-window"
        "--help"
    )

    case "$3" in
    -t)
        local sessions
        sessions="$(tmux ls | cut -d":" -f1)"
        mapfile -t COMPREPLY < <(compgen -W "${sessions}" -- "${COMP_WORDS[COMP_CWORD]}")
        return 0
        ;;
    esac

    mapfile -t COMPREPLY < <(compgen -W "(${customized_tmux_args[*]} ${tmux_args[*]}" -- "${COMP_WORDS[COMP_CWORD]}")
}
complete -o default -F _tmux_completion tmux

# This function enables you to write a js code in VSCode and even more
# execut it in browsers: Safari, Google Chrome Canary.
#
# There are two methods for exiting the continuous execution:
#   1. Sending SIGINT by mostly using ctrl+c
#   2. Closeing the editing editor (Recommended)
#
# Usage:
#   1. Run `jsib safari # or chrome`, then open a temp file in VSCode
#   2. Open "google.com" in either Safari or Google Chrome Canary
#   3. Edit the file to set its content `console.log(document.title)`
#   4. Save and close successively: (1)command+s (2)command+w
#   5. Activate Safari and then look at the devtool console; you'll see `Google`
# To handle that data in the terminal, follow these steps:
#   ~snip~
#   3. Edit the file to set its content `document.title` (unnecessary
#      to wrap it in `console.log`)
#   4. Create a shell script file with a content like:
#      ```bash
#      while true; do
#          cat </tmp/.dotfiles/fifos/jsib
#      done
#      ```
#   5. Run the shell script file in a second terminal process
#   6. Close the file, which was edited in step 3
#   7. In the second terminal, you'll see `Google`
jsib() {
    local -r \
        current_task_pid=$$ \
        target_browser=${1?Execution failed due to the first argument, target_browser, is required}
    local temp_file fifo_path current_task_pid editor_task_pid watch_task_pid

    temp_file="$(misc gen temp_file "${FUNCNAME[0]}".js)"
    readonly temp_file

    fifo_path="$(misc gen fifo "${FUNCNAME[0]}")"
    readonly fifo_path

    echo $fifo_path

    (
        code --wait "$temp_file"
        kill $current_task_pid
    ) &
    editor_task_pid=$!

    (
        fswatch "$temp_file" --event Updated | while read -r; do
            [ -f "$temp_file" ] || {
                return 1
            }

            # shellcheck disable=SC2094,SC2030
            js_code="$(cat <"$temp_file" | prettier --stdin-filepath "$temp_file" 2>/dev/null)"
            prettier_result=$?

            if [ ! $prettier_result -eq 0 ]; then
                continue
            elif [ -z "$js_code" ]; then
                continue
            fi

            case "$target_browser" in
            safari)
                _jsib_safari "$js_code" >"$fifo_path"
                ;;
            chrome)
                _jsib_chrome "$js_code" >"$fifo_path"
                ;;
            *)
                echo "Failed to manage unknown a kind of target_browser value" >&2
                exit 1
                ;;
            esac
        done
    ) &
    watch_task_pid=$!

    # shellcheck disable=SC2317
    cleanup() {
        rm -rf "$1"
        kill "$2" "$3" >/dev/null 2>&1
    }
    # shellcheck disable=SC2064
    trap "cleanup $temp_file $watch_task_pid $editor_task_pid" EXIT HUP INT TERM

    wait
}

_jsib_completion() {
    COMPREPLY=()
    mapfile -t COMPREPLY < <(compgen -W "safari chrome" -- "${COMP_WORDS[COMP_CWORD]}")
    return
}
complete -o default -F _jsib_completion jsib

_jsib_safari() {
    osascript <<EOF
tell application "Safari"
    set result to do JavaScript "
        ${1//\"/\\\"}
    " in current tab of front window
    return result
end tell
EOF
}

_jsib_chrome() {
    osascript <<EOF
tell application "Google Chrome Canary"
    set currentTab to active tab of front window
    tell currentTab
        set result to execute javascript "
            ${1//\"/\\\"}
        "
        return result
    end tell
end tell
EOF
}

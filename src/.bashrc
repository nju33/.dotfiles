#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Increase file descriptor limit
ulimit -n 2048

# Window size check
shopt -s checkwinsize

# Enable advanced pattern matching
#shopt -s globstar

# Allow last command in pipeline to run in current shell
# to leverage it is convenient but turning off, considering risks of
# environmental differences with others
# shopt -s lastpipe

# Enable i-search
stty -ixon

# History settings
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
# in .bash_aliases, implementing these commands:
#   - repc
#   - cph
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:pwd:date:repc*:cph*"
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Enable history appending instead of overwriting
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Turn off a message like "You have new mail in /var/mail/<user>", which be randomly
# encountered in terminal
unset MAIL

# Improved history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Force prompt to write history after every command
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Set default editors
if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
    export VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
    export VISUAL='vim'
else
    export EDITOR='vi'
    export VISUAL='vi'
fi

# In the terminal of VSCode, the VISUAL environment variable is configured to
# use the code editor itself.
#
# The primary intention is to use ranger underneath VSCode
[[ -n $EDITOR ]] && command -v code >/dev/null 2>&1 && [[ $TERM_PROGRAM = "vscode" ]] && {
    export VISUAL='code'
}

# Aliases for quick editing
alias edit='$EDITOR'
alias vi='$EDITOR'
alias vim='$EDITOR'

# Open files in background (for GUI editors)
if [[ $EDITOR =~ g?(view|vim) ]]; then
    alias e='$EDITOR'
else
    alias e='$EDITOR 2>/dev/null &'
fi

# Set less as the default pager
export PAGER='less'

# Configure less
export LESS='-R --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# GPG configuration
GPG_TTY=$(tty)
export GPG_TTY

# PATH settings
_set_paths() {
    local -ar path_dirs=(
        # The under path will be automatically added via somewhere else
        # "$HOME/.cargo/bin"
        "$HOME/.deno/bin"
        "$HOME"/Library/pnpm
        "$HOME/.local/bin"
    )
    local csv
    csv="$(
        IFS=':'
        echo "${path_dirs[*]}"
    )"
    readonly csv

    for d in "${path_dirs[@]}"; do [ ! -d "$d" ] && mkdir -p "$d"; done

    [[ $PATH == *"$csv"* ]] || PATH="$csv:$PATH"

    export PATH
}
_set_paths

# asdf configuration
_setup_asdf() {
    local comm
    comm="$(brew --prefix asdf)"
    readonly comm

    if [ -d "$comm" ]; then
        . "$comm/libexec/asdf.sh"
        . "$comm/etc/bash_completion.d/asdf.bash"
    fi
}
_setup_asdf

# Load aliases
if [ -s "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

# Set up fzf key bindings and fuzzy completion
command -v fzf >/dev/null && eval "$(fzf --bash)"
# Starship prompt
command -v starship >/dev/null && eval "$(starship init bash)"

if [ -s "$HOME/.ripgreprc" ]; then
    export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# SSH agent configuration for tmux on Linux
if [ "$(uname)" = "Linux" ]; then
    agent="$HOME/.ssh/agent"
    if [ -S "$SSH_AUTH_SOCK" ]; then
        case $SSH_AUTH_SOCK in
        /tmp/*/agent.[0-9]*)
            ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
            ;;
        esac
    elif [ -S $agent ]; then
        export SSH_AUTH_SOCK=$agent
    else
        echo "no ssh-agent"
    fi
fi

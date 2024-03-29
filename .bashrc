# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if command -v starship >/dev/null; then
  eval "$(starship init bash)"
fi

devch() {
  local params=''
  local temp="$(mktemp -d -t 'chrome-remote_data_dir')"
  local user_data_dir="$temp"
  local remote_debugging_port=9222

  trap "rm $temp; exit 1" 1 2 3 15

  while (( "$#" )); do
    case "$1" in
      -p|--remote-debugging-port)
        remote_debugging_port="$2"
        shift 2
        ;;
      -d|--user_data_dir)
        rm "$temp"
        mkdir -p "$HOME/.devch/$2"
        user_data_dir="$HOME/.devch/$2"
        shift 2
        ;;
      -*|--*)
        echo "Error: Unsupported flag $1" >&2
        return 1
        ;;
      *)
        params="$params $1"
        shift
        ;;
    esac
  done

  set -x
  /Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary \
    --user-data-dir="$user_data_dir" \
    --remote-debugging-port="$remote_debugging_port" \
    --no-first-run \
    --no-default-browser-check \
    --flag-switches-begin \
    --allow-insecure-localhost \
    --flag-switches-end \
    --enable-audio-service-sandbox \
    --renderer-process-limit=2 \
    --disable-web-security
  set +x
}

GPG_TTY=$(tty)
export GPG_TTY

# for the ssh-agent on tmux
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

# for i-search
# " stty -a
# " stop = ^S;
stty stop undef
stty start undef

_yarn_completion() {
  local yarn_options=""
  local yarn_commands=""
  local run_scripts=""

  if [[ "$2" =~ ^- ]]; then
    yarn_options=$(yarn --help | grep Commands -B 50 | grep -- -- | sed -e "s/-., //" | sed -E 's/.*(--[a-z-]+).*/\1/')
    COMPREPLY=($(compgen -W "$yarn_options" -- "${COMP_WORDS[COMP_CWORD]}"))
    return 0
  fi

  yarn_commands=$(yarn --help | grep Commands -A40 | grep - | sed 's/-\s\([a-z-]\+\).*/\1/' | xargs)
  run_scripts=""

  if [ -e "package.json" ]; then
    run_scripts=$(node -p "Object.keys(require('./package.json').scripts).join(' ')")
  fi

  case "$3" in
  yarn)
    COMPREPLY=($(compgen -W "$yarn_commands $run_scripts" -- "${COMP_WORDS[COMP_CWORD]}"))
    ;;
  install)
    COMPREPLY=($(compgen -W "--frozen-lockfile --ignore-scripts" -- "${COMP_WORDS[COMP_CWORD]}"))
    ;;
  run)
    COMPREPLY=($(compgen -W "$run_scripts" -- "${COMP_WORDS[COMP_CWORD]}"))
    ;;
  *) ;;

  esac
}
complete -o default -F _yarn_completion yarn

_code_completion() {
  # local current="${COMP_WORDS[COMP_CWORD]}"
  # local files="$(ls -tr "$(dirname current)")"
  local files="$(rg -l . -g "!*.md" -g"!*/index.ts")"
  COMPREPLY=($(compgen -W "$files" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -o default -F _code_completion code

_tmux_completion() {
  if [ "$3" = "-t" ]; then
    local sessions="$(tmux ls | cut -d: -f1)"
    COMPREPLY=($(compgen -W "$sessions" -- "${COMP_WORDS[COMP_CWORD]}"))
  else
    COMPREPLY=()
  fi
}
complete -o default -F _tmux_completion tmux

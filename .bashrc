# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export YVM_DIR="$HOME/.yvm"
[ -r $YVM_DIR/yvm.sh ] && . "$YVM_DIR/yvm.sh"

if command -v starship > /dev/null; then
  eval "$(starship init bash)"
fi

alias npm-run-all='yarn npm-run-all'
alias run-s='yarn run-s'
alias run-p='yarn run-p'
alias ts-node='yarn ts-node'
alias tsc='yarn tsc'
alias cz='yarn cz'
alias lerna='yarn lerna'
alias eslint='yarn eslint'
alias jest='yarn jest'
alias now='yarn now'
alias micro='yarn micro'
alias micro-dev='yarn micro-dev'
alias next='yarn next'
alias nuxt='yarn nuxt'
alias parcel='yarn parcel'
alias rollup='yarn rollup'
alias webpack-dev-server='yarn webpack-dev-server'
alias webpack='yarn webpack'
alias sls='yarn serverless'
alias nodemon='yarn nodemon'
alias pm2='yarn pm2'
alias docsify='yarn docsify'
alias docz='yarn docz'

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

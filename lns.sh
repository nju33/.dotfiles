#!/usr/bin/env bash

function replace_to_path() {
  echo $1 | sed 's/_/\//g'
}

function run() {
  local files=(
    .bashrc
    .bash_profile
    .bash_aliases
    # .zshrc
    # .zsh.d
    .vimrc
    .vim
    .gitconfig
    .agignore
    # .hyper.js
    .tmux.conf
    # emmet
    .config_alacritty_alacritty.yml
    # .config_fish_completions_remote-development.fish
    # .config_fish_functions_remote-development.fish
    # .config_fish_config.fish
    .config_peco_config.json
    .config_starship.toml
    init.el
  )
  for file in "${files[@]}"; do
    local src
    local dest

    src="$(pwd)/$file"
    dest="$HOME/$file"

    if [ "$file" != ".bash_profile" ]; then
      dest="$HOME/$(replace_to_path $file)"
    fi

    echo "$src -> $dest"
    rm -rf $dest
    ln -s $src $dest
  done
}
run

# cp fonts/*.{ttf,otf} /Library/Fonts/

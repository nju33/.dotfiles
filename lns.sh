#!/bin/sh

function replace_to_path() {
  echo $1 | sed 's/_/\//g'
}

function run() {
  local files=(
    # .sshrc .sshrc.d
    .zshrc .zsh.d .vimrc .vim .gitconfig
    .agignore .hyper.js emmet
    .config_fish_functions_remote.fish
    .config_fish_config.fish
    .config_peco_config.json
    # .config_moza
  )
  for f in ${files[@]}; do
    local src=`pwd`/$f
    local dest=~/`replace_to_path $f`
    echo "$src -> $dest"
    rm -rf $dest; ln -s $src $dest
  done
}
run

# cp fonts/*.{ttf,otf} /Library/Fonts/

#!/bin/sh

function run() {
  local files=(
    .zshrc .zsh.d .vimrc .vim
    .hyperterm.js hyperterm emmet .npmrc
  )
  for f in ${files[@]}; do
    rm -rf ~/$f >/dev/null 2>&1
    ln -s `pwd`/$f ~/$f
  done
}
run

cp fontsFolder/*.{ttf,otf} /Library/Fonts/


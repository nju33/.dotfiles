#!/bin/sh

function run() {
  local files=(
    .zshrc .zsh.d .vimrc .vim .sbt
    .hyperterm.js hyperterm emmet .npmrc
  )
  for f in ${files[@]}; do
    rm -rf ~/$f >/dev/null 2>&1
    ln -s `pwd`/$f ~/$f
  done
}
run

cp fonts/*.{ttf,otf} /Library/Fonts/


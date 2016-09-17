#!/bin/sh

function del() {
  rm -rf ~/$1 >/dev/null 2>&1
}

function run() {
  local files=(
    .zshrc .zsh.d .vimrc .hyperterm.js hyperterm
    emmet .npmrc
  )
  for t in ${files[@]}; do del $t; done
  for t in ${files[@]}; do ln -s `pwd`/$t ~/$t; done
}

run

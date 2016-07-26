#!/bin/sh

rm ~/.zshrc
rm -rf ~/.zsh.d
rm ~/.vimrc
rm ~/.hyperterm.js
rm ~/hyperterm

ln -s `pwd`/.zshrc ~/.zshrc
ln -s `pwd`/.zsh.d ~/.zsh.d
ln -s `pwd`/.vimrc ~/.vimrc
ln -s `pwd`/.hyperterm.js ~/.hyperterm.js
ln -s `pwd`/hyperterm ~/hyperterm

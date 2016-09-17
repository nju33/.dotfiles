#!/bin/sh

rm ~/.zshrc
rm -rf ~/.zsh.d
rm ~/.vimrc
rm ~/.hyperterm.js
rm -rf ~/hyperterm
rm -rf ~/emmet

ln -s `pwd`/.zshrc ~/.zshrc
ln -s `pwd`/.zsh.d ~/.zsh.d
ln -s `pwd`/.vimrc ~/.vimrc
ln -s `pwd`/.hyperterm.js ~/.hyperterm.js
ln -s `pwd`/hyperterm ~/hyperterm
ln -s `pwd`/emmet ~/emmet

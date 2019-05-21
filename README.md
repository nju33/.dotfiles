### dotfiles

```bash
sh lns.sh
```

### fish

[#](https://fishshell.com/docs/current/tutorial.html)

```sh
touch ~/.config/fish/conf.d/nju33.fish
```

```
set -x NJU33_USER_PASSWORD ...
```

### theme & plugins

```bash
omf install eden

# brew install peco thefuck
# curl -L https://get.oh-my.fish | fish
omf install peco thefuck
omf install https://github.com/nju33/plugin-cpd
omf install https://github.com/nju33/plugin-rmnm
```

### vim

the vim-plug install

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

the vim package can install by `:PlugInstall` command which is installed by the vim-plug.


```sh
:PlugInstall
```

### brew

https://github.com/Homebrew/homebrew-bundle

```bash
# brew tap Homebrew/bundle
brew bundle dump [-f]
brew bundle
```

### atom

```bash
apm list -bi --no-dev > Apmfile  
apm install --packages-file Apmfile
```

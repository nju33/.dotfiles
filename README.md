### dotfiles

```bash
sh lns.sh
```

### fish

[#](https://fishshell.com/docs/current/tutorial.html)

### plugins

```bash
# brew install peco thefuck
# curl -L https://get.oh-my.fish | fish
omf install peco thefuck
```

### vim

```bash
$ curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
$ sh ./installer.sh {specify the installation directory}

vi .vimrc
# set runtimepath+=<path until installer.sh>
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

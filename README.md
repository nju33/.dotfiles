### dotfiles

```bash
sh lns.sh
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
apm list -b > Apmfile 
apm install --packages-file Apmfile
```

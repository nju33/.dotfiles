# .dotfiles

This environment assumed that is depending on the under tools:

- [Homebrew](https://brew.sh)
- [Git](https://git-scm.com)
- [Alacritty](https://alacritty.org)
- [Starship](https://starship.rs)
- [Prettier](https://prettier.io)
- [tmux](https://github.com/tmux/tmux/wiki)
- [nvm](https://github.com/nvm-sh/nvm)
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [EditorConfig](https://editorconfig.org)
- [SchellCheck](https://www.shellcheck.net)
- [Navi](https://github.com/denisidoro/navi)
- …

I really appreciate these tools and around the people involved in them.

## Setup

### Bash

1. When cloned in a location other than `$HOME/.dotfiles`, the `DOTFILES_LOCATION_DIRECTORY` environment variable, which is declared in the `src/.bash_profile` file, needs to be modified to the actual path.
2. Create symbolic links to each `src/.bash_profile` and `src/.bashrc` as these steps:  
  ```bash
  ln -s '<path/to>/src/.bash_profile' "$HOME/.bash_profile"
  ln -s '<path/to>/src/.bashrc' "$HOME/.bashrc"
  ```
3. All is done. you then just login by establishing new terminal session.

### Homebrew

All of necessary is the command below just run in the <project_root>/:

```bash
brew bundle
```

## Particular cheat of Navi

The commands shown above also are able to comfirm and execute by Navi like to the below:

```bash
navi --path .dotfiles.cheat --query readme
```

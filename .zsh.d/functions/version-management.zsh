function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_rbenv() {
  # https://github.com/rbenv/rbenv#installation

  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
}

function install_pyenv() {
  # https://github.com/yyuu/pyenv#installation

  git clone https://github.com/yyuu/pyenv.git ~/.pyenv
}

export LANG=ja_JP.UTF-8
export PATH=/usr/local/bin:$PATH
# ${fg[色指定]}...${reset_color}
autoload colors
colors
# also do history expansion on space
bindkey ' ' magic-space
bindkey -e
# cd -[tab]
# 過去のディレクトリを保管
# スタックから重複排除
setopt auto_pushd
setopt pushd_ignore_dups
#typoチェック
setopt  correct
# 色々補完
autoload -Uz compinit
compinit
# {1..9} ->  1 2 ..  9
setopt braceccl
# メモリ内の履歴の数
HISTSIZE=1000
# 保存される履歴の数
SAVEHIST=1000
# 複数のセッションで履歴を共有
setopt share_history
# 履歴から重複排除
setopt hist_ignore_all_dups
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 開始と終了を記録
setopt EXTENDED_HISTORY
# 正規表現なんかでマッチしなくても、エラーを出さない
setopt no_nomatch
# 小文字でも大文字にマッチ変換
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

function resizeForIcns() {
  local base=icon_512x512@2x.png
  if [ ! -e $base ]; then
    echo 'icon_512x512@2x.pngファイルがありません'
    return 1;
  fi

  convert -resize 16x $base icon_16x16.png
  convert -resize 32x $base icon_16x16@2x.png
  convert -resize 32x $base icon_32x32.png
  convert -resize 64x $base icon_32x32@2x.png
  convert -resize 128x $base icon_128x128.png
  convert -resize 256x $base icon_128x128@2x.png
  convert -resize 256x $base icon_256x256.png
  convert -resize 512x $base icon_256x256@2x.png
  convert -resize 512x $base icon_512x512.png

  pngquant --ext .png --force *.png

  return 0;
}

# mkdir; cd
function mkdirc() {
  if [ -z $1 ]; then
    echo 'ディレクトリ名を忘れてます'
    return 1;
  fi

  mkdir $1 && cd $_
  return 0;
}
# ポートが仕様中かとプロセスIDを調べる
alias lsofip='lsof -i -P | grep'

function today() {
  today=`date +"%FT%TZ"`
  echo $today
  echo $today > /dev/null | pbcopy
  return 0;
}

function glu() {
  if [ -z $1 ]; then
    echo "totora0155? nju33?"
    return 1;
  fi

  case "$1" in
    "totora0155")
      git config --local user.name "totora0155";
      git config --local user.email "jun.sasaki@mvrck.co.jp" ;
      echo "Change to totora0155";;
    "nju33")
      git config --local user.name "nju33";
      git config --local user.email "nju33.ki@gmail.com" ;
      echo "Change to nju33";;
  esac
}

function glsu() {
  git diff --name-status --diff-filter=U | cut -f 2
  return 0;
}

function copyDockerMachineIP() {
  echo `docker-machine ip $1` > /dev/null 2>&1 | pbcopy
  return 0;
}

# NodeJS
# for NodeJS > v6.x
alias node='node --harmony'

# GO
function remove_gopathbin() {
  local path=`echo $PATH | awk -v p=:$GOPATH/bin '{sub(p, "", $0);print}'`
  echo $path
}
function set_local_gopath() {
  local removed=`remove_gopathbin`
  if [ "$1" = "global" ]; then
    export GOPATH="$HOME/.go"
  else
    export GOPATH=`pwd`
  fi
  export PATH="$removed:$GOPATH/bin"
}
export GOPATH='/Users/nju33/.go'
export PATH="$PATH:$GOPATH/bin"

# Ruby
[ -d ~/.rbenv ] && export PATH="~/.rbenv/bin:$PATH"

# Python
[ -d ~/.pyenv ] && (
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
)

# Java
type jenv > /dev/null 2>&1
[[ $? == 0 ]] && eval "$(jenv init -)"
export JAVA_OPTS="-Xss10m"
# Scala
export PLAY_OPTS="-Xms2048m -Xmx2048m -Xss10m -XX:+UseParallelGC"
export SBT_OPTS="-Xms2048m -Xmx2048m -Xss10m -XX:+UseParallelGC"

[ -e ~/.zsh.d/functions/git.zsh ] && source ~/.zsh.d/functions/git.zsh
[ -e ~/.zsh.d/functions/tinify.zsh ] && source ~/.zsh.d/functions/tinify.zsh

## Alias
[ -e ~/.zsh.d/aliases/unix ] && source ~/.zsh.d/aliases/unix
[ -e ~/.zsh.d/aliases/git ] && source ~/.zsh.d/aliases/git

[ -e $HOME/.zsh.d/prompt.zsh ] && source $HOME/.zsh.d/prompt.zsh

[ -e ~/.zsh.d/functions/version-management.zsh ] &&
  source ~/.zsh.d/functions/version-management.zsh

[ -e /usr/local/opt/zplug ] && export ZPLUG_HOME=/usr/local/opt/zplug
[ -e ~/.zplug/zplug ] && [[ $ZPLUG_HOME == "" ]] && export ZPLUG_HOME=$HOME/.zplug
if [[ $ZPLUG_HOME != "" ]]; then
  source $ZPLUG_HOME/init.zsh

  zplug "totora0155/colorhexa-search-zsh", nice:-20

  zplug "kennethreitz/autoenv", nice:-20, \
    hook-load:"source $ZPLUG_HOME/repos/kennethreitz/autoenv/activate.sh"

  #https://github.com/supercrabtree/k
  zplug "supercrabtree/k", nice:10, as:"command", \
    hook-load:"source $ZPLUG_HOME/repos/supercrabtree/k/k.plugin.zsh"

  #https://github.com/rupa/z
  zplug "rupa/z", nice:10, as:"command", \
    hook-load:"source $ZPLUG_HOME/repos/rupa/z/z.sh"

  zplug "zsh-users/zsh-autosuggestions", nice:10
  if zplug check "zsh-users/zsh-autosuggestions"; then
    bindkey '^]' autosuggest-accept
  fi

  zplug "zsh-users/zsh-syntax-highlighting", nice:19

  zplug "zsh-users/zsh-history-substring-search", nice:18
  if zplug check "zsh-users/zsh-history-substring-search"; then
    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down
  fi
  zplug load
fi

type peco > /dev/null 2>&1
if [[ $? == 0 ]] {
  function peco-select-history() {
      local tac
      if which tac > /dev/null; then
          tac="tac"
      else
          tac="tail -r"
      fi
      BUFFER=$(\history -n 1 | \
          eval $tac | \
          peco --query "$LBUFFER")
      CURSOR=$#BUFFER
      zle clear-screen
  }
  zle -N peco-select-history
  bindkey '^r' peco-select-history
}

[ -e ~/.zshrc.local ] && source ~/.zshrc.local

export YVM_DIR=/Users/nju33/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

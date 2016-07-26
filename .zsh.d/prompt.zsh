# VCS = Version Control System
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a]'
precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

setopt prompt_subst
PROMPT="%n:%{${fg[cyan]}%}%_%~%{${reset_color}%}:%1(v|%F{green}%1v%f|)
$ "
# ヒアドキュメントなど複数行のとき
PROMPT2="%{${fg[blue]}%}%_> %{${reset_color}%}"
# コマンドをtypoしたときなど
SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"

set -gx PATH {$HOME}/.cargo/bin $PATH

alias aghtml='ag -S --html --jade --pager="less -S -n -i -F -X"'
alias agjs='ag -S --js --pager="less -S -n -i -F -X"'
alias agts='ag -S --ts --pager="less -S -n -i -F -X"'
alias agjson='ag -S --json --stats'
alias agcss='ag -S --css --pager="less -S -n -i -F -X"'
alias agless='ag -S --less --pager="less -S -n -i -F -X"'
alias agsass='ag -S --sass --pager="less -S -n -i -F -X"'
alias agstyl='ag -S --stylus --pager="less -S -n -i -F -X"'
alias agrs='ag -S --rust --pager="less -S -n -i -F -X"'
alias agtoml='ag -S --toml --pager="less -S -n -i -F -X"'
alias agyaml='ag -S --yaml --pager="less -S -n -i -F -X"'
alias aggo='ag -S --go --pager="less -S -n -i -F -X"'
alias agpy='ag -S --python --pager="less -S -n -i -F -X"'
alias agphp='ag -S --php --pager="less -S -n -i -F -X"'
alias agsh='ag -S --sh --pager="less -S -n -i -F -X"'
alias agsql='ag -S --sql --pager="less -S -n -i -F -X"'

function mkdirc --description 'mkdir + cd'
  set -l name $argv[1]

  if test -z "$name"
    printf ( _ "%s: Name cannot be empty\n") mkdirc
    return 1
  end

  mkdir -p $name; and cd $name
end

function fish_user_key_bindings
  bind \cp 'peco_select_history (commandline -b)'
  bind \e\e 'thefuck-command-line'
end

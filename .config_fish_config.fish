set -gx PATH {$HOME}/.cargo/bin $PATH

alias j='jobs'
function jk --description 'kill -9 to all background jobs'
  jobs > /dev/null 2>&1

  if test $status -eq 1
    printf ( _ "%s: Background jobs not found\n") jk
    return 1
  end

  for p in (jobs --pid | sed '0d')
    kill -9 $p
  end
end

alias aghtml='ag -S --html --jade'
alias agjs='ag -S --js'
alias agts='ag -S --ts'
alias agjson='ag -S --json'
alias agcss='ag -S --css'
alias agless='ag -S --less'
alias agsass='ag -S --sass'
alias agstyl='ag -S --stylus'
alias agrs='ag -S --rust'
alias agtoml='ag -S --toml'
alias agyaml='ag -S --yaml'
alias aggo='ag -S --go'
alias agpy='ag -S --python'
alias agphp='ag -S --php'
alias agsh='ag -S --sh'
alias agsql='ag -S --sql'

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

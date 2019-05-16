set -Ux TZ Asia/Tokyo
set -gx PATH {$HOME}/.cargo/bin $PATH
set -gx PATH {$HOME}/.deno/bin $PATH
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

set -gx PGHOST 0.0.0.0
set -gx PGUSER postgres
set -gx PGPORT 54321
set -gx PGPASSWORD ''
function pg_server --description 'docker run pg'
  docker run --rm -p 54321:5432 nju33/postgres
end

function chrome-dev --description 'open chrome-canary in devmode'
  /Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary --args --disable-web-security --user-data-dir
end

alias «='pwd | pbcopy'

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

function runts
  set -l tmpfile (mktemp)
  set -l tmpfile_ts {$tmpfile}.ts
  mv $tmpfile $tmpfile_ts

  if test -n "$argv"
    echo $argv > $tmpfile_ts
  else
    cat 1> $tmpfile_ts
  end

  cat $tmpfile_ts
  deno $tmpfile_ts

  rm $tmpfile_ts
end

function sourcefish --description 'load ~/.config/fish/config.fish'
  echo source  ~/.config/fish/config.fish
  source  ~/.config/fish/config.fish
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

alias .j='just --justfile ~/.justfile --working-directory .'

alias ts-node='yarn ts-node'
alias tsc='yarn tsc'
alias lerna='yarn lerna'
alias next='yarn next'
alias nuxt='yarn nuxt'
alias micro-dev='yarn micro-dev'
alias webpack-dev-server='yarn webpack-dev-server'
alias webpack='yarn webpack'
alias parcel='yarn parcel'
alias rollup='yarn rollup'
alias gulp='yarn gulp'
alias jest='yarn jest'
alias eslint='yarn eslint'
alias prettier='yarn prettier'
alias now='yarn now'
alias docz='yarn docz'
alias nodemonn='yarn nodemon'
alias pm2='yarn pm2'

function .env --description 'To edit a closest .env file'
  set -l cwd (pwd)
  if test -n "$argv[1]"
    set cwd "$argv[1]"
  end

  set -l relative_since_home_dir (string replace "$HOME" "" "$cwd")
  set -l env_file "$cwd/.env"

  if test -f "$env_file"
    echo "$relative_since_home_dir/.env found!"
    vim "$env_file"
    return 0;
  end

  set -l parent_dir (dirname "$cwd")

  if test "$parent_dir" = "/Users"
    echo "Not found a .env file each hierarchy"
    return 1;
  end

  echo "$relative_since_home_dir/.env not found, thus moving to parent dir"
  .env (dirname "$cwd")
end

function qa --description 'To access github/nju33/* quickly'
  set -l alias_name "$argv[1]"
  set -l target_directory "$HOME/github/nju33/$alias_name"

  if test ! -d "$target_directory"
    echo "$target_directory is not found"
    return 1
  end

  cd "$target_directory"
end
complete -x -c qa -d 'dirname' -a '(ls (echo "$HOME/github/nju33"))'

function reponame --description 'get a GitHub remote url by ssh'
  if test -z "$argv[1]"
    echo リポジトリ名を指定して
    return 1
  end

  echo git@github.com:nju33/$argv[1].git
end

function .gitignore --description 'create .gitinogre'
  set -l name $argv[1]
  echo $name

  switch $name
    case "node"
      gibo Node macOS Windows SublimeText VisualStudioCode Vim Emacs Xcode Ecilipse > .gitignore
    case "rust"
      gibo Rust macOS Windows SublimeText VisualStudioCode Vim Emacs Xcode Ecilipse > .gitignore
    case '*'
      echo unknown name
  end
end

function mkdirc --description 'mkdir + cd'
  set -l name $argv[1]

  if test -z "$name"
    printf ( _ "%s: Name cannot be empty\n") mkdirc
    return 1
  end

  mkdir -p $name; and cd $name
end

function fish_user_key_bindings
  # constrol+o
  bind \co 'peco_select_history (commandline -b)'
  # esc+esc
  bind \e\e 'thefuck-command-line'
end

function n_error
  echo 'please set variable to use `set -x $NJU33_USER_PASSWORD ...` in ~/.config/fish/conf.d/*'
end

function n9
  if echo $NJU33_USER_PASSWORD | grep . > /dev/null
    echo $NJU33_USER_PASSWORD | sudo -S n 9 > /dev/null 2>&1
  else
    n_error
  end
end

function n10
  if echo $NJU33_USER_PASSWORD | grep . > /dev/null
    echo $NJU33_USER_PASSWORD | sudo -S n 10 > /dev/null 2>&1
  else
    n_error
  end
end

function n11
  if echo $NJU33_USER_PASSWORD | grep . > /dev/null
    echo $NJU33_USER_PASSWORD | sudo -S n 11 > /dev/null 2>&1
  else
    n_error
  end
end

function n12
  if echo $NJU33_USER_PASSWORD | grep . > /dev/null
    echo $NJU33_USER_PASSWORD | sudo -S n 12 > /dev/null 2>&1
  else
    n_error
  end
end

function serveo
  set -l subdomain $argv[1]

  if test -n "$subdomain"
    ssh -R $subdomain:80:localhost:8888 serveo.net
  else
    ssh -R 80:localhost:8888 serveo.net
  end

end
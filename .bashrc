export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export YVM_DIR="$HOME/.yvm"
[ -r $YVM_DIR/yvm.sh ] && . "$YVM_DIR/yvm.sh"

eval "$(starship init bash)"

alias npm-run-all='yarn npm-run-all'
alias run-s='yarn run-s'
alias run-p='yarn run-p'
alias ts-node='yarn ts-node'
alias tsc='yarn tsc'
alias cz='yarn cz'
alias lerna='yarn lerna'
alias eslint='yarn eslint'
alias jest='yarn jest'
alias now='yarn now'
alias micro='yarn micro'
alias micro-dev='yarn micro-dev'
alias next='yarn next'
alias nuxt='yarn nuxt'
alias parcel='yarn parcel'
alias rollup='yarn rollup'
alias webpack-dev-server='yarn webpack-dev-server'
alias webpack='yarn webpack'
alias sls='yarn serverless'
alias nodemon='yarn nodemon'
alias pm2='yarn pm2'
alias docsify='yarn docsify'
alias docz='yarn docz'

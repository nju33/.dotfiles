export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export YVM_DIR="$HOME/.yvm"
[ -r $YVM_DIR/yvm.sh ] && . "$YVM_DIR/yvm.sh"

eval "$(starship init bash)"

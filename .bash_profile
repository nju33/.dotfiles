if [ "$(uname)" == 'Darwin' ]; then
  # for Catalina
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"

if [ "$(uname)" == 'Darwin' ]; then
  source ~/.bashrc
fi

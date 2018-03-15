hard-yarn:
  rm -rf node_modules yarn.lock
  yarn cache clean
  yarn

setup-ts-module:
  yarn add -D \
    typescript \
    tslint \
    @geekcojp/tslint-config \
    prettier \
    microbundle \
    jest \
    @types/jest \
    ts-jest

  cp ~/.dotfiles/configfiles/tsconfig.json tsconfig.json
  cp ~/.dotfiles/configfiles/tslint.json tslint.json

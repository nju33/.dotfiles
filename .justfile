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

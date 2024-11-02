#!/bin/sh

# Update pnpm to the latest if it's outdated
main() {
    nvm_sh="$HOME"/.nvm/nvm.sh
    # shellcheck source=$HOME/.nvm/nvm.sh
    [ -s "$nvm_sh" ] && source "$nvm_sh"

    local="$(pnpm --version 2>/dev/null)"
    remote="$(nvm exec --lts --silent npm view pnpm version)"

    if [ ! "$local" = "$remote" ]; then
        source "$(dirname "$0")"/../../core.sh

        (
            set -x
            curl -fsSL https://get.pnpm.io/install.sh | PNPM_VERSION="$remote" SHELL='' sh -
        )
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

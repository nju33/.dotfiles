#!/bin/sh

# Update pnpm to the latest if it's outdated
main() {
    nvm_sh="$HOME"/.nvm/nvm.sh
    # shellcheck source=$HOME/.nvm/nvm.sh
    [ -s "$nvm_sh" ] && source "$nvm_sh"

    local="$(pnpm --version 2>/dev/null)"
    remote="$(nvm exec --lts --silent npm view pnpm version)"

    if [ ! "$local" = "$remote" ]; then
        bashrc="$(dirname "$0")"/../../../../src/.bashrc
        chmod -w "$bashrc"

        (
            set -x
            curl -fsSL https://get.pnpm.io/install.sh |
                PNPM_VERSION="$remote" sh - |
                awk '/Copying pnpm CLI from/' |
                awk -F' ' '{print $5}' |
                xargs -n1 -I{} sh -c "cp {} \"$HOME\"/Library/pnpm/pnpm"
        )

        chmod +w "$bashrc"
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

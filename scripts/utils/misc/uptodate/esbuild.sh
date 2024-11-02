#!/bin/sh

# Update esbuild to the latest if it's outdated
main() {
    nvm_sh="$HOME"/.nvm/nvm.sh
    # shellcheck source=$HOME/.nvm/nvm.sh
    [ -s "$nvm_sh" ] && source "$nvm_sh"

    local="$(esbuild --version 2>/dev/null)"
    remote="$(nvm exec --lts --silent npm view esbuild version)"

    if [ ! "$local" = "$remote" ]; then
        source "$(dirname "$0")"/../../core.sh

        (
            set -x
            _move_user_specific_bin_dir
            curl -fsSL https://esbuild.github.io/dl/v"$remote" | sh
        )
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

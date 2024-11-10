#!/bin/sh

install_the_latest() {
    readonly path=xc.tar.gz

    (
        set -x
        curl -LfsS "https://github.com/joerdav/xc/releases/download/v$1/xc_${1}_darwin_arm64.tar.gz" -o "/tmp/xc.tar.gz"
        tar xzf "$path" -C "$HOME"/.local/bin/
        rm "$path"
    )
}

# Update xc to the latest if it's outdated
main() {
    if command -v xc >/dev/null 2>&1; then
        install_the_latest
        return
    fi

    local="$(
        xc --version 2>/dev/null | tr -d ' ' | awk -F':' '{print "v"$2}'
    )"
    remote="$(
        curl -fsS -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/joerdav/xc/releases | jq -r .[0].tag_name
    )"

    if ! command -v xc >/dev/null 2>&1 || [ ! "$local" = "$remote" ]; then
        install_the_latest "$(echo "$remote" | cut -c2-)"
        return
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

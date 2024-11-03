#!/bin/sh

# Update deno to the latest if it's outdated
main() {
    local="$(
        deno --version 2>/dev/null | head -n1 | awk -F' ' '{print "v"$2}'
    )"
    remote="$(
        curl -fsS -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/denoland/deno/releases | jq -r .[0].tag_name
    )"

    if [ ! "$local" = "$remote" ]; then
        (
            set -x
            deno upgrade
        )
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

#!/bin/sh

# Update deno to the latest if it's outdated
main() {
    local="$(
        volta --version 2>/dev/null | awk '{print "v"$0}'
    )"
    remote="$(
        curl -fsS -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/volta-cli/volta/releases | jq -r .[0].tag_name
    )"

    if [ ! "$local" = "$remote" ]; then
        (
            set -x
            curl https://get.volta.sh | bash -s -- --skip-setup
        )
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

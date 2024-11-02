#!/bin/sh

# Update Rust to the latest if it's outdated
main() {
    found_uptodate() {
        [ "$(rustup check | awk '/Update available/' | wc -l)" -gt 0 ]
    }

    if found_uptodate; then
        (
            set -x
            rustup update
        )
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

#!/bin/sh

# Update the outdated fomulas onto up-to-date them
main() {
    (
        set -x
        brew update
        brew upgrade
        brew cleanup
    )
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

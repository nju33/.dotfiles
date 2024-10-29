#!/bin/sh

# Print current machine's environment
#
# > print_env
# macOS 15.0.1
#
main() {
    p() { printf "%s %s" "$1" "$2"; }

    if echo "$OSTYPE" | grep -qE "^linux-gnu"; then
        # Ubuntu
        if [ -f /etc/os-release ]; then
            source /etc/os-release
            # shellcheck disable=SC2153
            p "$NAME" "$VERSION"
        fi
    elif echo "$OSTYPE" | grep -qE "^darwin"; then
        # macOS
        local name version
        name="$(sw_vers -productName)"
        version="$(sw_vers -productVersion)"

        p "$name" "$version"
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

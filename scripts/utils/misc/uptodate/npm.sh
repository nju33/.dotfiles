#!/bin/sh

# Update the outdated packages in global onto up-to-date them
main() {
    global_packages=$(npm ls -g | awk '/─/ {sub(/@[0-9].+$/,"", $2); print $2}')
    uptodate_npm=
    uptodate_packages=

    # list global package names like:
    #   before:
    #       ── @alice/bob@1.0.0
    #       ── charlie@2.0.0
    #   after:
    #       @alice/bob
    #       charlie
    for pkg in $global_packages; do
        current_version=$(npm list -g "$pkg" --depth=0 | grep "$pkg" | sed 's/.*@\([0-9].*\)$/\1/')
        latest_version=$(npm view "$pkg" version)

        if [ ! "$current_version" = "$latest_version" ]; then
            printf "%s %s -> %s\n" "$pkg" "$pkg@$current_version" "$pkg@$latest_version"
            if [ "$pkg" = npm ]; then
                uptodate_npm="$pkg@$latest_version"
            else
                uptodate_packages+=$'\n'"$pkg@$latest_version"
            fi
        fi
    done

    if [ -n "$uptodate_npm" ]; then
        (
            set -x
            npm install -g "$uptodate_npm"
        )
    fi

    if [ -n "$uptodate_packages" ]; then
        inline_list=$(echo "$uptodate_packages" | tail -n+2 | awk -v OFS=' ' '//')
        (
            set -x
            npm install -g "$inline_list"
            npm cache clean --force
            npm cache verify
        )
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

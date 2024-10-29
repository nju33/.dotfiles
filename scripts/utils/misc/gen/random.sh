#!/bin/sh

show_help() {
    cat <<'EOT'
Usage:
  1. random
  2. random 10
  3. random 10 a-z
EOT
}

main() {
    args=

    while [ $# -gt 0 ]; do
        case "$1" in
        -h | --help)
            show_help
            return
            ;;
        *)
            [ -n "$args" ] && args+=' '
            args+="$1"
            shift
            ;;
        esac
    done

    # shellcheck disable=SC2086
    [ -n "$args" ] && set -- $args

    cat </dev/urandom |
        base64 |
        tr -cd "${2-a-zA-Z0-9}" |
        tr -s "${2-a-zA-Z0-9}" |
        head -c "${1-16}"
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

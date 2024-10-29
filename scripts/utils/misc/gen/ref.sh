#!/bin/sh

show_help() {
    cat <<'EOT'
Get random ref imitating that of git.

Usage:
  1. ref
  2. ref foo
  3. echo foo --dgst -sha3-512
  4. echo foo | ref
EOT
}

random() { "${0%/*}"/random.sh; }

process() {
    echo "$1" | openssl dgst "$2" -hex | awk '{print $2}'
}

main() {
    dgst=-sha1
    args=

    while [ $# -gt 0 ]; do
        case "$1" in
        -h | --help)
            show_help
            return
            ;;
        -d | --dgst)
            dgst=$2
            shift 2
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

    if [ -p /dev/stdin/ ]; then
        data=

        while IFS= read -r line; do
            [ -n "$data" ] && data=$'\n'
            data+="$line"
        done
        process "$data" "$dgst"
    else
        process "${1-$(random)}" "$dgst"
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

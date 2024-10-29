#!/bin/sh

show_help() {
    local -r comm="devch"
    cat <<EOT
$comm

Run Chrome on development environments

    Options:
        -p <port>, --remote-debugging-port <port>
        -d <dirname> --user_data_dir <dirname>
            Specify the location of user data dir for sustainability
            If not given, the life of user data is only that time
EOT
}

open_chrome() {
    set -x
    /Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary \
        --remote-debugging-port="${1?remote_debugging_port}" \
        --user-data-dir="${2?user_data_dir}" \
        --no-first-run \
        --no-default-browser-check
    set +x
}

make_temp_dir() {
    mktemp -d /tmp/devch.XXXXXX
}

# Run Chrome on development environments
main() {
    local remote_debugging_port=9222 user_data_dir

    # shellcheck disable=SC2317
    cleanup() { rm -rf "${1?temp_dir}"; }

    while ( ($#)); do
        case "$1" in
        -h | --help)
            show_help
            return
            ;;
        -p | --remote-debugging-port)
            remote_debugging_port="$2"
            shift 2
            ;;
        -d | --user_data_dir)
            user_data_dir="$HOME"/.devch/"$2"
            mkdir -p "$user_data_dir"
            shift 2
            ;;
        -*) ;;
        *) ;;
        esac
    done

    if [ -z "$user_data_dir" ]; then
        user_data_dir=$(make_temp_dir)
        # shellcheck disable=SC2064
        trap "cleanup $user_data_dir" EXIT HUP INT TERM
    fi

    open_chrome "$remote_debugging_port" "$user_data_dir"
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

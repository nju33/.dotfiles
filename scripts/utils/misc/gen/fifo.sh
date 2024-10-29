#!/bin/sh

show_help() {
    comm=fifo
    cat <<EOT
$comm

Get a fifo path after creating it if not existing

EOT
}

ensure_existing_fifo_dir() {
    fifo_dir_path="${1?fifo_dir_path}"

    if [ ! -d "$fifo_dir_path" ]; then
        mkdir -p "$fifo_dir_path"
    fi
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
            args+="$1 "
            shift
            ;;
        esac
    done

    # shellcheck disable=SC2086
    set -- $args

    fifo_dir_path=/tmp/.dotfiles/fifos fifo_filename="$1"
    fifo_file_path=$(printf "%s/%s" "$fifo_dir_path" "$fifo_filename")

    ensure_existing_fifo_dir "$fifo_dir_path"
    if [ ! -p "$fifo_file_path" ]; then
        mkfifo "$fifo_file_path"
    fi

    printf "%s" "$fifo_file_path"
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

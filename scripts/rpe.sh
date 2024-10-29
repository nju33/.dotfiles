#!/bin/sh

show_help() {
    comm=rpe
    cat <<EOT
$comm

Edit the global ripgreprc file

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
            args+="$1 "
            shift
            ;;
        esac
    done

    # shellcheck disable=SC2086
    set -- $args

    local file_path="$HOME"/.ripgreprc

    if [ "$VISUAL" = code ]; then
        $VISUAL "$file_path" --wait
    else
        $VISUAL "$file_path"
    fi

    if [ -s "$file_path" ]; then
        export RIPGREP_CONFIG_PATH="$HOME"/.ripgreprc
        rg --debug
    elif [ -n "$RIPGREP_CONFIG_PATH" ]; then
        unset RIPGREP_CONFIG_PATH
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

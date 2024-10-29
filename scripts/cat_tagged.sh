#!/bin/sh

show_help() {
    comm=cat_tagged
    cat <<EOT
$comm

Extract paths in specific tagged of Ranger, then just do cat

Example:
  Given a tagged file by Ranger like:
    A:/path/to/foo
    A:/path/to/bar
    B:/path/to/baz
  When upon executing \`cat_tagged \$path A\`, the output is like:
    /path/to/foo
    /path/to/bar
  Then using it as you like.
EOT
}

read_file() {
    cat <"$1"
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

    local -r tagged_file_path="${1?Execution failed due to the primary required arguments (argv) was not provided}"
    local -r tag_string="${2?Execution failed due to the secondary required arguments (argv) was not provided}"

    if [[ ${#tag_string} -ne 1 ]]; then
        echo "Execution failed due to the secondary required arguments must be a single charactor." >&2
        exit 1
    fi

    read_file "$tagged_file_path" | awk -F: -v p="$tag_string" '$0 ~ "^"p {print $2}'
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

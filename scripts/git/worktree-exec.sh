#!/bin/sh

show_help() {
    cat <<EOT
git wte

Execute a command in an aimed worktree

Flags:
    --dir: A pattern for the dir field
    --hash: A pattern for the hash field
    --ref: A pattern for the ref field

Examples
    \`\`\`sh
    git wte --dir 'foo$' --ref 'featureA$' git pull

    \`\`\`

EOT
}

get_list() {
    git worktree list --porcelain
}

into_inline() {
    [ -p /dev/stdin ] || return 1

    data=
    while read -r line; do
        [ -n "$data" ] && data+=$'\n'
        data+=$line
    done

    echo "$data" | awk 'NF==0{if(s){print s;s=""}}NF>0{if(s){s=s";"};s=s$2}'
}

then_run() {
    [ -p /dev/stdin ] || return 1

    while read -r dir; do
        cd "$dir" && ${1?command}
    done
}

execute_in() {
    [ -p /dev/stdin ] || return 1

    dir=
    hash=
    ref=
    command=

    while [ $# -gt 0 ]; do
        case "$1" in
        -d | --dir)
            dir="$2"
            shift 2
            ;;
        -h | --hash)
            hash="$2"
            shift 2
            ;;
        -r | --ref)
            ref="$2"
            shift 2
            ;;
        *)
            [ -n "$command" ] && command+=' '
            command+="$1"
            shift
            ;;
        esac
    done

    data=
    while read -r line; do
        [ -n "$data" ] && data+=$'\n'
        data+=$line
    done

    target_dirs=$(
        echo "$data" |
            awk -v d="$dir" -v h="$hash" -v r="$ref" -v FS=';' '$1 ~ d && $2 ~ h && $3 ~ r {print $1}'
    )

    if [ "$(echo "$target_dirs" | wc -l)" -gt 0 ]; then
        echo "$target_dirs" | then_run "$command"
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
            [ -n "$args" ] && args+=' '
            args+="$1"
            shift
            ;;
        esac
    done

    get_list | into_inline | execute_in "$args"
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

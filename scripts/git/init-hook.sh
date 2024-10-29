#!/bin/sh

prompt_yn() {
    while true; do
        read -r -p"$1 (Y/n): " -n1 answer </dev/tty

        if [ -z "$answer" ]; then
            echo "y"
            printf "\033[1A\033[K%s: y"$'\n' "$1" >/dev/tty
            break
        elif echo "$answer" | grep -qE 'y|n'; then
            echo >/dev/tty
            echo "$answer"
            break
        else
            echo >/dev/tty
        fi
    done
}

prompt() {
    read -r -p'Enter a path to place git hooks (.githooks): ' dirname </dev/tty
    if [ -z "$dirname" ]; then
        printf "\033[1A\033[KEnter a path to place git hooks (.githooks): .githooks"$'\n' >/dev/tty
    fi

    a1=$(prompt_yn 'Need to set core.hookspath?')

    echo $'\t'I will create "${dirname:=.githooks}" >/dev/tty
    if [ "$a1" = y ]; then
        echo $'\t'I will set core.hookspath to "$dirname" >/dev/tty
    else
        echo $'\t'I will not set core.hookspath >/dev/tty
    fi
    a2=$(prompt_yn 'Is that all correct?')

    echo "$dirname"\;"$a1"\;"$a2"
}

create_dir_and_file() {
    filename="$1"/pre-commit
    (
        set -x
        mkdir -p "$1"
        echo "#!/bin/sh" >"$filename"
        chmod +x "$filename"
    )
}

set_config() {
    (
        set -x
        git config set --local --path core.hookspath "$1"
    )
}

process() {
    create_dir_and_file "$1"

    if [ "$2" = y ]; then
        set_config "$1"
    fi
}

main() {
    result=$(prompt | sed 's/\;/ /g')
    # shellcheck disable=SC2086
    set -- $result

    if [ "$3" = y ]; then
        process "$1" "$2"
    fi
}

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

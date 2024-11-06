#!/bin/sh

type _ensure_stdin_is_pipe >/dev/null 2>&1 || {
    echo 'fatal: need to load core.sh before using git.sh' 2>&1
    exit 1
}

red() {
    printf '%b\n' "\033[31m$1\033[0m"
}

green() {
    printf '%b\n' "\033[32m$1\033[0m"
}

yellow() {
    printf '%b\n' "\033[33m$1\033[0m"
}

blue() {
    printf '%b\n' "\033[34m$1\033[0m"
}

magenta() {
    printf '%b\n' "\033[35m$1\033[0m"
}

cyan() {
    printf '%b\n' "\033[36m$1\033[0m"
}

bg_red() {
    printf '%b\n' "\033[41m$1\033[0m"
}

bg_green() {
    printf '%b\n' "\033[42m$1\033[0m"
}

bg_yellow() {
    printf '%b\n' "\033[43m$1\033[0m"
}

bg_blue() {
    printf '%b\n' "\033[44m$1\033[0m"
}

bg_magenta() {
    printf '%b\n' "\033[45m$1\033[0m"
}

bg_cyan() {
    printf '%b\n' "\033[46m$1\033[0m"
}

bold() {
    printf '%b\n' "\033[1m$1\033[0m"
}

underline() {
    printf '%b\n' "\033[4m$1\033[0m"
}

# Decorate text by ANSI escape code
#
# Arguments:
#   $1 - either of method of the above
#   stdin - a text
#
# Examples:
#   ```sh
#   echo foo | ansi yellow | ansi bold
#   echo foo | ansi bg_red | ansi underline
#   cat <<EOT | ansi blue
#   Alice
#   Bob
#   Charlie
#   EOT
#   ```
ansi() {
    _ensure_stdin_is_pipe

    method=$1

    if [ -p /dev/stdin ]; then
        while IFS= read -r line; do
            if [ -z "$method" ]; then
                echo "$line"
            else
                eval "$method \"$line\""
            fi
        done
    fi
}

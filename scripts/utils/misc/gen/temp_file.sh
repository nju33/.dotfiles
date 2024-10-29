#!/bin/sh

make_temp() {
    mktemp "/tmp/$1.XXXXXX"
}

move() {
    mv "$@"
}

# Generate a temp file in /tmp
main() {
    temp_file="${1?fatal: the first argument is required}"

    stem="${temp_file%.*}"
    extension=
    if echo "$temp_file" | grep -q '\.'; then
        extension="${temp_file##*.}"
    fi

    temp_file=$(make_temp "$stem") || {
        echo "Failed to create temp file" >&2
        return 1
    }

    if [ -n "$extension" ]; then
        temp_file="$temp_file"."$extension"
        move "${temp_file%.*}" "$temp_file"
    fi

    printf "%s" "$temp_file"
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

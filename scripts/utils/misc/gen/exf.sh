#!/bin/sh

show_help() {
    comm=exf
    cat <<EOT
$comm

Just create a (ex)ecutable (f)ile

Examples:
- Create a .rs: \`misc gen exf add.rs\`; call it with \`./add.rs\`
- Create a .ts: \`misc gen exf add.ts\`; call it with \`./add.ts\`
    In the case that the extension is .ts, a file assumed to execute with Deno is created

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
    set -- $args

    [ "$#" -eq 0 ] && {
        echo "fatal: the first argument is required for specifying the filename" >&2
        exit 1
    }

    extension=
    if echo "$1" | grep -q '\.'; then
        extension="${1##*.}"
    fi

    touch "$1"
    chmod +x "$1"

    case "$extension" in
    rs)
        cat <<EOF >>"$1"
#!/usr/bin/env rust-script

fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    println!("2 + 2 = {}", add(2, 2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 2), 4);
    }
}

EOF
        ;;
    ts)
        cat <<EOF >>"$1"
#!/usr/bin/env -S deno run

function add(a: number, b: number): number {
    return a + b
}

function main() {
    console.log(\`2 + 2 = \${add(2, 2)}\`);
}

main()

EOF
        ;;
    esac
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

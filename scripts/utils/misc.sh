#!/bin/sh

. "${0%/*}/core.sh"

show_help() {
    comm=misc

    cat <<EOT
$comm:
    gen:
        exf: \`$comm gen exf\`
        fifo: \`$comm gen fifo\`
        random: \`$comm gen random\`
        ref: \`$comm gen ref\`
        temp_file: \`$comm gen temp_file\`
    print:
        env: \`$comm print env\`
    uptodate:
        brew: \`$comm uptodate brew\`
        deno: \`$comm uptodate deno\`
        esbuild: \`$comm uptodate esbuild\`
        npm: \`$comm uptodate npm\`
        pnpm: \`$comm uptodate pnpm\`
        rust: \`$comm uptodate rust\`
        volta: \`$comm uptodate volta\`
        xc: \`$comm uptodate xc\`
EOT
}

main() {
    case "$1" in
    -h | --help)
        show_help
        return
        ;;
    gen)
        shift
        gen "$@"
        ;;
    print)
        shift
        print "$@"
        ;;
    uptodate)
        shift
        uptodate "$@"
        ;;
    esac
}

gen() {
    case "$1" in
    exf)
        shift
        "${0%/*}"/misc/gen/exf.sh "$@"
        ;;
    fifo)
        shift
        "${0%/*}"/misc/gen/fifo.sh "$@"
        ;;
    random)
        shift
        "${0%/*}"/misc/gen/random.sh "$@"
        ;;
    ref)
        shift
        "${0%/*}"/misc/gen/ref.sh "$@"
        ;;
    temp_file)
        shift
        "${0%/*}"/misc/gen/temp_file.sh "$@"
        ;;
    esac
}

print() {
    case "$1" in
    env)
        shift
        "${0%/*}"/misc/print/env.sh "$@"
        ;;
    esac
}

uptodate() {
    case "$1" in
    brew)
        shift
        "${0%/*}"/misc/uptodate/brew.sh "$@"
        ;;
    deno)
        shift
        "${0%/*}"/misc/uptodate/deno.sh "$@"
        ;;
    esbuild)
        shift
        "${0%/*}"/misc/uptodate/esbuild.sh "$@"
        ;;
    npm)
        shift
        "${0%/*}"/misc/uptodate/npm.sh "$@"
        ;;
    pnpm)
        shift
        "${0%/*}"/misc/uptodate/pnpm.sh "$@"
        ;;
    rust)
        shift
        "${0%/*}"/misc/uptodate/rust.sh "$@"
        ;;
    volta)
        shift
        "${0%/*}"/misc/uptodate/volta.sh "$@"
        ;;
    xc)
        shift
        "${0%/*}"/misc/uptodate/xc.sh "$@"
        ;;
    esac
}

if echo "$0" | grep -qE '\.sh$'; then
    main "$@"
fi

#!/bin/sh

_ifs=\;

_platform=$(uname -s | tr '[:upper:]' '[:lower:]')
_is_platform_mac() { [ "$_platform" = darwin ]; }
_is_platform_linux() { [ "$_platform" = linux ]; }

_is_in_vscode() { [ "$TERM_PROGRAM" = vscode ]; }

_move_user_specific_bin_dir() { cd ~/.local/bin || return 1; }

_detect_arch() {
    arch="$(uname -m | tr '[:upper:]' '[:lower:]')"
    case "${arch}" in
    x86_64 | amd64) arch="x64" ;;
    armv*) arch="arm" ;;
    arm64 | aarch64) arch="arm64" ;;
    esac

    if [ "$arch" = x64 ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
        arch=i686
    elif [ "$arch" = arm64 ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
        arch=arm
    fi

    case "$arch" in
    x64*) ;;
    arm64*) ;;
    *) return 1 ;;
    esac
    printf '%s' "$arch"
}

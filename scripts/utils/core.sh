#!/bin/sh

_ifs=\;

_platform=$(uname -s | tr '[:upper:]' '[:lower:]')
_is_platform_mac() { [ "$_platform" = darwin ]; }
_is_platform_linux() { [ "$_platform" = linux ]; }

_is_in_vscode() { [ "$TERM_PROGRAM" = vscode ]; }

_move_user_specific_bin_dir() { cd ~/.local/bin || return 1; }

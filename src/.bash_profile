#!/usr/bin/env bash

# Language settings
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# macOS specific settings
if [ "$(uname)" = 'Darwin' ]; then
    # Suppress bash deprecation warning
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# Homebrew configuration
if [ -s "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]; then
    source "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

_init_bash_completion() {
    local -r dir_path="$HOME/.bash_completion.d"

    if [ ! -d "$dir_path" ]; then
        mkdir "$HOME/.bash_completion.d"
    fi

    # deno: deno completions bash >"$HOME/.bash_completion.d/deno.bash"
    # rustup: rustup completions bash >"$HOME/.bash_completion.d/rustup.bash"
    # cargo: rustup completions bash cargo >"$HOME/.bash_completion.d/cargo.bash"

    for file in ~/.bash_completion.d/*; do
        [ -f "$file" ] && source "$file"
    done
}
_init_bash_completion

export NAVI_PATH="$HOME/.local/share/navi/cheats"
[ -f "$HOME/.deno/env" ] && source "$HOME/.deno/env"

# In advance, an environment where `.dotfiles` cloned has been had
export DOTFILES_LOCATION_DIRECTORY="$HOME/.dotfiles"
# Place various config files appropriately
_setup_global_settings() {
    if [ -z "$DOTFILES_LOCATION_DIRECTORY" ]; then
        # shellcheck disable=SC2016
        echo 'fatal: please set `export DOTFILES_LOCATION_DIRECTORY=…` in `.bash_profile`' >&2
        return 1
    fi

    local -Ar mappings=(
        [".editorconfig"]="$HOME/.editorconfig"
        [".shellcheckrc"]="$HOME/.schellcheckrc"
        ["src/.bash_profile"]="$HOME/.bashrc_aliases"
        ["src/.bashrc"]="$HOME/.bashrc"
        ["src/.bash_aliases"]="$HOME/.bash_aliases"
        ["src/.bash_completion.d/_devch.bash"]="$HOME/.bash_completion.d/_devch.bash"
        ["src/.bash_completion.d/_homemade.bash"]="$HOME/.bash_completion.d/_homemade.bash"
        ["src/.bash_completion.d/_misc.bash"]="$HOME/.bash_completion.d/_misc.bash"
        ["src/.gitconfig"]="$HOME/.gitconfig"
        ["src/.gitattributes"]="$HOME/.gitattributes"
        ["src/.tmux.conf"]="$HOME/.tmux.conf"
        ["src/.ripgreprc"]="$HOME/.ripgreprc"
        ["src/.prettierrc"]="$HOME/.prettierrc"
        ["src/.nvmrc"]="$HOME/.nvmrc"
        ["src/.config/alacritty/alacritty.yml"]="$HOME/.config/alacritty/alacritty.yml"
        ["src/.config/starship.toml"]="$HOME/.config/starship.toml"
        ["src/.local/share/navi/cheats/bats.cheat"]="$HOME/.local/share/navi/cheats/bats.cheat"
        ["src/.local/share/navi/cheats/nvm.cheat"]="$HOME/.local/share/navi/cheats/nvm.cheat"
    )

    attach() {
        local -r \
            dest="${1?fatal: $1 is undefined}" \
            src="$DOTFILES_LOCATION_DIRECTORY/${2?fatal: $2 is undefined}"
        # set -x
        # : "$dest" "$src"
        if [ ! -L "$dest" ] || [ "$(realpath "$dest")" != "$src" ]; then
            ln -sf "$src" "$dest"
        fi
        # set +x
    }

    for src in "${!mappings[@]}"; do
        local dest="${mappings[$src]}" dest_dir_path

        dest_dir_path="$(dirname "$dest")"

        [ -d "$dest_dir_path" ] || mkdir -p "$dest_dir_path"
        attach "$dest" "$src"
    done
}
_setup_global_settings

_on_built_terminal() {
    # It seems like that vscode creates a new terminal by `bash --login`
    if [[ $TERM_PROGRAM = "vscode" ]]; then
        return
    fi

    if [ -s "$HOME/taskpapers/todo.taskpaper" ]; then
        cat <"$HOME/taskpapers/todo.taskpaper" | awk '!/@done$/'
    fi

    # shellcheck disable=SC2009
    if [ "$(ps aux | grep alacritty | grep -v grep | wc -l)" -gt 0 ]; then
        osascript -e '
tell application "System Events"
    tell process "Alacritty"
        set frontWindow to front window
        -- somehow measure by a manual method
        set position of frontWindow to {32, 32}
    end tell
end tell
        '
    fi
}
_on_built_terminal

# Load .bashrc if it exists
[ -s "$HOME/.bashrc" ] && source "$HOME/.bashrc"

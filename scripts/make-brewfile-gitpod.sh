#!/usr/bin/env bash

dir_path_myself=$(dirname "$(readlink -f "$0")")
mkfifo "${fifo_path:="$dir_path_myself/fifo"}"

cleanup() {
    rm -rf "$fifo_path"
}

trap 'cleanup' EXIT HUP INT TERM

cat <Brewfile | grep -Ev "$(cat <"$fifo_path")" >Brewfile-gitpod &
cat <<'EOF' >"$fifo_path"
duf
gawk
gnu-sed
gnupg
imagemagick
jpegoptim
monolith
pinentry
pngquant
rclone
tree
vim
EOF

wait

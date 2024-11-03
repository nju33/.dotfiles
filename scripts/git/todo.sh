#!/bin/sh

previous_is_todo() { [ "$(git log --pretty=format:\"\" -1 --stat | wc -l)" -eq 0 ]; }

if previous_is_todo; then
    git commit --amend --allow-empty "$@"
else
    git commit --allow-empty "$@"
fi

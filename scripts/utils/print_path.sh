#!/bin/sh

main() { echo "$PATH" | tr : "\n"; }

if echo "$0" | grep -qE '\.sh$'; then
    main
fi

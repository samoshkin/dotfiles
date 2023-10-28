#!/bin/sh

mkdir -p "$HOME/.config/z"

ln -sf -t "$SHELLRCDIR" "$DOTFILES/z/z.rc.sh"

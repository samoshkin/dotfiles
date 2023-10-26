#!/bin/sh

mkdir -p "$HOME/.config/karabiner"

# TODO: why not symlink
cp -f "$DOTFILES/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

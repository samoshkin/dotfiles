#!/usr/bin/env sh

mkdir -p "$HOME/.config/yabai"
ln -sf "$DOTFILES/yabai/yabairc" "$HOME/.config/yabai/yabairc"

# expose helper executable scripts that should be on PATH
ln -sf "$DOTFILES/yabai/bin/"* "$HOME/bin"

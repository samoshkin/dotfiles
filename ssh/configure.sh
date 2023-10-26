#!/bin/sh

mkdir -p "$HOME/.config/karabiner"

if [ ! -f "$HOME/.ssh/config" ]; then
  cp "$DOTFILES/ssh/config" "$HOME/.ssh/config"
fi

ln -sf -t "$SHELLRCDIR" "$DOTFILES/ssh/ssh.rc.sh"

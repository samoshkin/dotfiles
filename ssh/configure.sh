#!/bin/sh

mkdir -p "$HOME/.ssh"

if [ ! -f "$HOME/.ssh/config" ]; then
  cp "$DOTFILES/ssh/config" "$HOME/.ssh/config"
fi

ln -sf "$DOTFILES/ssh/ssh.rc.sh" "$SHELLRCDIR"

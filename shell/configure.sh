#!/bin/sh

ZDOTDIR="$HOME/.config/zsh"
SHELLENVDIR="$ZDOTDIR/.env"
SHELLRCDIR="$ZDOTDIR/.rc"

if [ ! -f /etc/zshenv ] || ! grep -q 'ZDOTDIR' /etc/zshenv; then
  sudo tee -a "/etc/zshenv" >/dev/null << EOF
export ZDOTDIR="$HOME/.config/zsh"
EOF
fi

mkdir -p "$SHELLENVDIR" "$SHELLRCDIR"
ln -sf "$DOTFILES/shell/zsh/.zshenv" "$DOTFILES/shell/zsh/.zshrc" "$ZDOTDIR"
ln -sf "$DOTFILES/shell/.inputrc" "$HOME"

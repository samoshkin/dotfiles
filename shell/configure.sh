#!/bin/sh

ZDOTDIR="$HOME/.config/zsh"
SHELLENVDIR="$ZDOTDIR/.env"
SHELLRCDIR="$ZDOTDIR/.rc"

cat >> "/etc/zshenv" << EOF
export ZDOTDIR="$HOME/.config/zsh"
EOF

mkdir -p "$SHELLENVDIR" "$SHELLRCDIR"
ln -sf -t "$ZDOTDIR" "$DOTFILES/shell/zsh/.zshenv" "$DOTFILES/shell/zsh/.zshrc"

ln -sf -t "$HOME" "$DOTFILES/.inputrc"

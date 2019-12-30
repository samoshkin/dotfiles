#!/bin/bash

# Download antigen.sh
mkdir -p "$DOTFILES/vendor"
curl -L git.io/antigen > antigen.zsh

# Symlink/copy configs to target directories
ln -sf "$DOTFILES/.gitconfig" "$HOME"
ln -sf "$DOTFILES/.gitignore_global" "$HOME/.gitignore"
ln -sf "$DOTFILES/.inputrc" "$HOME"
ln -sf "$DOTFILES/.zshenv" "$HOME"
ln -sf "$DOTFILES/.zshrc" "$HOME"
cp -f "$DOTFILES/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

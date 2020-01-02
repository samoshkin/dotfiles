#!/usr/bin/env bash

set -e
set -o pipefail

echo "Copy or symlink config files to proper directories"

# Download antigen.sh
mkdir -p "$DOTFILES/vendor"
curl -sSL git.io/antigen > vendor/antigen.zsh

# Symlink/copy configs to target directories
# Git configs
ln -sf "$DOTFILES/.gitconfig" "$HOME"
ln -sf "$DOTFILES/.gitignore_global" "$HOME/.gitignore"

# Shell and ZSH
ln -sf "$DOTFILES/.inputrc" "$HOME"
ln -sf "$DOTFILES/.zshenv" "$HOME"
ln -sf "$DOTFILES/.zshrc" "$HOME"

# Karabiner config
mkdir -p "$HOME/.config/karabiner"
cp -f "$DOTFILES/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# Midnight commander
mkdir -p ~/.config/mc
ln -sf -t ~/.config/mc "${DOTFILES}/mc/ini" "${DOTFILES}/mc/menu" "${DOTFILES}/mc/mc.keymapl"

echo "Done"
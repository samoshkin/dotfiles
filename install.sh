#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

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
ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME"

# Ranger/rifle config
ln -sf "$DOTFILES/rifle/rifle.conf" "$HOME/.config/ranger/rifle.conf"

# Karabiner config
mkdir -p "$HOME/.config/karabiner"
cp -f "$DOTFILES/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# NNN plugins
ln -sf -t "$HOME/.config/nnn/plugins/" $DOTFILES/nnn/plugins/*

# Midnight commander
mkdir -p ~/.config/mc
ln -sf -t ~/.config/mc "${DOTFILES}/mc/ini" "${DOTFILES}/mc/menu" "${DOTFILES}/mc/mc.keymapl"

# Tmux
# NOTE: when opening Tmux for the first time, make sure to install all plugins manually (<prefix>+I)
ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
git clone https://github.com/tmux-plugins/tpm "$DOTFILES/vendor/tpm"

# NVM. Default globally installed packages
ln -sf "$DOTFILES/nvm/default-global-packages" "$NVM_DIR/default-packages"

# Create nvm home directory
mkdir -p "$HOME/.nvm"

echo "Done"

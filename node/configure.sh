#!/bin/sh

# Create nvm home directory
mkdir -p "$HOME/.nvm"

# NVM. Default globally installed packages
ln -sf "$DOTFILES/nvm/default-global-packages" "$HOME/.nvm/default-packages"

ln -sf -t "$SHELLRCDIR" "$DOTFILES/node/node.rc.sh"

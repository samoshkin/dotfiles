#!/bin/sh

# NVM. Default globally installed packages
ln -sf "$DOTFILES/node/default-global-packages" "$HOME/.nvm/default-packages"

ln -sf "$DOTFILES/node/node.rc.sh" "$SHELLRCDIR"

mkdir -p "$HOME/.config/npm"

npm config set loglevel=warn

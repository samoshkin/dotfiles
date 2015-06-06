#!/usr/bin/env bash

log "Installing atom"

brew cask install atom || true

log "Installing atom packages"

# install all packages
# echo ${SCRIPT_DIR}/packages.txt
apm install --packages-file "${DOTFILES}/atom/packages.txt"

log "Copy configuration to ~/.atom"
# symlink config files to ~/.atom
_ln -t ~/.atom ${DOTFILES}/atom/{init.coffee,keymap.cson,snippets.cson,styles.less,config.cson}

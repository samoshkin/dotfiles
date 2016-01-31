#!/usr/bin/env bash

log "Installing midnight commander"
brew install mc || true

log "Link configs to ~/.config/mc"


mkdir -p ~/.config/mc

# symlink config files to ~/.config/mc
_ln -t ~/.config/mc \
  "${DOTFILES}/mc/ini" \
  "${DOTFILES}/mc/mc.ext" \
  "${DOTFILES}/mc/menu"

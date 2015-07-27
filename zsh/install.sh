#!/usr/bin/env bash

brew install zsh || true

log "Link zshenv and zshrc file to home dir"

_ln "${DOTFILES}/zsh/zshenv" ~/.zshenv
_ln "${DOTFILES}/zsh/zshrc" ~/.zshrc

# TODO: automate it a bit
log --warn "Make sure to change your default shell to zsh"

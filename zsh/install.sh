#!/usr/bin/env bash

brew install zsh || true

# install antigen
if [ -e ~/.antigen ]; then
	log "Found possible installation of antigen. Move to ~/.antigen~"
	rm -rf ~/.antigen~
	mv -f ~/.antigen ~/.antigen~
fi

log "Installing antigen to ~/.antigen/antigen.zsh"
mkdir -p ~/.antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.antigen/antigen.zsh
log --warn "Antigen will prepare bundles next time your start zsh session"


log "Link zshenv and zshrc file to ~"

_ln "${DOTFILES}/zsh/zshenv" ~/.zshenv
_ln "${DOTFILES}/zsh/zshrc" ~/.zshrc

# TODO: automate it a bit
log --warn "Make sure to change your default shell to zsh"

#!/usr/bin/env bash

log "Installing git, tig, gibo"

brew install git gibo tig || true

log "Installing diffmerge and kdiff3"
brew cask install diffmerge kdiff3 || true

defaults write com.sourcegear.DiffMerge NSUserKeyEquivalents '{
  "Next Conflict"="$@\Uf701";
  "Previous Conflict"="$@\Uf700";
  "Next Change"="@\Uf701";
  "Previous Change"="@\Uf700";
}'

log "Congifure git with global ~/.gitconfig"
_cp "${DOTFILES}/git/.gitconfig" ~/.gitconfig

git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"
git config --global github.user "${GIT_GITHUB_USER}"

log "Prepare global ~/.gitignore"
_backup ~/.gitignore
gibo OSX > ~/.gitignore

log "Configure diffmerge to be external merge and diff tool"
# symlink external merge and diff tool scripts to "~/bin", so they are in PATH
_ln "${DOTFILES}/git/external_difftool_diffmerge.sh" ~/bin/external_difftool.sh
_ln "${DOTFILES}/git/external_mergetool_diffmerge.sh" ~/bin/external_mergetool.sh

log "Configure tig with ~/.tigrc"
# symlink .tigrc file
_ln -t ~ "${DOTFILES}/git/.tigrc"

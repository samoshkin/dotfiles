#!/usr/bin/env bash

log "Installing git, tig, gibo"
brew install git gibo tig || true

log "Installing diffmerge"
brew cask install diffmerge || true

log "Installing icdiff"
brew install icdiff

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

log "Configure tig with ~/.tigrc"
# symlink .tigrc file
_ln -t ~ "${DOTFILES}/git/.tigrc"

# Install Atlassian source tree
brew cask install sourcetree

defaults write com.torusknot.SourceTreeNotMAS SUScheduledCheckInterval -int 604800
defaults write com.torusknot.SourceTreeNotMAS SUEnableAutomaticChecks -bool true
defaults write com.torusknot.SourceTreeNotMAS gitRebaseTrackingBranches -bool true
defaults write com.torusknot.SourceTreeNotMAS gitGlobalIgnoreFile -string "$(realpath ~/.gitignore)"

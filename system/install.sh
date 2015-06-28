#!/usr/bin/env bash

log "Installing fonts"

brew tap caskroom/fonts
brew cask install \
  font-droid-sans-mono \
  font-dejavu-sans \
  font-inconsolata-dz \
  font-source-code-pro || true

log "Installing packages"
brew install shellcheck todo-txt || true

log "Installing applications"
brew cask install \
  diffmerge \
  google-chrome \
  dropbox \
  karabiner \
  seil \
  key-codes \
  macpass \
  skype \
  slack \
  utorrent \
  mattr-slate \
  vlc || true

# TODO: need to enable Slate in "System Preferences" -> "Security & Privacy" -> "Accessibility"
log "Configuring slate"
_ln -t ~ "${DOTFILES}/system/.slate.js"

# let Slate automatically check for updates
defaults write com.slate.Slate SUEnableAutomaticChecks -int 1

# this is to make Slate happy w/o spaces in path
ln -s "/Applications/Google Chrome.app" "/Applications/Google_Chrome.app"



log "Setup osx defaults"
source "${DOTFILES}/system/osx.sh"

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
	vlc || true

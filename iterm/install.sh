#!/usr/bin/env bash

log "Installing iterm2"
brew cask install iterm2 || true

# install fonts requires specified in iTerm settings
brew cask install font-source-code-pro || true

log "Import com.googlecode.iterm2.plist configuration"

defaults import com.googlecode.iterm2 "${DOTFILES}/iterm/com.googlecode.iterm2.plist"

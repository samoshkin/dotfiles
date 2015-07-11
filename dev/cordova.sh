#!/usr/bin/env bash

# depends on NodeJS environment
if ! is_app_installed node; then
  source "${DOTFILES}/dev/js.sh"
fi

log "Installing cordova@latest globally"
# Install latest version of cordova
npm install -g cordova@latest

# iOS dev environment

log "Setting up development environment for cordova and iOS apps"

# TODO: confirm that user has done with it
log "Make sure to install XCode from App Store first..."
if xcodebuild -version &> dev/null; then
  log --warn "XCode not installed"
fi

npm install -g ios-sim ios-deploy


log "Setting up development environment for cordova and Android apps"
# TODO: add later

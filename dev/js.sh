#!/usr/bin/env bash

log "Installing node"
brew install node || true

log "Configure npm to store packages and cache in ~/.npm, so you don't need sudo to 'npm install -g'"

mkdir -p ~/.npm

# avoid storing global npm modules in "/usr/local/bin", "usr/local/lib", because they require sudo
# keep global npm packages in HOME/.npm dir
npm config set cache ~/.npm/cache
npm config set prefix ~/.npm

log "Installing commonly used global packages: gulp, bower"
npm install -g gulp bower

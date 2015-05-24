#!/bin/sh

# TODO: later move/duplicate in bootstrap.sh
brew install node

mkdir -p ~/.npm

# avoid storing global npm modules in "/usr/local/bin", "usr/local/lib", because they require sudo
# keep global npm packages in HOME/.npm dir
npm config set cache ~/.npm/cache
npm config set prefix ~/.npm

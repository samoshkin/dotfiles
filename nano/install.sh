#!/usr/bin/env bash

log "Installing nano"
brew install nano || true

log "Copy configuration to ~/.nanorc"

_cp "${DOTFILES}/nano/.nanorc" ~
find "${DOTFILES}/vendor/nanorc" -name "*.nanorc" | sort | sed 's/^.*$/include "&"/' >> ~/.nanorc

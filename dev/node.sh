#!/usr/bin/env bash

if [ -s "$NVM_DIR/nvm.sh" ]; then
  _log "Updating nvm"

  pushd "$NVM_DIR" &>/dev/null
  git pull origin master
  git checkout "$(git describe --abbrev=0 --tags)"
  popd &>/dev/null
else
  _log "Installing nvm"

  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  pushd "$NVM_DIR" &>/dev/null
  git checkout "$(git describe --abbrev=0 --tags)"
  popd &>/dev/null
fi

# instantly source nvm script to have nvm on PATH
. "$NVM_DIR/nvm.sh"

if ! nvm version node $>/dev/null; then
  # if no node is installed
  _log "Install latest version of node"
  nvm install node;
elif [ "$(nvm version node)" != "$(nvm version-remote node)" ]; then
  # when there is a newer version of node available
  _log "Update your node to newer version"
  nvm install node --reinstall-packages-from=node
else
  _log "You already have latest node installed"
fi

# make latest node to be default one
nvm alias default node

log --warn "Make sure to relaunch your terminal to have nvm on PATH"

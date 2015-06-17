#!/usr/bin/env bash

log "Installing atom"

brew cask install atom || true

log "Installing shellcheck package"
brew install shellcheck

log "Installing atom packages"

# install all packages
# echo ${SCRIPT_DIR}/packages.txt
apm install --packages-file "${DOTFILES}/atom/packages.txt"

log "Copy configuration to ~/.atom"
# symlink config files to ~/.atom
_ln -t ~/.atom ${DOTFILES}/atom/{init.coffee,keymap.cson,snippets.cson,styles.less,config.cson}

# Fonts evaluation for Atom
#  \"SourceCodePro-Light\" [14-16] hard to focus, sharp but too thin
#  \"SourceCodePro\" [14]
#  \"Inconsolata-dz\" [14] stretched up
#  \"FreeMono\" [15]
#  \"DejaVu Sans Mono\"
#  \"Droid Sans Mono\" [14]
#  \"Input Mono,InputMono Light\"
#  \"Input Mono\" [13-14]
#  \"Input Mono,InputMono Light\" [13-14]
#  \"Input Mono,InputMono Thin\" too thin
#  \"Courier New\" [15]
#  \"Courier\"
#  \"Consolas \" [15]

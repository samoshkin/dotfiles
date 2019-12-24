#!/usr/bin/env bash

set -e

# TODO: deprecated, use _log() function from "functions/common.sh"
log() {
  local GREEN='\033[0;32m'
  local RED='\033[0;31m'
  local YELLOW='\033[0;33m'
  local CYAN='\033[0;36m'
  local RESET='\033[0m'

  local COLOR=$GREEN
  local TEXT=$1

  if [ "$1" == "--err" ]; then
    COLOR=$RED
    TEXT=$2
  fi

  if [ "$1" == "--warn" ]; then
    COLOR=$YELLOW
    TEXT=$2
  fi

  # TODO: switch to printf, for err redirect to stderr
  echo -e "${CYAN}dotfiles${RESET} ${CYAN}[$(date +"%T")]${RESET} ${COLOR}${TEXT}${RESET}"
}

_ln() {
  # always symbolic links and with backups
  ln --symbolic -b "$@"
}

_cp() {
  # always do backups
  cp -b "$@"
}

_backup() {
  if [ -f "$1" ]; then
    cp -f "$1" "$1~"
  fi
}

install_homebrew() {
  # Check for Homebrew
  if ! is_app_installed brew; then
    echo "Homebrew is not found. Installing one..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  export HOMEBREW_CASK_OPTS="--appdir=/Applications"

  # add different brew taps
  brew tap homebrew/dupes
  brew tap caskroom/fonts
}

install-submodule() {
  local submodule=$1
  if [ -f "${DOTFILES}/$submodule/install.sh" ]; then
    source "${DOTFILES}/$submodule/install.sh"
  else
    log --warn "Unknown module: $submodule"
  fi
}

main-menu() {
  local _atom="atom (Install atom and atom packages)"
  local _system="system (Setup osx and install system-wide packages)"
  local _zsh="zsh (Install zsh and change to be a default shell)"
  local _git="git (Install & configure git)"
  local _nano="nano (Install & configure nano)"
  local _mc="mc (Install & configure midnight commander)"
  local _dev="dev (Prepare development environments: JS, PhoneGap)"
  local _iterm="iterm (Install iterm2 as a replacement to default Terminal.app)"
  local _zim="zim (Install Zim Desktop Wiki to manage your notes)"
  local _update="update (Update various packages and software)"
  local _quit="quit (Do nothing and exit)"

  local allActions="$_git;$_system;$_iterm;$_zsh;$_nano;$_mc;$_atom;$_dev;$_zim;$_update;$_quit"
  local nextAction

  printf '\n'
  ask-question --question "What should I do next?" --choice "$allActions" nextAction
  case "$nextAction" in
    git*) install-submodule git ;;
    system*) install-submodule system ;;
    iterm*) install-submodule iterm ;;
    zsh*) install-submodule zsh ;;
    nano*) install-submodule nano ;;
    mc*) install-submodule mc ;;
    atom*) install-submodule atom ;;
    dev*) install-submodule dev ;;
    zim*) install-submodule zim ;;
    update*) update-all ;;
    quit*)
      return 1
      ;;
  esac
}

cd "$(dirname $0)"
export DOTFILES=$(pwd)

# include functions/common
source "${DOTFILES}/functions/common.sh"
source "${DOTFILES}/functions/system.sh"

# ensure some dirs
mkdir -p "${DOTFILES}/tmp"
mkdir -p "${HOME}/bin"

# if tmp exists, remove all contents
if [ -d "${DOTFILES}" ]; then
  _log "Clean up ${DOTFILES}/tmp directory"
  rm -rf ${DOTFILES}/tmp/*
fi

# install homebrew
install_homebrew

log "Installing GNU utils"
brew install coreutils || true
brew install findutils --with-default-names || true

brew install gnu-indent --with-default-names || true
brew install gnu-sed --with-default-names || true
brew install gnu-tar --with-default-names || true
brew install grep --with-default-names || true
brew install gnu-which --with-default-names || true
brew install gawk || true
brew install gzip || true
brew install screen || true
brew install watch || true
brew install wget || true

log "Installing git"
brew install git || true

# evaluate variables
# do this after installing homebrew, because we add brew coreutils dir to path
source "system/variables.sh"
source "system/private.variables.sh"

# open main menu
while true; do
  if ! main-menu; then
    break
  fi
done

log "Bye."

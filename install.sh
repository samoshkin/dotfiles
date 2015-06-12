#!/usr/bin/env bash


set -e

log () {
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

  echo -e "${CYAN}dotfiles${RESET} ${CYAN}[$(date +"%T")]${RESET} ${COLOR}${TEXT}${RESET}"
}

is_app_installed() {
	type "$1" &>/dev/null
}


confirm () {
  while true; do
    read -p "$1 [Yy/Nn] " yn
      case "$yn" in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) log "Please answer yes or no.";;
      esac
  done
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
  cp -f "$1" "$1~"
}

install_homebrew(){
	# Check for Homebrew
	if ! is_app_installed brew; then
	  echo "Homebrew is not found. Installing one..."
	  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# install brew cask
	log "Installing brew-cask"
	brew install caskroom/cask/brew-cask || true

	# update brew and brew cask
	log "Update brew itself and brew-cask. Clean up caches and old versions of formulas"
	# (brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup) || true
}

install(){
	source "./$1/install.sh"
}

actions () {
  # keep update the last one
  local known_actions="atom git mc nano node system zsh update"

  if [ "$1" == "--print" ]; then
    for action in $known_actions; do
      case "$action" in
        system ) echo -e "\t[$action] setup osx and install system-wide packages";;
        zsh ) echo -e "\t[$action] install zsh and change to be a default shell";;
        git ) echo -e "\t[$action] install & configure git";;
        nano ) echo -e "\t[$action] install & configure nano";;
        mc ) echo -e "\t[$action] install & configure midnight commander";;
        node ) echo -e "\t[$action] install nodejs and tools";;
        atom ) echo -e "\t[$action] install atom and atom packages";;
        update ) echo -e "\t[$action] update all brew formulas";;
      esac
    done

    echo -e "\t[all] all the above"
    return 0
  fi

  for action in "$@"; do
    echo

    if ! (echo "$known_actions" | tr ' ' '\n' | grep -E "^$action$" &> /dev/null); then
      echo "Unknown action: $action" >&2
      continue;
    fi

    case "$action" in
      all )
        actions $known_actions
      ;;
      update )
        log "Update brew. Update all packages. Clean up outdated packages from cache"
        brew update && brew upgrade && brew cleanup
        ;;
      * ) install $action;;
    esac
  done

  return 0
}

# change to repo root and save path in variable
cd "$(dirname $0)"
export DOTFILES=$(pwd)

install_homebrew

log "Installing coreutils and git"
brew install coreutils git || true
brew tap homebrew/dupes

# evaluate variables
source "system/variables.sh"
source "system/private.variables.sh"

# choose what to do next
while true; do
  echo
  log "What should I do next?"
  actions --print
  read -e answer

  if [ -z "$answer" ]; then
     break
  fi

  actions $answer
done

log "Bye."

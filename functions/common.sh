#!/usr/bin/env bash

_log() {
  local GREEN='\033[0;32m'
  local RED='\033[0;31m'
  local YELLOW='\033[0;33m'
  local CYAN='\033[0;36m'
  local RESET='\033[0m'

  local message
  local loglevel

  case $1 in
    --error ) loglevel="error"; message="$2";;
    --warn ) loglevel="warn"; message="$2";;
    --debug ) loglevel="debug"; message="$2";;
    * ) loglevel="info"; message="$1";;
  esac

  if [ "$loglevel" == "info" ]; then
    echo -e "${CYAN}dotfiles${RESET} ${CYAN}[$(date +"%T")]${RESET} ${GREEN}${message}${RESET}"
  fi

  if [ "$loglevel" == "warn" ]; then
    echo -e "${CYAN}dotfiles${RESET} ${CYAN}[$(date +"%T")]${RESET} ${YELLOW}${message}${RESET}"
  fi

  if [ "$loglevel" == "error" ]; then
    echo -e "${CYAN}dotfiles${RESET} ${CYAN}[$(date +"%T")]${RESET} ${RED}${message}${RESET}" 1>&2
  fi

  if [ "$loglevel" == "debug" ]; then
    echo -e "${message}"
  fi
}

get-app-path(){
  osascript -e "tell application \"Finder\" to POSIX path of (get application file id \"$1\" as alias)"
}

get-app-id(){
  osascript -e "id of app \"$1\""
}

is_app_installed() {
  type "$1" &>/dev/null
}

# NOTE: works only in bash because uses IFS, zsh does not regard it
ask-question(){
  local choice
  local defaultAnswer
  local question
  local prompt
  local answer
  local __resultVar="__answer"

  # split choices with ;
  local OIFS="$IFS"
  IFS=';'

  # parse arguments
  while [ "$1" != "" ]; do
    case $1 in
      --choice ) shift; choice=$1;;
      --default ) shift; defaultAnswer=$1;;
      --question ) shift; question=$1;;
      * ) __resultVar=$1
    esac
    shift
  done

  prompt="$question"

  # choice based question
  if [ -n "$choice" ]; then
    if [ -n "$defaultAnswer" ]; then
      prompt="$question [0=$defaultAnswer]: "
    fi
    _log "$prompt"

    select answer in $choice;
    do
      answer=${answer:-$defaultAnswer}

      # when answer is not blank we are done
      if [ ! -z "$answer" ]; then
        eval $__resultVar="'$answer'"
        break
      fi
    done

  # free form question
  else
    while true; do
      if [ -n "$defaultAnswer" ]; then
        prompt="$question [$defaultAnswer]: "
      fi

      _log "$prompt: "
      read answer
      answer=${answer:-$defaultAnswer}

      # when answer is blank and we do not have default value
      if [ -z "$answer" ]; then
        echo "Please provide an answer";
      else
        eval $__resultVar="'$answer'"
        break
      fi
    done
  fi

  # restore back $IFS variable
  IFS=$OIFS
}

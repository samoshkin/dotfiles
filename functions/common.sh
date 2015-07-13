#!/usr/bin/env bash

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

  prompt="$question: "

  # choice based question
  if [ -n "$choice" ]; then
    if [ -n "$defaultAnswer" ]; then
      prompt="$question [0=$defaultAnswer]: "
    fi
    printf "%s\n" "$prompt"

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

      printf "%s" "$prompt"
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

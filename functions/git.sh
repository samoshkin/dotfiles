#!/usr/bin/env bash

# change to repository root
cdgr(){
  [ ! -z $(git rev-parse --show-cdup) ] && cd $(git rev-parse --show-cdup || pwd)
}

gwdt(){
  git difftool
}

# git log tailored for "Time Report" format
gltr(){
  local format="%C(blue)%cd%C(reset)%x09%s"
  local since=$(date -I -d "yesterday")
  local author=$(git config user.name)

  # parse arguments
  while [ "$1" != "" ]; do
    case $1 in
      --format )
        echo "$format";
        return 0
        ;;
      --since ) shift; since=$1;;
    esac
    shift
  done

  git log --author="$author" --pretty=format:"$format" --date=short --since="$since"
}

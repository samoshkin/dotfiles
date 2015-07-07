#!/bin/sh

# paths
if brew --prefix coreutils > /dev/null; then
  COREUTILS_PATH="$(brew --prefix coreutils)/libexec/gnubin"
fi

export PATH="${HOME}/bin:${HOME}/.npm/bin:${COREUTILS_PATH}:/usr/local/bin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${HOME}/.npm/share/man:$MANPATH"
export NODE_PATH="${HOME}/.npm/lib/node_modules:$NODE_PATH"

export EDITOR=$(which nano)

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# location for homebrew cask packages
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

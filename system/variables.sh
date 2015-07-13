#!/bin/sh

# paths
export PATH="${HOME}/bin:${HOME}/.npm/bin:$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${HOME}/.npm/share/man:$MANPATH"
export NODE_PATH="${HOME}/.npm/lib/node_modules:$NODE_PATH"

export EDITOR=$(which nano)

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# location for homebrew cask packages
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# TODO: check if /usr/libexec/java_home is available on fresh Mac
# TODO: does it take to long or better to just set constant path
# TODO: check if we need this at all
export JAVA_HOME="$(/usr/libexec/java_home 2> /dev/null)"

export ANDROID_HOME=/usr/local/opt/android-sdk

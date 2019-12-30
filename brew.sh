#!/bin/bash

# command-line tools for Xcode
xcode-select --install

# Install GNU utils instead of MacOS equivalents
brew install coreutils
brew install findutils
brew install diffutils
brew install gnu-indent
brew install gnu-sed
brew install ed
brew install gnu-tar
brew install grep
brew install gnu-which
brew install gawk
brew install gzip
brew install watch
brew install gnutls
brew install wget
brew install curl
brew install make

# Upgrade old tools on Mac
brew install bash
brew install less
brew install nano

brew install fzf
# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install

brew isntall openssh
brew install rsync

# Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
# `python3`, `python3-config`, `pip3` etc., respectively, have been installed into
#  /usr/local/opt/python/libexec/bin
brew install python
brew install pyenv
pyenv install 3.7.5

# Platypus is a developer tool that creates native Mac applications from command line scripts 
# such as shell scripts or Python, Perl, Ruby, Tcl, JavaScript and PHP programs. 
# This is done by wrapping the script in a macOS application bundle along with an app binary that runs the script.
brew cask install platypus

brew install git gibo
brew install icdiff
brew cask install diffmerge
brew cask install sourcetree







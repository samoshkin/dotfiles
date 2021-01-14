#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# install the optional Command Line Tools subsection of the Xcode IDE
# command-line tools for Xcode
xcode-select --install


# ==================
# Zsh and Antigen
# ==================

brew install zsh
curl -L git.io/antigen > vendor/antigen.zsh


# =============================
# GNU utils instead of MacOS equivalents
# =============================

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


# =====================
#  Python
# =====================

# Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
# `python3`, `python3-config`, `pip3` etc., respectively, have been installed into
#  /usr/local/opt/python/libexec/bin
brew install python
brew install pyenv
pyenv install 3.7.5
pyenv global system

# GitHub - ranger/ranger: A VIM-inspired filemanager for the console https://github.com/ranger/ranger
pip3 install ranger-fm
ranger --copy-config=rifle

# =====================
# Git and friends
# =====================

brew install git gibo

# Diff tools
brew cask install diffmerge
brew cask install sourcetree

# A viewer for git and diff output
# https://github.com/dandavison/delta
brew install git-delta

# GitHub - bigH/git-fuzzy: interactive `git` with the help of `fzf` https://github.com/bigH/git-fuzzy
pushd "/usr/local/share"
git clone https://github.com/bigH/git-fuzzy
ln -sf "/usr/local/share/git-fuzzy/bin/git-fuzzy" "/usr/local/bin/git-fuzzy"
popd

# ======================
#  Fonts
# ======================

brew tap homebrew/cask-fonts                  

brew cask install font-droid-sans-mono
# With file icons support
brew cask install font-droid-sans-mono-nerd-font
brew cask install font-dejavu-sans      # font-dejavusansmono-nerd-font-mono
brew cask install font-source-code-pro
brew cask install font-inconsolata-dz-for-powerline  # font-inconsolata-nerd-font-mono


# ======================
# Node, NVM and npm libs
# ======================
# Installing nvm via homebrew is unsupported
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

# Install latest version of Node and make it default
nvm install --lts node
nmv alias default node

# sindresorhus/bundle-id-cli: Get bundle identifier from a bundle name (macOS): Safari → com.apple.Safari - https://github.com/sindresorhus/bundle-id-cli
# sindresorhus/app-path-cli: Get the path to an app (macOS) - https://github.com/sindresorhus/app-path-cli
npm install -g bundle-id-cli
npm install -g app-path-cli

#sindresorhus/fkill-cli: Fabulously kill processes. Cross-platform. - https://github.com/sindresorhus/fkill-cli
npm install -g fkill-cli

# 🔤 A list of all the public package names on npm. Updated daily. https://github.com/nice-registry/all-the-package-names#readme
npm install -g all-the-package-names


# =========================
#  Apps & utilities
# =========================

# GitHub - junegunn/fzf: A command-line fuzzy finder https://github.com/junegunn/fzf
brew install fzf
$(brew --prefix)/opt/fzf/install

# Modern "ls" replacement, incl. colors, tree-like view. https://the.exa.website/
brew install exa

# This allows project-specific environment variables without cluttering the ~/.profile file.
# GitHub - direnv/direnv: unclutter your .profile https://github.com/direnv/direnv
brew install direnv

brew install openssh
brew install rsync

# HTTPie – command-line HTTP client for the API era https://httpie.io/
brew install httpie

# Install ngrok
# Setup secure URL to your localhost server through any NAT or firewall. https://ngrok.com/
brew cask install ngrok

# kdabir/has: ✅checks presence of various command line tools and their versions on the path - https://github.com/kdabir/has
brew install kdabir/tap/has

# mptre/yank: Yank terminal output to clipboard - https://github.com/mptre/yank
brew install yank

# antonmedv/fx: Command-line tool and terminal JSON viewer 🔥 - https://github.com/antonmedv/fx
brew install fx

# jq https://stedolan.github.io/jq/
brew install jq

# yudai/gotty: Share your terminal as a web application - https://github.com/yudai/gotty
# GoTTY is a simple command line tool that turns your CLI tools into web applications.
brew install yudai/gotty/gotty

# http-server: a command-line http server https://github.com/http-party/http-server
brew install http-server

# GitHub - sharkdp/bat: A cat(1) clone with wings. https://github.com/sharkdp/bat
brew install bat

# htop - an interactive process viewer https://htop.dev/
brew install htop

# GitHub - dalance/procs: A modern replacement for ps written in Rust https://github.com/dalance/procs
brew install procs

# ShellCheck – shell script analysis tool https://www.shellcheck.net/
# find bugs in your shell scripts
brew install shellcheck

# NCurses Disk Usage https://dev.yorhel.nl/ncdu
brew install ncdu

# HTTrack Website Copier - Free Software Offline Browser (GNU GPL) https://www.httrack.com/
brew install httrack

# Nmap: the Network Mapper - Free Security Scanner https://nmap.org/
brew install nmap

# GitHub - sivel/speedtest-cli: Command line interface for testing internet bandwidth using speedtest.net https://github.com/sivel/speedtest-cli
brew install speedtest-cli

# Info-ZIP's UnZip http://infozip.sourceforge.net/UnZip.html
brew install unzip

# mellowcandle/bitwise: Terminal based bit manipulator in ncurses https://github.com/mellowcandle/bitwise
brew install bitwise

# GitHub - imsnif/bandwhich: Terminal bandwidth utilization tool https://github.com/imsnif/bandwhich
brew install bandwhich

# Ultimate Plumber is a tool for writing Linux pipes with instant live preview https://github.com/akavel/up
brew install up

# GitHub - rupa/z: z - jump around https://github.com/rupa/z
brew install z

# itchyny/bed: Binary editor written in Go https://github.com/itchyny/bed#readme
brew install itchyny/tap/bed

# MediaInfo https://mediaarea.net/en/MediaInfo
brew install media-info

# archivemount - mounts an archive for access as a file system
# archivemount(1) - Linux man page https://linux.die.net/man/1/archivemount
brew install archivemount

# atool home http://www.nongnu.org/atool/
# atool is a script for managing file archives of various types (tar, tar+gzip, zip etc).
brew install atool

# Compile nnn manually rather than downloading from brew
# TODO: v3.5 is broken on MacOS. Switch to 3.6 when released.
pushd "$HOME/tmp"
curl -sLO https://github.com/jarun/nnn/releases/download/v3.5/nnn-v3.5.tar.gz
tar -xvzf nnn-v3.5.tar.gz
pushd nnn-3.5

# Developer guides · jarun/nnn Wiki · GitHub https://github.com/jarun/nnn/wiki/Developer-guides
# Advanced use cases · jarun/nnn Wiki · GitHub https://github.com/jarun/nnn/wiki/Advanced-use-cases#file-icons
# Enable PCRE regexp engine instead of default POSIX
# Enable NERD font icons
sudo make O_PCRE=1 O_NERD=1 strip install
popd
rm -rf nnn-v3.5.tar.gz nnn-3.5/
popd

# Home · Universal Ctags https://ctags.io/
brew install --HEAD --with-jansson universal-ctags/universal-ctags/universal-ctags

# ===============================
#  GUI apps from 'brew cask'
# ================================

# Karabiner and key code viewers
brew cask install karabiner-elements
brew cask install key-codes

# Postman
brew cask install postman

# Docker
brew cask install virtualbox
brew cask install docker

# OSXFuse and NTFS-3g
brew cask install osxfuse
brew install ntfs-3g
brew cask install macfusion-ng
brew install sshfs

# newmarcel/KeepingYouAwake: Prevents your Mac from going to sleep. - https://github.com/newmarcel/KeepingYouAwake
# Alternative for caffeine/amphetamine
brew cask install keepingyouawake

# Calculator
brew cask install speedcrunch

# Video player
brew cask install vlc

# Platypus is a developer tool that creates native Mac applications from command line scripts 
# such as shell scripts or Python, Perl, Ruby, Tcl, JavaScript and PHP programs. 
# This is done by wrapping the script in a macOS application bundle along with an app binary that runs the script.
brew cask install platypus

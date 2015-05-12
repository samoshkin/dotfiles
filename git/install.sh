#!/bin/bash

# TODO: later backup if taret is already exist
cp --remove-destination ${DOTFILESDIR}/git/.gitconfig ~/.gitconfig

# TODO: consider email to be a  sensitive data, should come from config
git config --global user.email ${GIT_USER_EMAIL}

# create .gitignore file
# uses https://github.com/simonwhitaker/gibo to build from gitignore boilerplates gibo OSX JetBrains SublimeText > ~/.gitignore
gibo OSX JetBrains SublimeText > ~/.gitignore

# symlink external merge and diff tool scripts to "~/bin", so they are in PATH
ln --symbolic --force ${DOTFILESDIR}/git/external_difftool_diffmerge.sh ~/bin/external_difftool.sh
ln --symbolic --force ${DOTFILESDIR}/git/external_mergetool_diffmerge.sh ~/bin/external_mergetool.sh



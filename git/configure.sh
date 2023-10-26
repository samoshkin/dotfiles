#!/bin/sh

ln -sf "$DOTFILES/git/.gitconfig" "$HOME"
ln -sf "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore"
ln -sf -t "$SHELLRCDIR" "$DOTFILES/git/git.rc.sh"

#!/bin/sh

for file in "$DOTFILES"/launchd/LaunchAgents/*; do
  ln -sf "$file" "$HOME/Library/LaunchAgents"
done

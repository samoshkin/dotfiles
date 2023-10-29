#!/bin/sh

ln -sf "$DOTFILES/brew/brew.rc.sh" "$SHELLRCDIR"

# for newer versions of brew
# put brew env var file in dedicated location
if [ "$(brew --prefix)" = "/opt/homebrew" ]; then
  mkdir -p "$(brew --prefix)/etc/homebrew"
  ln -sf "$DOTFILES/brew/brew.env" "$(brew --prefix)/etc/homebrew/brew.env"
fi

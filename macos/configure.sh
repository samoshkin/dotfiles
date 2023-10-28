#!/bin/sh

ln -sf -t "$SHELLRCDIR" "$DOTFILES/macos/macos.rc.sh"

# system-wide key bindings mapping
ln -sf "$DOTFILES/macos/DefaultKeyBinding.Dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.Dict"

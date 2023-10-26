#!/bin/sh

TMUX_PLUGIN_MANAGER_PATH="$DOTFILES/tmux/tpm"

ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
# git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_MANAGER_PATH"

printf "export TMUX_PLUGIN_MANAGER_PATH=\"%s\"" \
  "$TMUX_PLUGIN_MANAGER_PATH" \
  > "$SHELLRCDIR"/tmux.rc.sh

# NOTE: when opening Tmux for the first time, make sure to install all plugins manually (<prefix>+I)

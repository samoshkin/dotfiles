#!/bin/sh

printf "export RIPGREP_CONFIG_PATH=\"%s\"" \
  "$DOTFILES/ripgrep/.ripgreprc" \
  > "$SHELLRCDIR"/ripgrep.rc.sh

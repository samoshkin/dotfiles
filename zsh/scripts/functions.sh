#!/usr/bin/env bash

# yank most recent command from a history
# To avoid "yc" itself being stored in a history, prepend it with a space when running from a shell: " yc"
function yc {
  fc -ln -1 | awk '{$1=$1}1' | pbcopy
}

# Alternative to https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/wd
# Borrowed from https://github.com/jarun/nnn/blob/master/plugins/bookmarks
# Bookmarks are just symlinks in a $BOOKMARKS_DIR directory
# Use fzf to select the bookmark and then cd into it
function bookmarks() {
  get_selected_bookmark() {
      for entry in "$1"/*; do

          # Skip unless directory symlink
          [ -h "$entry" ] || continue
          [ -d "$entry" ] || continue

          printf "%20s -> %s\n" "$(basename "$entry")" "$(readlink -f "$entry")"
      done | fzf --preview-window='hidden' --delimiter='->' --nth=1 |
      awk 'END {
          if (length($1) == 0) { print "'"$PWD"'" }
          else { print "'"$BOOKMARKS_DIR"'/"$1 }
      }'
  }

  bookmark=$(get_selected_bookmark "$BOOKMARKS_DIR")
  cd $(readlink -f "$bookmark")
}

# Search for TODO|FIXME|BUG markers in a directory and open results in a Vim quickfix window
function todos() {
  vim -q <(rg --vimgrep -w -e 'TODO' -e 'FIXME' -e 'BUG' $* .)
}

# Trim trailing and leading whitespaces from a given string
function trim() {
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"   
  printf '%s' "$var"
}

# function ewrap(){
#   if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
#     # Remove option --tab for new window
#     xfce4-terminal --tab -e "$EDITOR \"$*\""
#   else
#     # tmux session running
#     tmux split-window -h "$EDITOR \"$*\""
#   fi
# }

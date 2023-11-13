#!/usr/bin/env bash

iterm_window_id=$(yabai -m query --windows --space | jq '[.[] | select(.app == "iTerm2" and .title != "sticky")] | last | .id | select(.!=null)')

if [ -n "$iterm_window_id" ]; then
  yabai -m window --focus $iterm_window_id
else
  open -na "/Applications/iTerm.app"
fi

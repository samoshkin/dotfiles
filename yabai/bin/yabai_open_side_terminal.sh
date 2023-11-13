#!/usr/bin/env bash

iterm_sticky_window_id=$(yabai -m query --windows --space | jq 'map(select(.app == "iTerm2" and (.title | test("^sticky")))) | .[0] | select(. != null) | .id')

if [ -z "$iterm_sticky_window_id" ]; then
  window_id=$(osascript << EOD
tell application "iTerm"
  set newWindow to (create window with profile "sticky")
  tell newWindow to return id
end tell
EOD
  yabai -m window $window_id --toggle float --grid 2:2:0:0:2:1 --layer normal
  yabai -m window --focus $window_id
)
else
  is_minimized=$(yabai -m query --windows --window $iterm_sticky_window_id | jq '."is-minimized"')
  if [ "$is_minimized" = "true" ]; then
    yabai -m window --deminimize $iterm_sticky_window_id
    yabai -m window --focus $window_id
  else
    yabai -m window --minimize $iterm_sticky_window_id
  fi
fi


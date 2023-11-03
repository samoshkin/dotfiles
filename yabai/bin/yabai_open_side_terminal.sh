#!/usr/bin/env bash

iterm_sticky_window_id=$(yabai -m query --windows --space | jq 'map(select(.app == "iTerm2" and (.title | test("^sticky")))) | .[0] | select(. != null) | .id')

echo $iterm_sticky_window_id

if [ -z "$iterm_sticky_window_id" ]; then
  window_id=$(osascript << EOD
tell application "iTerm"
  set newWindow to (create window with profile "sticky")
  tell newWindow to return id
end tell
EOD
)
  echo $window_id
else
  is_minimized=$(yabai -m query --windows --window $iterm_sticky_window_id | jq '."is-minimized"')
  if [ "$is_minimized" = "true" ]; then
    yabai -m window --deminimize $iterm_sticky_window_id
  else
    yabai -m window --minimize $iterm_sticky_window_id
  fi
fi


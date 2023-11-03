#!/usr/bin/env bash

echo "win: $YABAI_WINDOW_ID"

if ! yabai -m query --windows --window $YABAI_WINDOW_ID | jq -er '."can-resize" or ."is-floating"'; then
  window="$(yabai -m query --windows --window $YABAI_WINDOW_ID)"
  display="$(yabai -m query --displays --window $YABAI_WINDOW_ID)"
  coords="$(jq \
    --argjson window "${window}" \
    --argjson display "${display}" \
    -nr '(($display.frame | .x + .w / 2) - ($window.frame.w / 2) | tostring)
      + ":"
      + (($display.frame | .y + .h / 2) - ($window.frame.h / 2) | tostring)')"

  yabai -m window $YABAI_WINDOW_ID --toggle float --move "abs:$coords"
fi

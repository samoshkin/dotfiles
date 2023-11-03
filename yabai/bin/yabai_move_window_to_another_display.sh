#!/usr/bin/env sh

cur_win=$(yabai -m query --windows --window | jq -r '.id')
# since I have only 2 monitors, this essentially toggles window between displays
target_display=$( (yabai -m query --displays --display next || yabai -m query --displays --display first) | jq -r '.index')

yabai -m window --display "$target_display"
yabai_with_mouse_following_focus.sh yabai -m window --focus "$cur_win";

#!/usr/bin/env sh


cur_win=$(yabai -m query --windows --window | jq -r '.id')
# since I have only 2 monitors, this essentially toggles window between displays
yabai -m window --display next || yabai -m window --display first

yabai_with_mouse_following_focus.sh yabai -m window --focus $cur_win;


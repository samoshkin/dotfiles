#!/usr/bin/env sh

# cycle spaces withing a current display
cur_space=$(yabai -m query --spaces --space | jq -r ".index")
next_space=$(yabai -m query --displays --display | jq -r ".spaces | .[(index($cur_space) + 1) % length]")

yabai -m space --focus $next_space

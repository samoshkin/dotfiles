#!/usr/bin/env bash

yabai -m query --windows \
  | jq '.[] | select(.["is-visible"]==true and .["has-focus"]==false) | .id' \
  | xargs -n 1 yabai -m window --close;

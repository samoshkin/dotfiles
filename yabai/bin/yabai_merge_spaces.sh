#!/usr/bin/env bash

target_space=$1
visible_windows="$(yabai -m query --windows | jq '.[] | select(.["is-visible"]==true) | .id')";
current_space="$(yabai -m query --spaces --space | jq '.index')"

if [ "$target_space" = "$current_space" ]; then
  echo "cannot merge space onto itself" >&2;
  exit 1;
fi

echo $visible_windows | xargs -I '{}' -n 1 yabai -m window '{}' --space $target_space;
yabai -m space --focus $target_space;
yabai -m space --destroy $current_space;


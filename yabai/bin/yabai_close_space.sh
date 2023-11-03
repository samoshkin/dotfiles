#!/usr/bin/env bash

current_space="$(yabai -m query --spaces --space | jq '.index')";
spaces_count=$(yabai -m query --spaces | jq 'length')

if [ $spaces_count -eq 1 ]; then
  echo "cannot close the last space" >&2;
  exit 1;
fi

yabai -m space --focus recent;
yabai -m space --destroy $current_space;

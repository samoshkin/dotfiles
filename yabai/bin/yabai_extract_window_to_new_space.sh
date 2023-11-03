#!/usr/bin/env bash

yabai -m space --create;
new_space_index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')";
yabai -m window --space "$new_space_index";
yabai -m space --focus "$new_space_index";

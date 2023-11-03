#!/usr/bin/env bash

yabai -m space --create;
space_index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')";
yabai -m space --focus $space_index;

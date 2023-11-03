#!/usr/bin/env bash

yabai -m config mouse_follows_focus on;
$@;
yabai -m config mouse_follows_focus off;

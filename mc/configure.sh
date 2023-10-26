#!/bin/sh

mkdir -p "$HOME/.config/mc"

ln -sf -t "$HOME/.config/mc" "${DOTFILES}/mc/ini" "${DOTFILES}/mc/menu" "${DOTFILES}/mc/mc.keymapl"

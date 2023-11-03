#!/usr/bin/env sh

# NOTE: make sure to launch Zim.app at least one time before running this script
# so it creates a directory structure at $XDG_ZIM_HOME

XDG_ZIM_HOME="$HOME/Library/Application Support/org.zim-wiki.Zim"
mkdir -p "$XDG_ZIM_HOME"

mkdir -p "$XDG_ZIM_HOME/zim"
ln -sf "$DOTFILES/zim/gtk-3.0" "$XDG_ZIM_HOME/gtk-3.0"
ln -sf "$DOTFILES/zim/style.conf" "$XDG_ZIM_HOME/zim/style.conf"

# themes are downloaded from
# McMojave - Gnome-look.org https://www.gnome-look.org/p/1275087
mkdir -p "$XDG_ZIM_HOME/share/themes"
tar xf "$DOTFILES/zim/gtk-themes/Mojave-Light.tar.xz" -C "$XDG_ZIM_HOME/share/themes"
tar xf "$DOTFILES/zim/gtk-themes/Mojave-Dark.tar.xz" -C "$XDG_ZIM_HOME/share/themes"

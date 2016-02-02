#!/usr/bin/env bash

zimVersion="0.65"

if [ -d "/Applications/Zim.app" ]; then
  _log --warn "Zim is already installed"
  return;
fi

# gtk-mac-integration enables Zim's menus to appear in OS X's menu bar instead of in the Zim window
_log "Install pygtk and gtk-mac-integration"
brew install pygtk gtk-mac-integration

# Platypus creates native Mac OS X applications from interpreted scripts such as shell scripts or Perl, Ruby and Python programs.
# Platypus | Sveinbjorn Thordarson - http://sveinbjorn.org/platypus
_log "Install platypus GUI and CLI"
brew install platypus
brew cask install platypus || true

# we use imagemagick to resize Zim icon to be able to convert it to "icns" format
_log "Install imagemagick"
brew install imagemagick

_log "Download zim-$zimVersion.tar.gz and extract it to $DOTFILES/tmp"
curl -s "http://zim-wiki.org/downloads/zim-$zimVersion.tar.gz" | tar -C "$DOTFILES/tmp" -xzf -

_log "Prepare icon for Zim application"
curl -s -o "$DOTFILES/tmp/zim-icon.png" http://zim-wiki.org/images/globe.png
convert "$DOTFILES/tmp/zim-icon.png" -resize 128x128 "$DOTFILES/tmp/zim-icon.png"
sips -s format icns "$DOTFILES/tmp/zim-icon.png" --out "$DOTFILES/tmp/zim-icon.icns" >/dev/null

_log "Create /Application/Zim.app bundle"

/usr/local/bin/platypus \
  --app-icon "$DOTFILES/tmp/zim-icon.icns" \
  --name 'Zim' \
  --output-type 'None' \
  --interpreter '/bin/bash' \
  --bundle-identifier org.alexeys.zim \
  --bundled-file "$DOTFILES/tmp/zim-$zimVersion" \
  - "/Applications/Zim.app" >/dev/null <<EOF
#!/bin/bash
/usr/local/bin/python ../Resources/zim-$zimVersion/zim.py
EOF

_log "Succesfully installed Zim to /Applications/Zim.app"

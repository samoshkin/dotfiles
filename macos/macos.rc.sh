# borrowed from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/macos/macos.plugin.zsh

# return the path of the frontmost Finder window
function pfd() {
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (insertion location as alias)
    end tell
EOF
}

# open the current directory in a Finder window
function ofd() {
  open "$PWD"
}

# change dir to the current Finder directory
function cdf() {
  cd "$(pfd)"
}

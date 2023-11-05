#!/bin/sh

ZDOTDIR="$HOME/.config/zsh"
SHELLENVDIR="$ZDOTDIR/.env"
SHELLRCDIR="$ZDOTDIR/.rc"

# specify custom location for zsh configuration files via ZDOTDIR variable
# should be defined in /etc/zshenv
if [ ! -f /etc/zshenv ] || ! grep -q 'ZDOTDIR' /etc/zshenv; then
  sudo tee -a "/etc/zshenv" >/dev/null << EOF
export ZDOTDIR="$HOME/.config/zsh"
EOF
fi

# /usr/libexec/path_helper builds $PATH from PATHS specified in /etc/paths
# however, it is flawed and PREPENDs paths defined in /etc/paths instead of appending them (while still appending paths defined in /etc/paths.d)
# Since OSX El Capitan it happens in /etc/zprofile
# and given the order of execution of zsh configuration files
# /etc/zshenv, ~/.zshenv, /etc/zprofile, ~/.zshrc
# any PATH modifications made in zshenv will be shifted to the end
# by "/usr/libexec/path_helper" running in /etc/zprofile
# the workaround is to move it back to /etc/zshenv
# so this it runs the first one (we're prepending to the file)
# NOTE: first, make sure to remove this logic from "/etc/zprofile".
# see https://stackoverflow.com/a/14101578
if ! grep -q '/usr/libexec/path_helper' /etc/zshenv; then
  echo "if [ -x /usr/libexec/path_helper ]; then
  eval \$(/usr/libexec/path_helper -s)
fi" | cat - /etc/zshenv | sudo tee "/etc/zshenv" >/dev/null
fi

mkdir -p "$SHELLENVDIR" "$SHELLRCDIR"
ln -sf "$DOTFILES/shell/zsh/.zshenv" "$DOTFILES/shell/zsh/.zshrc" "$ZDOTDIR"
ln -sf "$DOTFILES/shell/.inputrc" "$HOME"

# disable "Last Login" prompt when terminal starts new login shell
# macos - Remove "Last login" message for new tabs in terminal - Stack Overflow https://stackoverflow.com/questions/15769615/remove-last-login-message-for-new-tabs-in-terminal
touch "$HOME/.hushlogin"

# symlink executable scripts that should be on PATH to $HOME/bin
mkdir -p "$HOME/bin"
ln -sf "$DOTFILES/shell/bin/"* "$HOME/bin"

# symlink alias and functions to be sourced at shell startup
ln -sf "$DOTFILES/shell/alias.sh" "$SHELLRCDIR/shell-alias.rc.sh"
ln -sf "$DOTFILES/shell/functions.sh" "$SHELLRCDIR/shell-functions.rc.sh"

export DOTFILES="${HOME}/dotfiles"

export PAGER="less"
export EDITOR="vim"

# primarily used by 'nnn' file manager, it relies on $VISUAL to open files on <CR>
export VISUAL="editor_in_split_pane"

# build default path
# moved here from "/etc/zprofile"
# run it first, so our path modifications are not shifted to the end
# by PATHs set in "/etc/paths"
# NOTE: first, make sure to remove this logic from "/etc/zprofile".
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

export PATH="$PATH:$DOTFILES/shell/bin"
export PATH="$PATH:/usr/local/opt/mysql-client/bin"

# Locale
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# source all extra env files
export SHELLENVDIR="$ZDOTDIR/.env"
for envFile in "$SHELLENVDIR"/*(N); do
  source "$envFile"
done

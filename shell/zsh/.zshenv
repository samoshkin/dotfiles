export DOTFILES="${HOME}/dotfiles"

export PAGER="less"
export EDITOR="vim"

# primarily used by 'nnn' file manager, it relies on $VISUAL to open files on <CR>
export VISUAL="editor_in_split_pane"

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/usr/local/opt/mysql-client/bin"

# Locale
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# source all extra env files
export SHELLENVDIR="$ZDOTDIR/.env"
for envFile in "$SHELLENVDIR"/*(N); do
  source "$envFile"
done

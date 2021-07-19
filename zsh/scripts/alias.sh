#!/usr/bin/env bash

# Open files using "rifle"
# See https://github.com/ranger/ranger
alias o='rifle'

# Edit files using whatever $EDITOR
alias e="$EDITOR"
alias E="editor_in_split_pane"

# Default 'ls' overrides
alias ls='ls --time-style=long-iso --color=auto --dereference-command-line-symlink-to-dir'

# Long listing like "ls -la"
alias l='exa -1a --group-directories-first --color-scale'
alias ll='exa -la --group-directories-first --time-style long-iso --color-scale'

# Tree-like listing with 2-level depth
alias lt="exa -a --group-directories-first --color-scale -T -L 2"
alias llt="exa -la --group-directories-first --time-style long-iso --color-scale -T -L 2"

# To change directory on exiting MC
alias mc='. /usr/local/Cellar/midnight-commander/*/libexec/mc/mc-wrapper.sh'

# HTTPie
alias https='http --default-scheme=https'

function httpless {
    http --pretty=all --print=hb "$@" | less -R;
}

alias google-chrome="open -a 'Google Chrome'"

# alias fd='fd --hidden --follow --ignore-file "$DOTFILES/.ignore"'
alias fd="fd $FD_OPTIONS"

# Print files selected in nnn, one file per line
# $nsel variable points to .selection file that keeps list of NUL-terminated selected files
alias nsel="cat $NSEL | tr '\0' '\n'"

# Use "nnn" file manager as file picker
# Select files and feed them to another program
# e.g vim `npick`, ls -l `npick`
alias npick="n -p -"

# One-character alias for bookmarks. In spirit of "rupa/z".
alias b="bookmarks"

# Use bat in place of cat
alias cat="bat"

# Extract any archive with "x" alias using "atool"
alias x="atool -x"

# Open nnn for the current directory rather using nnn session
# Use "$ n" to open nnn session
# Use "$ nn" to open "nnn" to open current directory
alias nn="n ."

# To make "cd on quit" for 'nnn'
# "cd on quit" works only for <C-g>
function n () {
  # Block nesting of nnn in subshells
  if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
      . "$NNN_TMPFILE"
      rm -f "$NNN_TMPFILE" > /dev/null
    fi
  }


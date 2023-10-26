# context specific colors
# export NNN_COLORS="#4cd00403"
# Each context (aka tab) has different color: green, yellow, blue, purple
export NNN_COLORS="#02030405"

# export NNN_FCOLORS='c1e2272e006033f7c6d6abc4' # defaults
# directories are bright yellow
# executables are green (02, 76)
# symolik links are purple (05)
export NNN_FCOLORS='c1e20b02006005f7c6d6abc4'

# 'nnn' command line options
# -Q, disable confirmation on quit with multiple contexts active
# -r, show cp, mv progress
# -u, use selection if available, don't prompt to choose between selection and hovered entry
# -U, show user and group names in status bar
# -o, open files only on Enter key
# -x, copy path to system clipboard on select
# -E, use $EDITOR for internal undetached edits
# -e, open text files in $VISUAL (else $EDITOR, fallback vi) [preferably CLI]
# -S, persistent session
# -H, show hidden files
export NNN_OPTS="QruUoxESH"

# Use "rifle" (ranger's file opener) program to open files
export NNN_OPENER=rifle

# temp fifo file that keeps currently highlighted file, needed for previews
# BTW, $NNN variable in a subshell refers to currently highlighted file
export NNN_FIFO='/tmp/nnn.fifo'

# plugins key map
NNN_PLUG_1='/:finder;c:fzcd;C:fzcd_with_ignored;z:fzz;j:symlinkcd;.:gitroot;>:quick_cd'
NNN_PLUG_2='o:open;O:open_with;v:preview-tui;t:treeview;l:bat'
NNN_PLUG_3='!:openshell;d:!cp -r "$nnn" "$nnn".cp;'
export NNN_PLUG="$NNN_PLUG_1;$NNN_PLUG_2;$NNN_PLUG_3"

# List of supported archives in 'nnn'
# default: bzip2, (g)zip, tar. Other formats are supported through 'atool'
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"

# Special shortcut reference to the config file that contains selection
# Use this to refer selected files when entering shell(!) or command prompt (])
export NSEL=${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection

# Specify directory with symlinks per each bookmark
export BOOKMARKS_DIR="$HOME/.config/nnn/bookmarks"

# when running nested shell in 'nnn' use this extra indicator at shell prompt
# so it's easey to recognize we're inside "shell -> nnn -> shell"
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# Open nnn for the current directory rather using nnn session
# Use "$ n" to open nnn session
# Use "$ nn" to open "nnn" to open current directory
alias nn="n ."

# Print files selected in nnn, one file per line
# $NSEL variable points to .selection file that keeps list of NUL-terminated selected files
alias nsel="cat $NSEL | tr '\0' '\n'"

# Use "nnn" file manager as file picker
# Select files and feed them to another program
# e.g vim `npick`, ls -l `npick`
alias npick="n -p -"

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

# Alternative to https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/wd
# Borrowed from https://github.com/jarun/nnn/blob/master/plugins/bookmarks
# Bookmarks are just symlinks in a $BOOKMARKS_DIR directory
# Use fzf to select the bookmark and then cd into it
function bookmarks() {
  get_selected_bookmark() {
      for entry in "$1"/*; do

          # Skip unless directory symlink
          [ -h "$entry" ] || continue
          [ -d "$entry" ] || continue

          printf "%20s -> %s\n" "$(basename "$entry")" "$(readlink -f "$entry")"
      done | fzf --preview-window='hidden' --delimiter='->' --nth=1 |
      awk 'END {
          if (length($1) == 0) { print "'"$PWD"'" }
          else { print "'"$BOOKMARKS_DIR"'/"$1 }
      }'
  }

  bookmark=$(get_selected_bookmark "$BOOKMARKS_DIR")
  cd $(readlink -f "$bookmark")
}

# One-character alias for bookmarks. In spirit of "rupa/z".
alias b="bookmarks"

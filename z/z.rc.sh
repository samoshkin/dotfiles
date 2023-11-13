# controls the datafile location
export _Z_DATA="$HOME/.config/z/.z"

# Load 'rupa/z' - https://github.com/rupa/z
# "z" tracks you most used directories based on frequency and lets you jump around
# this is the location where brew installed "z"
source "$HOMEBREW_PREFIX/etc/profile.d/z.sh"


# Use "z" as usual when passed with arguments,
# but display an fzf prompt with a list of directories when used without arguments
unalias z 2> /dev/null
z() {
  if [ $# -gt 0 ]; then
    _z "$*";
    return;
  fi

  selected_dir=$(_z -l 2>&1 | fzf \
    --height 40% \
    --reverse \
    --tac \
    --no-sort \
    --inline-info \
    --preview-window 'hidden' \
    --nth 2 | awk '{ print $2 }')

  if [ -n "$selected_dir" ]; then
    cd "$selected_dir" || exit;
  fi
}

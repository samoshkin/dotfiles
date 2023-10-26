# yank most recent command from a history
# To avoid "yc" itself being stored in a history, prepend it with a space when running from a shell: " yc"
function yc {
  fc -ln -1 | awk '{$1=$1}1' | pbcopy
}

# Search for TODO|FIXME|BUG markers in a directory and open results in a Vim quickfix window
function todos() {
  vim -q <(rg --vimgrep -w -e 'TODO' -e 'FIXME' -e 'BUG' $* .)
}

# Trim trailing and leading whitespaces from a given string
function trim() {
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  printf '%s' "$var"
}

# calculate size of any input from STDIN
function filesize() {
  if [ "$1" == "-h" ]; then
    wc -c | awk '{ printf("%.0fK", $1/1024)}'
  else
    wc -c
  fi
}

# prints macOS system report info
function system_info(){
  system_profiler -json -detailLevel mini SPHardwareDataType SPDisplaysDataType SPMemoryDataType SPNetworkDataType SPPowerDataType SPSoftwareDataType SPStartupItemDataType SPStorageDataType > system_report.json
}

# Pass selected files as arguments to the given command
# Usage: f echo
# Usage: f vim
f() {
  IFS=$'\n'
  files=($(fd . --type f --type l "${@:2}" | fzf -0 -1 -m))
  IFS=$' '
  [[ -n "$files" ]] && $1 "${files[@]}"
}

# Pass selected directories as arguments to the given command
# Usage: d ws
d() {
  IFS=$'\n'
  dirs=($(fd . --type d "${@:2}" | fzf -0 -1 -m))
  IFS=$' '
  [[ -n "$dirs" ]] && $1 "${dirs[@]}"
}

# # Open the selected files with selected editor
# #   - CTRL-O to open with `open` command
# #   - CTRL-E to open with VSCode
# #   - CTRL-W to open with WS
# #   - Enter (default) to open with $EDITOR
fe() {
  local out files key
  IFS=$'\n'
  out=("$(fzf-tmux --query="$1" --multi --exit-0 --expect=ctrl-o,ctrl-e,ctrl-w)")
  key=$(head -1 <<< "$out")
  files=($(tail -n +2 <<< "$out"))
  if [ -n "$files" ]; then
    if [ "$key" = ctrl-o ]; then open "${files[@]}";
    elif [ "$key" = ctrl-w ]; then ws "${files[@]}";
    elif [ "$key" = ctrl-e ]; then code "${files[@]}";
    else ${EDITOR} "${files[@]}";
    fi
  fi
}

# fcd - cd to selected directory
# Similar to default ALT+C fzf key binding
fcd() {
  local dir
  dir=$(fd --type d --follow . ${1:-.} | fzf +m) && cd "$dir"
}

# cd to selected parent dir
cdp(){
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(dirname "$(realpath "$PWD")") | fzf-tmux)
  cd "$DIR"
}

# # Integration with z
# # like normal z when used with arguments, but displays an fzf prompt when used without.
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# Search with ripgrep
# Usage frg <query>
frg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi

  local rg_command="rg --column --line-number --no-heading --color=always --smart-case $*"
  selection=$(($rg_command || true) | fzf +m --ansi \
    --preview-window="right:wrap" --preview "$HOME/.vim/plugged/fzf.vim/bin/preview.sh {}")

  if [[ -n "$selection" ]]; then
    local file=$(echo $selection | awk -F: '{ print $1 }')
    local line=$(echo $selection | awk -F: '{ print $2 }')
    local column=$(echo $selection | awk -F: '{ print $3 }')
    vim "+call cursor($line, $column)" "$file"
  fi
}

# Search with ripgrep with live query reload
# Query can be changed on a fly and will spawn rg command once again instantly
# fzf disables its fuzzy find features, and acts as a dumb selector
# Usage: frgi <query>
rgi() {
  local rg_command="rg --column --line-number --no-heading --color=always --smart-case "
  local query="$1"
  selection=$(($rg_command '$query' || true ) | \
    fzf +m --bind "change:reload:$rg_command {q} || true" --ansi --disabled --query "$query" \
      --preview-window="right:wrap" --preview "$HOME/.vim/plugged/fzf.vim/bin/preview.sh {}")

  if [[ -n "$selection" ]]; then
    local file=$(echo $selection | awk -F: '{ print $1 }')
    local line=$(echo $selection | awk -F: '{ print $2 }')
    local column=$(echo $selection | awk -F: '{ print $3 }')
    vim "+call cursor($line, $column)" "$file"
  fi
}

# Search with ripgrep
# Show only matching files instead of individual matches
# Preview shows individual matches
# Usage: frgl <query>
rgl() {
  local file
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  file=$(rg --files-with-matches --no-messages "$1" | fzf +m --preview-window="right:wrap" --preview "bat --style=numbers --color=always {} 2> /dev/null | rg --color always --colors 'match:bg:yellow' --context 10 '$1' || rg --color always --context 10 '$1' {}")
  if [[ -n "$file" ]]; then
    $EDITOR "$file"
  fi
}


# Open rg search results in a Vim quickfix list
rgq() {
  vim -q <(rg --vimgrep $*)
}

# Search with ripgrep and open results in fzf
# Usage frg <query>
# FIXME: preview is broken
frg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi

  local rg_command="rg --column --line-number --no-heading --color=always --smart-case $*"
  selection=$(($rg_command || true) | fzf +m --ansi \
    --preview-window="right:wrap" --preview "$HOME/.vim/plugged/fzf.vim/bin/preview.sh {}")

  if [[ -n "$selection" ]]; then
    local file=$(echo $selection | awk -F: '{ print $1 }')
    local line=$(echo $selection | awk -F: '{ print $2 }')
    local column=$(echo $selection | awk -F: '{ print $3 }')
    vim "+call cursor($line, $column)" "$file"
  fi
}

# Search with ripgrep and live query reload enabled, open results in fzf
# Query can be changed on a fly and will spawn rg command once again instantly
# fzf disables its fuzzy find features, and acts as a dumb selector
# Usage: frgi <query>
frgi() {
  local rg_command="rg --column --line-number --no-heading --color=always --smart-case "
  local query="$1"
  selection=$(($rg_command '$query' || true ) | \
    fzf +m --bind "change:reload:$rg_command {q} || true" --ansi --disabled --query "$query" \
    --preview-window="right:wrap" --preview "$HOME/.vim/plugged/fzf.vim/bin/preview.sh {}")

  if [[ -n "$selection" ]]; then
    local file=$(echo $selection | awk -F: '{ print $1 }')
    local line=$(echo $selection | awk -F: '{ print $2 }')
    local column=$(echo $selection | awk -F: '{ print $3 }')
    vim "+call cursor($line, $column)" "$file"
  fi
}

# Search with ripgrep, open results in fzf
# Show only matching files instead of individual matches
# Preview shows individual matches
# Usage: frgl <query>
frgl() {
  local file
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  file=$(rg --files-with-matches --no-messages "$1" | fzf +m --preview-window="right:wrap" --preview "bat --style=numbers --color=always {} 2> /dev/null | rg --color always --colors 'match:bg:yellow' --context 10 '$1' || rg --color always --context 10 '$1' {}")
  if [[ -n "$file" ]]; then
    $EDITOR "$file"
  fi
}


# function ewrap(){
#   if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
#     # Remove option --tab for new window
#     xfce4-terminal --tab -e "$EDITOR \"$*\""
#   else
#     # tmux session running
#     tmux split-window -h "$EDITOR \"$*\""
#   fi
# }

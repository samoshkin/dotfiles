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
  system_profiler -json -detailLevel mini SPHardwareDataType SPDisplaysDataType SPMemoryDataType SPNetworkDataType SPPowerDataType SPSoftwareDataType SPStartupItemDataType SPStorageDataType
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

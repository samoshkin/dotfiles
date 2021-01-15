#!/usr/bin/env bash

# Git aliases and functions

# git index (add, reset)
alias giA='git add -A'
alias gia="git add"
alias gir="git reset"
alias gid="git diff --cached"

# git diff
alias gd="git diff --stat -p"
alias gds="git diff --stat"
alias gdt='git difftool'
alias ggdt='git difftool --gui'
alias gmt='git mergetool'

# git fuzzy diff, plus opening selected files in "git difftool"
function gfd(){
  IFS=$'\n'
  files=($(git fuzzy diff "$@"))

  if [ -n "$files" ]; then
    git difftool "$@" -- "${files[@]}"
  fi
}

# git fuzzy diff for a single commit, similar to git show <commit>
function gfdo() {
  gfd "$1~" "$1"
}

# git log
alias glo='git log --topo-order --pretty=format:"$_git_log_oneline_format"'
alias glg="glo --graph"
alias gla="glo --graph --all"

# Git file history
function gh() {
  if [ "$#" -eq 0 ]; then echo "Usage: gfh <file> <revision>"; return 1; fi
  if [[ ! -f "$1" ]]; then echo "Non existent file: $1"; return 1; fi

  local file="$1"
  local filename=$(basename -- "$file")
  local ext="${filename##*.}"
  local rev="$2"

  local source_command="git log --color=always --oneline $rev -- $file"
  local preview_command="git show {1}:$file | bat --color=always -l $ext"

  local selection=$($source_command | fzf +m --ansi --preview-window="right:70%:nohidden:wrap" --preview "$preview_command")

  if [[ -n "$selection" ]]; then
    local commit=$(echo $selection | awk '{ print $1 }')
    # use vim-fugitive Gedit command to open file at specific revision
    vim -c "Gedit $commit:$file"
  fi
}

# git fuzzy log, plus opening selected commit in Vim via :Gedit command
function gfl() {
  local commit=$(git fuzzy log "$@")

  if [ -n "$commit" ]; then
    vim -c ":Gedit $commit"
  fi
}

# git pull and push
alias gp="git push"
alias gpc='git push --set-upstream origin "$(git-branch-current 2> /dev/null)"'
alias gf="git fetch"
alias gfm="git pull --rebase=false"
alias gfr="git pull --rebase"

# git stash
alias gss="git stash save --include-untracked"
alias gs="git stash"
alias gsp="git stash pop"
alias gsa="git stash apply"

# Git stash list
function gsl() {
  local source_command="git stash list"
  local preview_command="echo {1} | awk -F: '{ print \$1 }' | xargs git --no-pager stash show"
  local selection=$($source_command | fzf +m --ansi --preview-window="right:70%:nohidden:nowrap" --preview "$preview_command")

  if [[ -n "$selection" ]]; then
    echo $selection | awk -F: '{ print $1 }' | xargs git stash apply
  fi
}

# Working tree
alias gws="git status --short"
alias gwc="git clean -id"
alias gfs="git fuzzy status"

alias gwU="git checkout HEAD --"
alias gwu="git restore"

alias grH="git reset --hard"

# Git status in Vim using vim-fugitive plugin
function gvs(){
  vim -c ":Git"
}

# git commit
alias gcm="git commit"
alias gca="git commit --amend"
alias gce="git commit --amend --reuse-message HEAD"

# git checkout

alias gfb="git fuzzy branch"

# Without arguments, shows all branch to choose from in fzf, with "git log" preview
# With arguments, acts as a bare "git checkout"
function gco() {
  if [ "$#" -gt 0 ]; then
    git checkout "$@"
  else
    local source_command="git branch -a"
    local preview_command="git log --graph --topo-order -n 50 --color=always --pretty=format:\"$_git_log_oneline_format\" {-1}"
    local selection=$($source_command | fzf +m --ansi --preview-window="right:70%:nohidden:nowrap" --preview "$preview_command")

    if [[ -n "$selection" ]]; then
      git checkout "$selection"
    fi
  fi
}

# git checkout where HEAD was 1 movement before (using 1st entry from reflog)
function gcop(){
  local head_prev_commit=$(git rev-parse HEAD@{1})
  local head_prev_name=$(git name-rev "$head_prev_commit" | awk '{print $2}')
  git checkout $head_prev_name
}

# Open git object in a Vim (using :Gedit command)
function ge() {
  vim -c "Gedit $*"
}

# Review PR: show list of affected files, complete diff, and open selected file in Vim
# NOTE: requires you to "git checkout <pr>" first
function git_review_pr(){
  echo "PR: $(git symbolic-ref --short HEAD)"
  echo "Upstream: $REVIEW_UPSTREAM"

  read -s -k '?Press any key to continue...'

  local files=$(git fuzzy diff $REVIEW_UPSTREAM..HEAD)

  if [ -n "$files" ]; then
    vim -c "let g:gitgutter_diff_base = '$REVIEW_UPSTREAM'" $files
  fi
}

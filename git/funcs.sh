# Git aliases are inspired by
# https://github.com/sorin-ionescu/prezto/blob/master/modules/git/alias.zsh

# ==================================================
# Preparing a commit
# ==================================================
alias giA='git add -A'
alias gia="git add"
alias gir="git restore --staged"

alias gwc="git clean -id"
alias gwu="git restore --worktree"

alias gcm="git commit"
alias gce="git commit --amend --reuse-message HEAD"
alias gcE="git commit --amend"

# ==================================================
# Status
# ==================================================
alias gws="git status --short"
alias gwsi="git fuzzy status"

# Git status in Vim using vim-fugitive plugin
function gwsvim(){
  vim -c ":Git"
}

# ==================================================
# Diff
# ==================================================
alias gdd="git diff --stat -p"            # diff with stat and patch (via git-delta viewer)
alias gds="git --no-pager diff --stat"    # diff with stat only
alias gdt='git difftool'                  # difftool in Vim
alias gdtui='git difftool --gui'          # DiffMerge or whatever GUI diff tool

# git fuzzy diff, plus opening selected files in "git difftool"
function gdi(){
  IFS=$'\n'
  files=($(git fuzzy diff "$@"))

  if [ -n "$files" ]; then
    git difftool "$@" -- "${files[@]}"
  fi
}

alias d2h="diff2html -i stdin --summary open --style side"

# ==================================================
# Merging
# ==================================================
alias gmm='git merge --no-ff'
alias gmt='git mergetool --no-ff'
alias gmb="git show-branch --merge-base" # show commit merge-base between multiple refs
alias gmc='git log --left-right --oneline --merge' # in case of conflicting merge, show which commits contribute to a conflict

# ==================================================
# Branching
# ==================================================

# list all branchs. Add "-a" to list both local and remote
alias gbl="git branch -v"
# find which branches contain given ref
alias gbhas="git branch --contains"
# show graph of branches, use --topics and --independent flags if needed
alias gbg="git show-branch --date-order --sha1-name"

# git checkout
alias gbc="git checkout"
# <git branch checkout interactive>

# Without arguments, shows all branch to choose from in fzf, with "git log" preview
# With arguments, acts as a bare "git checkout"
# <git branch checkout interactive x2>
function gbci() {
  if [ "$#" -gt 0 ]; then
    git checkout "$@"
  else
    local source_command="git branch -a"
    local preview_command="git log --graph --decorate --date-order -n 50 --color=always --pretty=format:\"$_git_log_oneline_format\" {-1}"
    local selection=$($source_command | fzf +m --ansi --preview-window="right:70%:nohidden:nowrap" --preview "$preview_command")

    if [[ -n "$selection" ]]; then
      git checkout "$(trim $selection)"
    fi
  fi
}

alias gbcii="git fuzzy branch"

# git checkout where HEAD was 1 movement before (using 1st entry from reflog)
# <git branch checkout back>
function gbback(){
  local head_prev_commit=$(git rev-parse HEAD@{1})
  local head_prev_name=$(git name-rev "$head_prev_commit" | awk '{print $2}')
  git checkout $head_prev_name
}


# ==================================================
# Explore single commit
# ==================================================

# Show single commit description by given revision
alias gcs="git --no-pager show -s --oneline"
alias gcS="git --no-pager show --stat"

# git fuzzy diff for a single commit, similar to git show <commit>
function gcsi() {
  local rev=${1:-HEAD}
  gdi "$rev~" "$rev"
}


# ==================================================
# Log & history
# ==================================================

# git log
# TODO: generate log with messages only
alias glo='git log --topo-order --pretty=format:"$_git_log_oneline_format"'
alias glg="glo --topo-order --boundary --graph"
alias gla="glo --topo-order --boundary --graph --all"

# show left-right markers of triple dot revision syntax
# $ gllr HEAD...MERGE_HEAD
alias gllr="git log --oneline --graph --left-right --boundary --decorate"

# git log interactive. Opens selected commit in Vim via :Gedit command
function gli() {
  local commit=$(git fuzzy log "$@")

  if [ -n "$commit" ]; then
    vim -c ":Gedit $commit"
  fi
}

# Git file history, shows only commits affecting given file. Open selected file from selected commit in Vim
function glf() {
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

# ==================================================
# Working with remotes
# ==================================================

alias gp="git push"
# TODO: fix this, git-branch-current does not work any more
alias gP='git push --set-upstream origin "$(git-branch-current 2> /dev/null)"'
alias gpl="git pull"

# ==================================================
# Stashing
# ==================================================
alias gss="git stash"
alias gsS="git stash save --include-untracked"
alias gsp="git stash pop"

# Git stash interactive list
# Apply selected stash
function gsi() {
  local source_command="git stash list"
  local preview_command="echo {1} | awk -F: '{ print \$1 }' | xargs git --no-pager stash show"
  local selection=$($source_command | fzf +m --ansi --preview-window="right:70%:nohidden:nowrap" --preview "$preview_command")

  if [[ -n "$selection" ]]; then
    echo $selection | awk -F: '{ print $1 }' | xargs git stash apply
  fi
}


# ==================================================
# Pull requests
# ==================================================

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

# ==================================================
# Misc
# ==================================================

# Open any git object in a Vim (using :Gedit command)
function gitvim() {
  vim -c "Gedit $*"
}

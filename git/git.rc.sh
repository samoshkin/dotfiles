export _git_log_oneline_format="%C(yellow)%h%C(reset) -%C(cyan)%d%C(reset) %s %C(magenta)(%cr)%C(reset) %C(243)<%an>%C(reset)"

# REVIEW_BASE points to upstream ref during code review
# use by commands in funcs.sh and when viewing diffs in a Vim
export REVIEW_UPSTREAM="develop"

# bigH/git-fuzzy: interactive `git` with the help of `fzf` https://github.com/bigH/git-fuzzy
export GF_LOG_MENU_PARAMS="--pretty=\"$_git_log_oneline_format\" --topo-order"
export GF_DIFF_COMMIT_PREVIEW_DEFAULTS="--patch-with-stat"
export GF_GREP_COLOR='38;5;234;48;5;214'
export GF_SNAPSHOT_DIRECTORY="$HOME/.git-fuzzy-snapshots"
export GF_HORIZONTAL_PREVIEW_PERCENT_CALCULATION="60"
# export GF_PREFERRED_PAGER="delta -s -w __WIDTH__"

source "$DOTFILES/git/funcs.sh"

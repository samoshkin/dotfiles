export _git_log_oneline_format="%C(yellow)%h%C(reset) -%C(cyan)%d%C(reset) %s %C(magenta)(%cr)%C(reset) %C(243)<%an>%C(reset)"

# REVIEW_BASE points to upstream ref during code review
# use by commands in funcs.sh and when viewing diffs in a Vim
export REVIEW_UPSTREAM="develop"

# bigH/git-fuzzy: interactive `git` with the help of `fzf` https://github.com/bigH/git-fuzzy
# export GF_LOG_MENU_PARAMS="--pretty=\"$_git_log_oneline_format\" --topo-order"
# export GF_DIFF_COMMIT_PREVIEW_DEFAULTS="--patch-with-stat"
# export GF_GREP_COLOR='38;5;234;48;5;214'

# # make the "git fuzzy diff" preview 60% wide
# export GF_HORIZONTAL_PREVIEW_PERCENT_CALCULATION='60'

# # NOTE: have to redefine all these mappings since it does not work out of the box
# # when shorcut is defined in uppercase, like "Alt-W"
# export GIT_FUZZY_BRANCH_WORKING_COPY_KEY="ctrl-p"
# export GIT_FUZZY_BRANCH_MERGE_BASE_KEY="alt-p"
# export GIT_FUZZY_BRANCH_COMMIT_LOG_KEY="alt-l"
# export GIT_FUZZY_BRANCH_CHECKOUT_FILE_KEY="alt-f"
# export GIT_FUZZY_BRANCH_CHECKOUT_KEY="alt-b"
# export GIT_FUZZY_BRANCH_DELETE_BRANCH_KEY="alt-d"

# export GIT_FUZZY_LOG_WORKING_COPY_KEY="ctrl-p"
# export GIT_FUZZY_MERGE_BASE_KEY="alt-p"
# export GIT_FUZZY_LOG_COMMIT_KEY="alt-d"

# export GIT_FUZZY_STATUS_ADD_KEY="alt-s"
# export GIT_FUZZY_STATUS_EDIT_KEY="alt-e"
# export GIT_FUZZY_STATUS_COMMIT_KEY="alt-c"
# export GIT_FUZZY_STATUS_RESET_KEY="alt-r"
# export GIT_FUZZY_STATUS_DISCARD_KEY="alt-u"


source "$DOTFILES/git/funcs.sh"

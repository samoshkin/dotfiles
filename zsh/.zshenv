export DOTFILES="${HOME}/dotfiles"

export PAGER="less"
export EDITOR="vim"

# primarily used by 'nnn' file manager, it relies on $VISUAL to open files on <CR>
export VISUAL="editor_in_split_pane"

# LESS configuration:
# - always show prompt with line number / total number of lines
# - interpret ANSI escape sequences (e.g. colored output)
# - read file to the end in order to enable the full metadata display in less status line
export LESS="-MR+Gg"

# PATH changes

# build default path
# moved here from "/etc/zprofile"
# run it first, so our path modifications are not shifted to the end
# by PATHs set in "/etc/paths"
# NOTE: first, make sure to remove this logic from "/etc/zprofile".
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

# launch ssh-agent is not running yet
# if [ -z "$SSH_AUTH_SOCK" ] ; then
#  echo "ssh-agent seems to be stopped, launch one"
#  eval $(ssh-agent -s)

  # OSX onl`y
  # store passphrase in keychain, so that key password is unlocked by local user password
  # do this once during system install
  # ssh-add -K $KEYFILES
  # fi

# Add GNU utils to PATH and MANPATH
declare -a gnu_utils=(
    "gnu-sed"
    "gnu-tar"
    "gnu-indent"
    "grep"
    "gnu_which"
    "findutils"
    "ed"
    "curl"
    "make"
)

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/unzip/bin:$PATH"

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH-/‌​usr/share/man}"
export MANPATH="/usr/local/opt/unzip/share/man:$MANPATH"

for util in "${gnu_utils[@]}"; do
    export PATH="/usr/local/opt/$util/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/$util/share/man:$MANPATH"
done

export PATH="$DOTFILES/bin:$PATH"


# enable LS colored output
export CLICOLOR=1
# export LSCOLORS=exfxcxdxbxegedabagacxx
# setup LS_COLORS using 'dircolors' helper utility
# Configuring LS_COLORS http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
eval $(dircolors -b "$DOTFILES/zsh/.dircolors")

# tell "exa" to use LS_COLORS via 'reset' command and specify exa specific extra coloring
GREY_COLOR="38;5;248"
GREY_COLOR_2="38;5;240"
export EXA_COLORS="reset:uu=${GREY_COLOR_2}:un=${GREY_COLOR_2}:gu=${GREY_COLOR_2}:gn=${GREY_COLOR_2}:ur=${GREY_COLOR}:uw=${GREY_COLOR}:ue=${GREY_COLOR}:ux=${GREY_COLOR}:gr=${GREY_COLOR}:gw=${GREY_COLOR}:gx=${GREY_COLOR}:tr=${GREY_COLOR}:tw=${GREY_COLOR}:tx=${GREY_COLOR}:da=38;5;102"

# use LS_COLORS colors in tab completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# configure zsh history behavior
export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE="${HOME}/.zsh_history"
export HISTCONTROL=ignorespace:ignoredups

# Use oh-my-zsh as a default lib
export ANTIGEN_DEFAULT_REPO_URL="https://github.com/robbyrussell/oh-my-zsh.git"

# Change default command line prompt symbol
# see https://github.com/sindresorhus/pure
export PURE_PROMPT_SYMBOL="$"

# Locale
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# location for homebrew cask packages
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# "ps" process list default output
export PS_FORMAT="pid,ppid,user,pri,ni,vsz,rss,pcpu,pmem,tty,stat,args"

# "sharkdp/fd" file finder, modern replacement for GNU find
export FD_OPTIONS="--hidden --follow --ignore-file $DOTFILES/.ignore"

# 'BurntSushi/ripgrep', modern replacement for grep
export RIPGREP_CONFIG_PATH="$DOTFILES/.ripgrep"

# Configure "sharkdp/bat", cat analogue with syntax highlighting
export BAT_PAGER="less -R"
export BAT_STYLE="changes,numbers"
export BAT_THEME="TwoDark"

# REVIEW_BASE points to upstream ref during code review
# use by commands in zsh/git.sh and when viewing diffs in a Vim
export REVIEW_UPSTREAM="develop"

# used by "oh-my-zsh/plugins/nvm"
export NVM_DIR="$HOME/.nvm"

export ANDROID_HOME="$HOME/android"

# Location of Tmux plugin manager
export TMUX_PLUGIN_MANAGER_PATH="$DOTFILES/vendor/tpm"

# 'junegunn/fzf', command line fuzzy finder
export FZF_DEFAULT_OPTS="--no-mouse --height 80% --reverse --multi --info=inline --preview='$HOME/.vim/plugged/fzf.vim/bin/preview.sh {}' --preview-window='right:60%:wrap' --bind='f2:toggle-preview,f3:execute(bat --style=numbers {} || less -f {}),f4:execute($EDITOR {}),alt-w:toggle-preview-wrap,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort,ctrl-l:clear-query'"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard 2>/dev/null || fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export MANPATH="/usr/local/share/fzf/man:$MANPATH"

# ==========================
# nnn configuration
# jarun/nnn: n³ The unorthodox terminal file manager. https://github.com/jarun/nnn
# ==========================

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
# -o,  open files only on Enter key
# -x, copy path to system clipboard on select
# -E, use $EDITOR for internal undetached edits
# -e, open text files in $VISUAL (else $EDITOR, fallback vi) [preferably CLI]
# -S, persistent session
export NNN_OPTS="QruUoxES"

# Use "rifle" (ranger's file opener) program to open files
export NNN_OPENER=rifle

# temp fifo file that keeps currently highlighted file, needed for previews
# BTW, $NNN variable in a subshell refers to currently highlighted file
export NNN_FIFO='/tmp/nnn.fifo'

# plugins key map
# export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
NNN_PLUG_1='/:finder;c:fzcd;C:fzcd_from_home_dir;z:fzz;h:hexview;b:bookmarks;n:bulknew;o:open;p:preview-tui;t:treeview;y:.cbcp;~:quick_cd'
NNN_PLUG_2='P:-_less -iR $nnn*;k:-_fkill'
export NNN_PLUG="$NNN_PLUG_1;$NNN_PLUG_2"

# List of supported archives in 'nnn'
# default: bzip2, (g)zip, tar. Other formats are supported through 'atool'
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"

# Special shortcut reference to the config file that contains selection
# Use this to refer selected files when entering shell(!) or command prompt (])
export NSEL=${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection

# Specify directory with symlinks per each bookmark
export BOOKMARKS_DIR="$HOME/.bookmarks"

# ==================================================
# Git configuration
# ==================================================
export _git_log_oneline_format="%C(yellow)%h%C(reset) -%C(cyan)%d%C(reset) %s %C(magenta)(%cr)%C(reset) %C(243)<%an>%C(reset)"

# for `git fuzzy log`
export GF_LOG_MENU_PARAMS="--pretty=\"$_git_log_oneline_format\" --topo-order"
export GF_DIFF_COMMIT_PREVIEW_DEFAULTS="--patch-with-stat"
export GF_GREP_COLOR='38;5;234;48;5;214'

# make the "git fuzzy diff" preview 60% wide
export GF_HORIZONTAL_PREVIEW_PERCENT_CALCULATION='60'

# 'git fuzzy'
# NOTE: have to redefine all these mappings since it does not work out of the box
# when shorcut is defined in uppercase, like "Alt-W"
export GIT_FUZZY_BRANCH_WORKING_COPY_KEY="ctrl-p"
export GIT_FUZZY_BRANCH_MERGE_BASE_KEY="alt-p"
export GIT_FUZZY_BRANCH_COMMIT_LOG_KEY="alt-l"
export GIT_FUZZY_BRANCH_CHECKOUT_FILE_KEY="alt-f"
export GIT_FUZZY_BRANCH_CHECKOUT_KEY="alt-b"
export GIT_FUZZY_BRANCH_DELETE_BRANCH_KEY="alt-d"

export GIT_FUZZY_LOG_WORKING_COPY_KEY="ctrl-p"
export GIT_FUZZY_MERGE_BASE_KEY="alt-p"
export GIT_FUZZY_LOG_COMMIT_KEY="alt-d"

export GIT_FUZZY_STATUS_ADD_KEY="alt-s"
export GIT_FUZZY_STATUS_EDIT_KEY="alt-e"
export GIT_FUZZY_STATUS_COMMIT_KEY="alt-c"
export GIT_FUZZY_STATUS_RESET_KEY="alt-r"
export GIT_FUZZY_STATUS_DISCARD_KEY="alt-u"


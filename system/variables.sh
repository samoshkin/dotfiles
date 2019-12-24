#!/bin/sh

# paths
export GOPATH="$HOME/.go"
export GOROOT="/usr/local/opt/go/libexec"

export PATH="$GOPATH/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"
export PATH="${HOME}/bin:$PATH"
export PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH="${HOME}/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="${HOME}/bin:$PATH"
export PATH="/usr/local/google-cloud-sdk/bin:$PATH"


export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH-/‌​usr/share/man}"
export MANPATH="/usr/local/opt/gnu-tar/share/man:$MANPATH"
export MANPATH="/usr/local/opt/gnu-sed/share/man:$MANPATH"
export MANPATH="/usr/local/opt/findutils/share/man:$MANPATH"
export MANPATH="/usr/local/opt/gnu-indent/share/man:$MANPATH"
export MANPATH="/usr/local/opt/grep/share/man:$MANPATH"
export MANPATH="/usr/local/opt/gnu-which/share/man:$MANPATH"
export MANPATH="/usr/local/opt/gawk/share/man:$MANPATH"
export MANPATH="/usr/local/opt/gzip/share/man:$MANPATH"
export MANPATH="/usr/local/opt/screen/share/man:$MANPATH"

export EDITOR=$(which nano)

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export HISTCONTROL=ignorespace

# location for homebrew cask packages
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# TODO: check if /usr/libexec/java_home is available on fresh Mac
# TODO: does it take to long or better to just set constant path
# TODO: check if we need this at all
export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"

export E=/usr/local/opt/android-sdk

export NVM_DIR="$HOME/.nvm"

export PS_FORMAT="pid,ppid,user,pri,ni,vsz,rss,pcpu,pmem,tty,stat,args"

FD_OPTIONS="--hidden --follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort'"
# Use git-ls-files inside git repo, otherwise fd
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

export BAT_PAGER="less -R"

# REVIEW_BASE points to base branch
# which is compared against when reviewing code
export REVIEW_BASE="master"

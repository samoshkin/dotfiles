# safe rm by default
alias rm="rm -i"

alias ls='ls --time-style=long-iso --color=auto'

# easier navigation
alias ..="cd .."

alias k='k -Ah'

# * in path to target any version
alias mc='. /usr/local/Cellar/midnight-commander/*/libexec/mc/mc-wrapper.sh'

alias le='less'

# was aliased to "fc -l 1", and make impossible to view only N most recent commands
unalias history

# additional git aliases

# colored man command output
# or use oh-my-zsh/colored-man
# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/colored-man
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;4;36m") \
    man "$@"
}

# TODO: move to .gitconfig
# remap or add new git aliases
alias giA='git add -A'

alias gwdt='git difftool'
alias gwdtg='git --gui difftool'
alias gidt='git difftool --cached'
alias gidtg='git difftool --gui --cached'
alias gdi='git ls-files -i --exclude-standard'

alias karabiner="/Applications/Karabiner.app/Contents/Library/bin/karabiner"
alias seil="/Applications/Seil.app/Contents/Library/bin/seil"
alias plistbuddy="/usr/libexec/PlistBuddy"

alias g='googler -x -n 6 -c ua -l en'

alias mux='tmuxinator'

alias https='http --default-scheme=https'

function httpless {
    http --pretty=all --print=hb "$@" | less -R;
}

alias fzf='SHELL=/bin/bash fzf'
alias vim='SHELL=/bin/bash vim'
# Pipe grep/find results into Vim as a quickfix list
# $ rg -n start | vimq
alias vimq='vim - -c "set nofoldenable | caddbuffer | cwindow | cfirst | bdelete! 1"'

# Convert list of files (find, fd) to format Vimgrep format to view as a quickfix list
2vimgrep() {
  awk '{ OFS=":"; file=$0; sub(/^[^\/]+\//, "", file); print $0,1,1,file }'
}

alias rg='rg --follow --hidden --smart-case --glob "!.git/*"'
alias fd='fd --hidden'

alias cat='bat'

# =================
# ANTIGEN
# =================

# Override styles for "git log --oneline"
# Do it before installing Antigen bundles
zstyle ':prezto:module:git:log:oneline' format '%C(green)%h%C(reset) %C(red)%d%C(reset) %s %C(cyan)<%an>%C(reset) %C(blue)(%cD)%C(reset)'

# Setup antigen
source "${DOTFILES}/vendor/antigen.zsh"
antigen init "${DOTFILES}/.antigenrc"

# ================
# ZSH
# ================

# fast man page access with <esc-h>
autoload run-help

# compatibility with bash
setopt shwordsplit
setopt nobeep

# so equals test works [ "$1" == "value" ]
# see http://www.zsh.org/mla/users/2011/msg00161.html
unsetopt equals

# Disable XON/XOFF flow control to free up <C-s> and <C-q> shortcuts in terminal
# Do this only for interactive shell
[[ $- == *i* ]] && stty -ixon

# Hook direnv
# direnv is an extension for your shell. 
# It augments existing shells with a new feature that can load and unload environment variables depending on the current directory.
eval "$(direnv hook zsh)"

# Define how zsh handles escape sequences produced by terminal emulator
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

source "$DOTFILES/fzf.sh"


# Load "pyenv" shell helper
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# =================
# ALIASES
# =================

alias ggl="google"

alias k='k -Ah'

alias ls='ls --time-style=long-iso --color=auto'

# Git aliases
alias giA='git add -A'

alias gwdt='git difftool'
alias gwdtg='git --gui difftool'
alias gidt='git difftool --cached'
alias gidtg='git difftool --gui --cached'
alias gdi='git ls-files -i --exclude-standard'

# Aliases to programs
alias plistbuddy="/usr/libexec/PlistBuddy"

# HTTPie
alias https='http --default-scheme=https'

function httpless {
    http --pretty=all --print=hb "$@" | less -R;
}

alias -g B='| bat'

alias chrome="open -a 'Google Chrome'"

alias fd='fd --hidden'


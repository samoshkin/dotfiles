# safe rm by default
alias rm="rm -i"

alias ls='ls --time-style=long-iso --color=auto'
alias l='ls -lAFh'

# easier navigation
alias ..="cd .."

alias k='k -Ah'

alias todo='todo.sh -A'

# * in path to target any version
alias mc='. /usr/local/Cellar/midnight-commander/*/libexec/mc/mc-wrapper.sh'

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

# remap or add new git aliases
alias giA='git add -A'

alias karabiner="/Applications/Karabiner.app/Contents/Library/bin/karabiner"
alias seil="/Applications/Seil.app/Contents/Library/bin/seil"
alias plistbuddy="/usr/libexec/PlistBuddy"

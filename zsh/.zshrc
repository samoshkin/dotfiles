# Disable bracketed-paste-magic, url-quote-magic and whatever-magic plugins
# NOTE: should be run before sourcing oh-my-zsh
# See: https://github.com/ohmyzsh/ohmyzsh/issues/5569
export DISABLE_MAGIC_FUNCTIONS="true"

# Setup antigen
# '.antigenrc' declares list of zsh plugins used
source "${DOTFILES}/vendor/antigen.zsh"
antigen init "${DOTFILES}/zsh/.antigenrc"

# fast man page access with <esc-h>
autoload run-help

# compatibility with bash
setopt shwordsplit
setopt nobeep

# Automatically cd when command is unknown or can't be executed but recognized as a valid directory
# Basically it means you can omit cd when doing "cd /some/dir"
setopt auto_cd

# so equals test works [ "$1" == "value" ]
# see http://www.zsh.org/mla/users/2011/msg00161.html
unsetopt equals

# Disable XON/XOFF flow control to free up <C-s> and <C-q> shortcuts in terminal
# By default <C-s> and <C-q> pause and resume the terminal output,
# but we might use them in a Vim or somewhere else, so let's unbind them
# NOTE: do this only for interactive shell
[[ $- == *i* ]] && stty -ixon

# Hook direnv - https://direnv.net/
# direnv is an extension for your shell, source local .envrc when entering directory
# Used to load project-specific environment variables
eval "$(direnv hook zsh)"

# Define how zsh handles escape sequences produced by terminal emulator
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# Hook up zsh-users/zsh-history-substring-search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Load "pyenv" shell helper
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# when running nested shell in 'nnn' use this extra indicator at shell prompt
# so it's easey to recognize we're inside "shell -> nnn -> shell"
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# Load 'rupa/z' - https://github.com/rupa/z
# "z" tracks you most used directories based on frequency and lets you jump around
source "/usr/local/etc/profile.d/z.sh"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# for fzf '**' shell completions.
# - The first argument to the function ($1) is the base path to start traversal
_fzf_compgen_path() {
  command fd --hidden --follow --exclude .git --exclude node_modules . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  command fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1"
}

# Enable fuzzy search key bindings and auto completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load user-defined aliases and functions
for script in $DOTFILES/zsh/scripts/*; do
  source $script
done

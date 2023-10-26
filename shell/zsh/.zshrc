# Disable bracketed-paste-magic, url-quote-magic and whatever-magic plugins
# NOTE: should be run before sourcing oh-my-zsh
# See: https://github.com/ohmyzsh/ohmyzsh/issues/5569
export DISABLE_MAGIC_FUNCTIONS="true"

# Change default command line prompt symbol
# see https://github.com/sindresorhus/pure
export PURE_PROMPT_SYMBOL=">"

# configure zsh history behavior
export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE="${HOME}/.zsh_history"
export HISTCONTROL=ignorespace:ignoredups

# increase "docker" client  and "docker-compose" client timeouts from 60s to 120s
export DOCKER_CLIENT_TIMEOUT=120
export COMPOSE_HTTP_TIMEOUT=120

export ANDROID_HOME="$HOME/android"

export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"

# Setup antigene
# Use oh-my-zsh as a default lib
export ANTIGEN_DEFAULT_REPO_URL="https://github.com/robbyrussell/oh-my-zsh.git"
export ADOTDIR="$HOME/.antigen"
# export ADOTDIR="$ZDOTDIR/.antigen"

# '.antigenrc' declares list of zsh plugins used
source "${DOTFILES}/shell/zsh/plugins/antigen.zsh"
antigen init "${DOTFILES}/shell/zsh/plugins/.antigenrc"

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

# TODO: report non-zero exit status in terminal somehow

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

# use LS_COLORS colors in tab completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Load "pyenv" shell helper
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Load 'rupa/z' - https://github.com/rupa/z
# "z" tracks you most used directories based on frequency and lets you jump around
source "/usr/local/etc/profile.d/z.sh"

# ZSH completions for kubectl
# TODO: install through antigen
source <(kubectl completion zsh)

# shell command completion for gcloud.
export PATH="$PATH:/usr/local/google-cloud-sdk/bin"
if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi

source "$DOTFILES/shell/functions.sh"
source "$DOTFILES/shell/alias.sh"

# source all extra rc files
export SHELLRCDIR="$ZDOTDIR/.rc"
for rcFile in "$SHELLRCDIR"/*(N); do
  source "$rcFile"
done

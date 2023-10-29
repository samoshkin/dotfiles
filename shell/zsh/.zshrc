# Disable bracketed-paste-magic, url-quote-magic and whatever-magic plugins
# NOTE: should be run before sourcing oh-my-zsh
# See: https://github.com/ohmyzsh/ohmyzsh/issues/5569
export DISABLE_MAGIC_FUNCTIONS="true"

# Change default command line prompt symbol
# see https://github.com/sindresorhus/pure
export PURE_PROMPT_SYMBOL=">"

# https://github.com/sindresorhus/pure
# the max execution time of a process before its run time is shown when it exits
export PURE_CMD_MAX_EXEC_TIME=0

# configure zsh history behavior
export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE="${ZDOTDIR}/.zsh_history"
export HISTCONTROL=ignorespace:ignoredups

# disable timeout for ESC keypress
export KEYTIMEOUT=1

# increase "docker" client  and "docker-compose" client timeouts from 60s to 120s
export DOCKER_CLIENT_TIMEOUT=120
export COMPOSE_HTTP_TIMEOUT=120

export ANDROID_HOME="$HOME/android"

export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"

# Setup antigen
export ADOTDIR="$ZDOTDIR/.antigen"

zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:*' recent-dirs z.sh

# load antigen (installed via brew) and init plugins
source "$(brew --prefix)/share/antigen/antigen.zsh"
antigen init "${DOTFILES}/shell/zsh/.antigenrc"

# fast man page access with <esc-h>
autoload run-help

# compatibility with bash
setopt shwordsplit
setopt nobeep

# set Zsh autocompletion menu behavior
setopt automenu
unsetopt menucomplete

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

# Define how zsh handles escape sequences produced by terminal emulator
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# Hook up zsh-users/zsh-history-substring-search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Enter completion menu with <Tab>, navigate around within a menu with <Tab>
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# close completion on ESC
bindkey -M menuselect '^[' undo

# use LS_COLORS colors in tab completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Load "pyenv" shell helper
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# ZSH completions for kubectl
# TODO: install through antigen
# source <(kubectl completion zsh)

# copy the active line from the command line buffer
# onto the system clipboard
# borrowed from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/copybuffer/copybuffer.plugin.zsh
copycmdline () {
  printf "%s" "$BUFFER" | pbcopy
}
zle -N copycmdline
bindkey "^O" copycmdline

# borrowed from https://github.com/Valiev/almostontop/blob/master/almostontop.plugin.zsh
# Valiev/almostontop uses "zle redisplay", but it resets the whole scrollback buffer
function _accept_line_almostontop {
  zle clear-screen
  zle .accept-line
}
zle -N accept-line _accept_line_almostontop

# shell command completion for gcloud.
export PATH="$PATH:/usr/local/google-cloud-sdk/bin"
if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi

# source all extra rc files
export SHELLRCDIR="$ZDOTDIR/.rc"
for rcFile in "$SHELLRCDIR"/*(N); do
  source "$rcFile"
done

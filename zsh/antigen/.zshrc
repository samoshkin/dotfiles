# shellcheck disable=SC1090

export DOTFILES="${HOME}/dotfiles"

# Disable bracketed-paste-magic, url-quote-magic and whatever-magic plugins
# NOTE: should be run before sourcing oh-my-zsh
# See: https://github.com/ohmyzsh/ohmyzsh/issues/5569
export DISABLE_MAGIC_FUNCTIONS="true"

# https://github.com/sindresorhus/pure
# the max execution time of a process before its run time is shown when it exits
export PURE_CMD_MAX_EXEC_TIME=0

# Change default command line prompt symbol
# see https://github.com/sindresorhus/pure
export PURE_PROMPT_SYMBOL=">"

# used by "oh-my-zsh/plugins/nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

export ADOTDIR="$HOME/.antigen2"

fpath+=("$(brew --prefix)/share/zsh/site-functions")

# setopt +o menucomplete

zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
# zstyle ':autocomplete:*' recent-dirs z.sh
# zstyle ':autocomplete:*' fzf-completion yes

source "$DOTFILES/zsh/antigen/antigen.zsh";
antigen init "${DOTFILES}/zsh/antigen/.antigenrc"

# https://github.com/zsh-users/zsh-history-substring-search
# bind UP and DOWN keyboard shortcuts to going through history matches
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# "^R" history-incremental-search-backward


# borrowed from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/macos/macos.plugin.zsh
# return the path of the frontmost Finder window
function pfd() {
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (insertion location as alias)
    end tell
EOF
}

# open the current directory in a Finder window
function ofd() {
  open "$PWD"
}

# change dir to the current Finder directory
function cdf() {
  cd "$(pfd)"
}

setopt automenu
unsetopt menucomplete

# A Guide to the Zsh Completion with Examples https://thevaluable.dev/zsh-completion-guide-examples/
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
# enable tab completion with arrow key selection
# zstyle ':completion:::::default' menu select
# zstyle ':completion:*' menu select


bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# .up-line-or-search () {
#   if [[ $LBUFFER == *$'\n'* ]]; then
#     builtin zle up-line
#   else
#     builtin zle history-incremental-search-backward -w
#   fi
# }
# builtin zle -N up-line-or-search .up-line-or-search

# enable LS colored output
# export CLICOLOR=1
# export LSCOLORS=exfxcxdxbxegedabagacxx
# setup LS_COLORS using 'dircolors' helper utility
# Configuring LS_COLORS http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
# eval $(dircolors -b "$DOTFILES/zsh/.dircolors")


# calling "nvm use" automatically in a directory with a .nvmrc file
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# copy the active line from the command line buffer
# onto the system clipboard
# borrowed from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/copybuffer/copybuffer.plugin.zsh
copycmdline () {
  printf "%s" "$BUFFER" | pbcopy
}
zle -N copycmdline
bindkey "^O" copycmdline


# close completion on ESC
bindkey -M menuselect '^[' undo
# disable timeout for ESC keypress
export KEYTIMEOUT=10

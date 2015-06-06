# enable colored output
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacxx
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34:cd=34:su=0;41:sg=0;46:tw=0;42:ow=33"

# use LS_COLORS colors in tab completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# configure zsh history behavior
export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE="${HOME}/.zsh_history"

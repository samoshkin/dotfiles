# "sharkdp/fd" file finder, modern replacement for GNU find
export FD_OPTIONS="--hidden --follow --ignore-file $DOTFILES/fd/.ignore"

# alias fd='fd --hidden --follow --ignore-file "$DOTFILES/.ignore"'
alias fd="fd $FD_OPTIONS"

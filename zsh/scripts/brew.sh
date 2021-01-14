#!/usr/bin/env bash

# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  local out packages key

  IFS='\n'
  out=("$(brew search | fzf -m --expect=ctrl-h)")
  key=$(head -1 <<< "$out")
  packages=($(tail -n +2 <<< "$out"))

  if [[ -n "$packages" ]]; then
    # Open package homepage when Ctrl-H is pressed
    if [ "$key" = ctrl-h ]; then
      for i in "${packages[@]}"
      do brew home "$i"; done
    # Otherwise install packages
  else
        for i in "${packages[@]}"
        do brew install "$i"; done
    fi
  fi
}

# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd);
    do; brew upgrade $prog; done;
  fi
}

# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
brp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst);
    do; brew uninstall $prog; done;
  fi
}

# List installed applications
# mnemonic [B]rew [L]ist [P]lugin (e.g. uninstall)
blp() {
  local out packages key

  IFS=$'\n'
  out=("$({ brew leaves; brew list --cask -1 } | fzf -m --expect=ctrl-h)")
  key=$(head -1 <<< "$out")
  packages=($(tail -n +2 <<< "$out"))

  if [[ -n "$packages" ]]; then
    # Open package homepage when Ctrl-H is pressed
    if [ "$key" = ctrl-h ]; then
      for i in "${packages[@]}"
      do brew home "$i"; done
    # Otherwise echo packages to STDOUT
  else
        for i in "${packages[@]}"
        do echo "$i"; done
    fi
  fi
}

# Install or open the webpage for the selected application
# using brew cask search as input source
# and display a info quickview window for the currently marked application
install_app() {
    local token
    token=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(I)nstall or open the (h)omepage of $token"
        read input
        if [ $input = "i" ] || [ $input = "I" ]; then
            brew cask install $token
        fi
        if [ $input = "h" ] || [ $input = "H" ]; then
            brew cask home $token
        fi
    fi
  }

# Uninstall or open the webpage for the selected application
# using brew list as input source (all brew cask installed applications)
# and display a info quickview window for the currently marked application
uninstall_app() {
    local token
    token=$(brew cask list | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(U)ninstall or open the (h)omepage of $token"
        read input
        if [ $input = "u" ] || [ $input = "U" ]; then
            brew cask uninstall $token
        fi
        if [ $input = "h" ] || [ $token = "h" ]; then
            brew cask home $token
        fi
    fi
  }

#!/usr/bin/env bash

installed-fonts() {
  local familyName=$1;
  fc-list : family |  grep -i "$familyName"  | uniq | sort
}

get-app-id(){
  osascript -e "id of app \"$1\""
}

save-config-atom-packages() {
  local apmPackagesPath="${DOTFILES}/atom/packages.txt";
  apm list --installed --bare | sed 's/@.*//' > "$apmPackagesPath"

  echo -e "Saved to $apmPackagesPath"
}

save-config-iterm() {
  local itermPlistPath="${DOTFILES}/iterm/com.googlecode.iterm2.plist"
  defaults export com.googlecode.iterm2 "$itermPlistPath"
  plutil -convert xml1 "$itermPlistPath"

  echo -e "Saved to $itermPlistPath"
}

# Create a new directory and enter it
unalias md
md() {
  mkdir -p "$@" && cd "$@"
}


# find shorthand
f() {
    find . -name "$1" 2>&1 | grep -v 'Permission denied'
}


# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Copy w/ progress
cp_p () {
  rsync -WavP --human-readable --progress "$1" "$2"
}

# get gzipped size
gzipped() {
  local original=$(wc -c < "$1")
  echo "original size (bytes): $original";

  local gzipped=$(gzip -c "$1" | wc -c)
  echo "gzipped size (bytes): $gzipped";

  echo "Compression ratio: $(echo "scale=3; $original/$gzipped" | bc )"

}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
extract() {
  if [ -f "$1" ] ; then
    local filename=$(basename "$1")
    local foldername="${filename%%.*}"
    local fullpath=$(perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1")
    local didfolderexist=false

    if [ -d "$foldername" ]; then
      didfolderexist=true
      read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
      echo
      if [[ $REPLY =~ ^[Nn]$ ]]; then
        return
      fi
    fi

    mkdir -p "$foldername" && cd "$foldername"
    case $1 in
      *.tar.bz2) tar xjf "$fullpath" ;;
      *.tar.gz) tar xzf "$fullpath" ;;
      *.tar.xz) tar Jxvf "$fullpath" ;;
      *.tar.Z) tar xzf "$fullpath" ;;
      *.tar) tar xf "$fullpath" ;;
      *.taz) tar xzf "$fullpath" ;;
      *.tb2) tar xjf "$fullpath" ;;
      *.tbz) tar xjf "$fullpath" ;;
      *.tbz2) tar xjf "$fullpath" ;;
      *.tgz) tar xzf "$fullpath" ;;
      *.txz) tar Jxvf "$fullpath" ;;
      *.zip) unzip "$fullpath" ;;
      *) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# tre is a shorthand for `tree` with hidden files and color enabled, ignoring
# the '.git' directory, listing directories first. The output gets piped into
# 'less' with options to preserve color, unless the output is small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRX;
}

edit-hosts(){
	sudo "$EDITOR" /etc/hosts
}

# IP addresses
ip(){
  dig +short myip.opendns.com @resolver1.opendns.com
}

localip(){
  ipconfig getifaddr en0 || ipconfig getifaddr en1
}

ips(){
  ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'
}

battery-status(){
  pmset -g batt
}

create-github-key(){

  # TODO: ask for arguments interactively
  # TODO: args: email, host alias(github.com), username(from email), keyname (user_at_github)
  # TODO: make separate function to generate keys for any ssh connection, but w/o changing ssh-config
  #
  local keyname="${1:-$GIT_GITHUB_USER}"
  local email="${2:-$GIT_USER_EMAIL}"
  local keyfile="${HOME}/.ssh/${keyname}.key"

  echo "Create key ${keyname} for user ${email} and store to ${keyfile}"

  mkdir -p "${HOME}/.ssh"

  ssh-keygen -f "$keyfile" -t rsa -b 4096 -C "$email"

  cat >> "${HOME}/.ssh/config" << EOF

Host github.com
  HostName github.com
  User git
  IdentityFile $keyfile
  IdentitiesOnly yes
EOF

  echo "Public key is copied to clipboard. Now add public key to Github: Account -> Settings -> SSH Keys"

  pbcopy < "${keyfile}.pub"
  open 'https://help.github.com/articles/generating-ssh-keys/#step-4-add-your-ssh-key-to-your-account'
}

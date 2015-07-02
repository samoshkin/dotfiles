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

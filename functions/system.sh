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

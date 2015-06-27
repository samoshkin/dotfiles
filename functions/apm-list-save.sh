#!/usr/bin/env bash

apm-list-save() {
	apm list --installed --bare | sed 's/@.*//' | tee "${DOTFILES}/atom/packages.txt"
}

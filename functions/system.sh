#!/usr/bin/env bash

installed-fonts() {
	local familyName=$1;
	fc-list : family |  grep -i "$familyName"  | uniq | sort
}

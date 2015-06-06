#!/usr/bin/env bash

vpn() {
	local cmd=$1
	local service=$2
	
	scutil --nc "$cmd" "$service"
}

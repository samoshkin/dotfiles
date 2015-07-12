#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set repeat.wait 25
/bin/echo -n .
$cli set repeat.initial_wait 300
/bin/echo -n .
$cli set remap.fnletter_to_ctrlletter 1
/bin/echo -n .
/bin/echo

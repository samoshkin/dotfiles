#!/bin/bash

# arguments passed to diff.external
# path old-file old-hex old-mode new-file new-hex new-mode
# $1   $2       $3      $4       $5       $6      $7

# check that exactly 7 arguments are passed to avoid incorrect invocations
# usually we only need to pass only old and new files
# [ $# -eq 7 ] && ${EXTERNAL_DIFF_TOOL} $2 $5

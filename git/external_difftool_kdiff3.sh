#!/bin/bash

# arguments passed to difftool.<tool>.cmd
# $LOCAL - name of temp file containing the contents of the diff pre-image
LOCAL=$1

# $REMOTE - name of temp file containing the content of the diff post-image
REMOTE=$2

# $MERGED - name of file which is being compared
MERGED=$3

# $BASE - provided for compatibility with custom merge tol commands and has the same value as $MERGED

$(which kdiff3) "$LOCAL" "$REMOTE"


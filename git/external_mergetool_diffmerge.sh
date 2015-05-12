#!/bin/sh

# $BASE - name of temporary file containing the common base for the merge
BASE=$1

# $LOCAL - name of temp file containing the contents if the file on the current branch
LOCAL=$2

# $REMOTE - name of temp file containing the contents of the file to be merged
REMOTE=$3

# $MERGED - namme of the file to which the merge tool should write the result of merge resolution
MERGED=$4

$(which diffmerge) --merge --result="$MERGED" "$LOCAL" "$BASE" "$REMOTE"

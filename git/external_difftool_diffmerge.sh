#!/bin/bash

# arguments passed to difftool.<tool>.cmd
# $LOCAL - name of temp file containing the contents of the diff pre-image
LOCAL=$1

# $REMOTE - name of temp file containing the content of the diff post-image
REMOTE=$2

# $MERGED - name of file which is being compared
MERGED=$3

# $BASE - provided for compatibility with custom merge tool commands and has the same value as $MERGED


# NOTE: call diffmerge with fully qualified path due to issue http://support.sourcegear.com/viewtopic.php?f=33&t=22077
# WARN: feed stderr to /dev/null due to font usage warnings, this can suppress real issues
# CoreText performance note: Client called CTFontCreateWithName() using name ".Lucida Grande UI" and got font with PostScript name ".LucidaGrandeUI". For best performance, only use PostScript names when calling this API.
$(which diffmerge) --nosplash "$LOCAL" "$REMOTE" 2>/dev/null

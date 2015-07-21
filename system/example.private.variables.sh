#!/bin/sh

# once done, rename example.private.variables.sh -> private.variables.sh
# when file starts withs "private." prefix it's ignored by git
# so personal data will not be publicly shared
# TODO: copy to private.variables.sh for the first time, and propose to fill

export GIT_USER_EMAIL=<YOUR EMAIL>
export GIT_USER_NAME=<YOUR NAME>
export GIT_GITHUB_USER=<YOUR GITHUB USERNAME>

# use GitHub personal access token to increase GH API rate limit (for homebrew)
# this is optional
export HOMEBREW_GITHUB_API_TOKEN=<YOUR GITHUB API TOKEN>
export DROPBOX_DIR=<DROPBOX SYNC DIRECTORY>

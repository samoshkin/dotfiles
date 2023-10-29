# Open files using "rifle"
# See https://github.com/ranger/ranger
alias o='rifle'

# Edit files using whatever $EDITOR
alias e="$EDITOR"
alias E="editor_in_split_pane"

# To change directory on exiting MC
alias mc='. /usr/local/Cellar/midnight-commander/*/libexec/mc/mc-wrapper.sh'

# HTTPie
alias https='http --default-scheme=https'

function httpless {
    http --pretty=all --print=hb "$@" | less -R;
}

alias chrome="open -a 'Google Chrome'"

# Extract any archive with "x" alias using "atool"
alias x="atool -x"

# Alias to work with AWS CLI through the docker image
# alias aws='docker run --rm -it -e AWS_PROFILE -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'

# Alias to work with Sentry CLI through the docker image
alias sentry-cli='docker run --rm -v $(pwd)/.localenv/.sentryclirc:/root/.sentryclirc getsentry/sentry-cli'

# Aliases to Chrome browser executables
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"

# Kubernetes
alias k=kubectl

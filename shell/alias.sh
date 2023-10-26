# Open files using "rifle"
# See https://github.com/ranger/ranger
alias o='rifle'

# Edit files using whatever $EDITOR
alias e="$EDITOR"
alias E="editor_in_split_pane"

# Default 'ls' overrides
alias ls='ls --time-style=long-iso --color=auto --dereference-command-line-symlink-to-dir'

# Long listing like "ls -la"
alias l='exa -1a --group-directories-first --color-scale'
alias ll='exa -la --group-directories-first --time-style long-iso --color-scale'

# Tree-like listing with 2-level depth
alias lt="exa -a --group-directories-first --color-scale -T -L 2"
alias llt="exa -la --group-directories-first --time-style long-iso --color-scale -T -L 2"

# To change directory on exiting MC
alias mc='. /usr/local/Cellar/midnight-commander/*/libexec/mc/mc-wrapper.sh'

# HTTPie
alias https='http --default-scheme=https'

function httpless {
    http --pretty=all --print=hb "$@" | less -R;
}

alias chrome="open -a 'Google Chrome'"

# alias fd='fd --hidden --follow --ignore-file "$DOTFILES/.ignore"'
alias fd="fd $FD_OPTIONS"

# Use bat in place of cat
alias cat="bat"

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

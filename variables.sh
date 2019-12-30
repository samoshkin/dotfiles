export EDITOR=$(which nano)

# PATH changes

# build default path
# moved here from "/etc/zprofile"
# run it first, so our path modifications are not shifted 
# by default PATHs from "/etc/paths"
# NOTE: make sure to remove this logic from "/etc/zprofile".
if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

# Add GNU utils to PATH and MANPATH
declare -a gnu_utils=(
    "gnu-sed"
    "gnu-tar"
    "gnu-indent"
    "grep"
    "gnu_which"
    "findutils"
    "ed"
    "curl"
    "make"
)

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/unzip/bin:$PATH"

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH-/‌​usr/share/man}"
export MANPATH="/usr/local/opt/unzip/share/man:$MANPATH"

for util in "${gnu_utils[@]}"; do
    export PATH="/usr/local/opt/$util/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/$util/share/man:$MANPATH"
done

# enable LS colored output
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacxx
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34:cd=34:su=0;41:sg=0;46:tw=0;42:ow=33"

# use LS_COLORS colors in tab completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# configure zsh history behavior
export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE="${HOME}/.zsh_history"
export HISTCONTROL=ignorespace:ignoredups

# Use oh-my-zsh as a default lib
export ANTIGEN_DEFAULT_REPO_URL="https://github.com/robbyrussell/oh-my-zsh.git"

# Locale
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


export HISTCONTROL=ignorespace

# location for homebrew cask packages
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# "ps" process list default output
export PS_FORMAT="pid,ppid,user,pri,ni,vsz,rss,pcpu,pmem,tty,stat,args"

# Configure fzf, command line fuzzyf finder
FD_OPTIONS="--hidden --follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort'"
# Use git-ls-files inside git repo, otherwise fd
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

export BAT_PAGER="less -R"
export BAT_THEME="Monokai Extended"

export RIPGREP_CONFIG_PATH="$DOTFILES/.ripgrep"

# REVIEW_BASE points to base branch
# which is compared against when reviewing code
export REVIEW_BASE="master"

export DISABLE_MAGIC_FUNCTIONS="true"

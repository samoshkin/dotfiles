# "ps" process list default output
export PS_FORMAT="pid,ppid,user,pri,ni,vsz,rss,pcpu,pmem,tty,stat,args"

# Configure "sharkdp/bat", cat analogue with syntax highlighting
export BAT_PAGER="less -R"
export BAT_STYLE="changes,numbers"
export BAT_THEME="TwoDark"

# LESS configuration:
# -M, always show prompt with line number / total number of lines
# -R, interpret ANSI escape sequences (e.g. colored output)
# - read file to the end in order to enable the full metadata djisplay in less status line
# -i, ignore case in searches that do not contain uppercase (smart case)
# -S, disables line wrapping. Side-scroll to see long lines.
export LESS="-iMRS+Gg"

# enable LS colored output
export CLICOLOR=1

# export LSCOLORS=exfxcxdxbxegedabagacxx
# setup LS_COLORS using 'dircolors' helper utility
# Configuring LS_COLORS http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
# eval $(dircolors -b "$DOTFILES/zsh/.dircolors")

# using sharkdp/vivid: A themeable LS_COLORS generator with a rich filetype datebase https://github.com/sharkdp/vivid
# export LS_COLORS="$(vivid generate lava)";
# export LS_COLORS="$(vivid generate iceberg-dark)";
# export LS_COLORS="$(vivid generate jellybeans)";
export LS_COLORS="$(vivid generate gruvbox-dark)";

# tell "exa" to use LS_COLORS via 'reset' command and specify exa specific extra coloring
GREY_COLOR="38;5;248"
GREY_COLOR_2="38;5;240"
export EXA_COLORS="reset:uu=${GREY_COLOR_2}:un=${GREY_COLOR_2}:gu=${GREY_COLOR_2}:gn=${GREY_COLOR_2}:ur=${GREY_COLOR}:uw=${GREY_COLOR}:ue=${GREY_COLOR}:ux=${GREY_COLOR}:gr=${GREY_COLOR}:gw=${GREY_COLOR}:gx=${GREY_COLOR}:tr=${GREY_COLOR}:tw=${GREY_COLOR}:tx=${GREY_COLOR}:da=38;5;102"


# Default 'ls' overrides
alias ls='ls --time-style=long-iso --color=auto --dereference-command-line-symlink-to-dir'

# Long listing like "ls -la"
alias l='exa -1a --group-directories-first --color-scale'
alias ll='exa -la --group-directories-first --time-style long-iso --color-scale'

# Tree-like listing with 2-level depth
alias lt="exa -a --group-directories-first --color-scale -T -L 2"
alias llt="exa -la --group-directories-first --time-style long-iso --color-scale -T -L 2"

# Use bat in place of cat
alias cat="bat"

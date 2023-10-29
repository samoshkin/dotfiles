# Replace standard BSD utils with GNU utils
# see Using GNU command line tools in macOS instead of FreeBSD tools https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da

declare -a gnu_utils=(
  "coreutils"
  "findutils"
  "gnu-indent"
  "gnu-sed"
  "ed"
  "gnu-tar"
  "grep"
  "gnu-which"
  "gawk"
  "make"
)

for util in "${gnu_utils[@]}"; do
  export PATH="$HOMEBREW_PREFIX/opt/$util/libexec/gnubin:$PATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/$util/libexec/gnuman:$MANPATH"
done

declare -a keg_only_utils=(
  "curl"
  "make"
)

for util in "${keg_only_utils[@]}"; do
  export PATH="$HOMEBREW_PREFIX/opt/$util/bin:$PATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/$util/share/man:$MANPATH"
done

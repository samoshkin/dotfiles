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

export PATH="$DOTFILES/bin:$PATH"
export PATH="/usr/local/google-cloud-sdk/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin/:$PATH"

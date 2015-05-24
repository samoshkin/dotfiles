SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

brew install mc

mkdir -p ~/.config/mc

# symlink config files to ~/.config/mc
ln --symbolic --force -t ~/.config/mc ${SCRIPT_DIR}/{ini} 

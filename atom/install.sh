SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

brew cask install atom

# print installed packages without @version
# apm list --installed --bare | sed 's/@.*//'

# install all packages
# echo ${SCRIPT_DIR}/packages.txt
apm install --packages-file ${SCRIPT_DIR}/packages.txt

# symlink config files to ~/.atom
ln --symbolic --force -t ~/.atom ${SCRIPT_DIR}/{init.coffee,keymap.cson,snippets.cson,styles.less,config.cson}


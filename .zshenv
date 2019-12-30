export DOTFILES="${HOME}/dotfiles"

# source all environment variables
source "${DOTFILES}/variables.sh"

# launch ssh-agent is not running yet
# if [ -z "$SSH_AUTH_SOCK" ] ; then
#  echo "ssh-agent seems to be stopped, launch one"
#  eval $(ssh-agent -s)

  # OSX onl`y
  # store passphrase in keychain, so that key password is unlocked by local user password
  # do this once during system install
  # ssh-add -K $KEYFILES
# fi

# load nvm if available
# TODO: uncomment when nvm is installed
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

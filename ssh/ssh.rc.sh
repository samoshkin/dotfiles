# TODO: do we need it?

# # launch ssh-agent is not running yet
# if [ -z "$SSH_AUTH_SOCK" ] ; then
#  echo "ssh-agent seems to be stopped, launch one"
#  eval $(ssh-agent -s)

#   # OSX onl`y
#   # store passphrase in keychain, so that key password is unlocked by local user password
#   # do this once during system install
#   ssh-add -K "$KEYFILES"
# fi

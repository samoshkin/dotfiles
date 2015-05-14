cp -f $DOTFILESDIR/nano/.nanorc ~
find ${DOTFILESDIR}/vendor/nanorc -name "*.nanorc" | sort | sed 's/^.*$/include "&"/' >> ~/.nanorc

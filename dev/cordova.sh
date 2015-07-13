#!/usr/bin/env bash

install_android_devenv(){
  log "Setting up development environment for Cordova Android apps"

  if confirm "Would you like me to install jdk@1.8.0_45 x64 for you?"; then

    local jdk8DmgFile="${DOTFILES}/tmp/jdk-8u45-macosx-x64.dmg"
      # just pick up x64 arch
    local jdk8DmgUrl="http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-macosx-x64.dmg"

    # autoaccept license with "oraclelicense=accept-securebackup-cookie" cookie
    log "Downloading DMG file to $jdk8DmgFile"
    curl -L --cookie "oraclelicense=accept-securebackup-cookie" -o "$jdk8DmgFile" "$jdk8DmgUrl"

    # mount and automatically accept EULA
    log "Mount and install $jdk8DmgFile"
    yes | hdiutil attach "$jdk8DmgFile" > /dev/null
    sudo installer -pkg "/Volumes/JDK 8 Update 45/JDK 8 Update 45.pkg" -target /
    hdiutil detach "/Volumes/JDK 8 Update 45"

    log "Java was successfully installed"
    java -version

    log "JAVA_HOME is $JAVA_HOME"
  fi

  log "Installing android-sdk and ant"
  brew install android-sdk ant

  log "Opening Android SDK Manager. Please install platform tools, build tools and various platform SDKs"
  android
}

install_ios_devenv(){
  log "Setting up development environment for Cordova iOS apps"

  if xcodebuild -version &> dev/null; then
    log --warn "XCode not installed. Make sure to install XCode. Otherwise you will not be able to build iOS apps"
    confirm "OK, got it"
  fi

  npm install -g ios-sim ios-deploy
}

# depends on NodeJS environment
if ! is_app_installed node; then
  source "${DOTFILES}/dev/js.sh"
fi

log "Installing cordova@latest globally"
npm install -g cordova@latest

ask-question --question "Choose platform" --choice "android;ios;all" --default "all" platform
case "$platform" in
  android ) install_android_devenv ;;
  ios ) install_ios_devenv ;;
  * )
  install_android_devenv
  install_ios_devenv
  ;;
esac

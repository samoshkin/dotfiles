#!/usr/bin/env bash

# see http://secrets.blacktree.com/ for different settings
# see https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# ==============================
# Helper configuration functions
# ==============================
osxRemoveMenuItem(){
  local idx=0
  local systemuiserverPlist="$HOME/Library/Preferences/com.apple.systemuiserver.plist"
  local value

  while true; do
    value=$(/usr/libexec/PlistBuddy -c "Print menuExtras:${idx}" "$systemuiserverPlist" 2>&1)
    # echo "found: $value"

    # reach end of the array
    if [ $? -ne 0 ]; then
      break;
    fi

    if [ "$value" == "$1" ]; then
      /usr/libexec/PlistBuddy -c "Delete menuExtras:${idx}" "$systemuiserverPlist &>/dev/null"
      continue;
    fi

    idx=$((idx + 1))
  done
}

# ===========================
# General settings
# ===========================

# Expand save panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# show scrollbars automatically when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# 24 hour format
# for 12 hour format use DateFormat = "MMM d  h:mm a";
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write com.apple.menuextra.clock DateFormat -string "MMM d  HH:mm"

# smooth scrolling
defaults write NSGlobalDomain AppleScrollAnimationEnabled -bool false
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Increase window resize speed for Cocoa applications
defaults write -g NSWindowResizeTime -float 0.001

# Disable automatic termination of inactive apps
defaults write -g NSDisableAutomaticTermination -bool true

# check updates once a week
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency 7

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Enable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool true

# make menu bar translucent
defaults write -g AppleEnableMenuBarTransparency -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# wake on network access
sudo systemsetup -setwakeonnetworkaccess on > /dev/null

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# TODO: check what to remove on MacMini
osxRemoveMenuItem "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"

# MBP menu configuration
# defaults write com.apple.systemuiserver menuExtras -array \
#   "/System/Library/CoreServices/Menu Extras/VPN.menu" \
#   "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
#   "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
#   "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
#   "/System/Library/CoreServices/Menu Extras/Clock.menu" \
#   "/System/Library/CoreServices/Menu Extras/Battery.menu" \
#   "/System/Library/CoreServices/Menu Extras/Volume.menu"

# show hidden files everywhere
defaults write -g AppleShowAllFiles -bool true

# ===========================
# Display
# ===========================

# Enable subpixel font rendering on non-Apple LCDs
# FIXME: this is really pain, it's still looks ugly on my DELL U2412 monitor
# on rMBP default setting equals to AppleFontSmoothing=3
# on rMBP AppleFontSmoothing=2 a bit ligther than 3, but also enables smoothing on external monitor
# defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
# sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


# ===========================
# Power Management
# ===========================

# on power
sudo pmset -c displaysleep 10
sudo pmset -c sleep 15
sudo pmset -c disksleep 20

# on battery
sudo pmset -b displaysleep 5
sudo pmset -b sleep 10
sudo pmset -b disksleep 10

# disable display sleep to use an intermediate half-brightness state between full brightness and fully off  (value = 0/1)
# just make it fully off
sudo pmset -a halfdim 0

# disable screen saver
defaults -currentHost write com.apple.screensaver idleTime 0

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


# ===========================
# Keyboard
# ===========================

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# increase key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write -g AppleKeyboardUIMode -int 2

# use default behavior for F1, F2 keys
defaults write -g com.apple.keyboard.fnState -bool true

# InitialKeyRepeat is 35 now
# defaults write NSGlobalDomain InitialKeyRepeat -int 12

# see http://hints.macworld.com/article.php?story=20131123074223584
# see http://osxnotes.net/keybindings.html for valid key chords
defaults write -g NSUserKeyEquivalents '{
  "System Preferences..."="@$,";
}'

# TODO: is it possible at all to script key bindings for
# - Move focus to next window
# - Take screenshots
# - etc

# Commmand + option + tab
# defaults read ~/Library/Preferences/com.apple.symbolichotkeys
# 27 =
# {
#     enabled = 1;
#     value =             {
#         parameters =                 (
#             65535,
#             48,
#             1572864
#         );
#         type = standard;
#     };
# };

# Commmand + `
# defaults read ~/Library/Preferences/com.apple.symbolichotkeys
# 27 =
#   {
#     enabled = 1;
#     value =             {
#         parameters =                 (
#             96,
#             50,
#             1048576
#         );
#         type = standard;
#     };
# };


# Automatically illuminate built-in MacBook keyboard in low light
# com.apple.BezelServices settings are outdated on Mavericks https://github.com/mathiasbynens/dotfiles/issues/327

# FIXME: for some reasons, automatic keyboard light is not turned off when no ambient light
# sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Keyboard Dim Time" -int 300
# sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool true

#
# Turn off keyboard illumination when computer is not used for 5 minutes
# defaults write com.apple.BezelServices kDimTime -int 300


# ===========================
# TrackPad & Mouse
# ===========================

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# drag with three fingers
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1

defaults write NSGlobalDomain com.apple.mouse.scaling -float 0.875
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.215


# ===========================
# Dock & Dashboard
# ===========================

defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock orientation -string "right"
defaults write com.apple.dock "show-process-indicators" -int 1
defaults write com.apple.dock "trash-full" -int 1
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock "dashboard-in-overlay" -int 0
defaults write com.apple.dock magnification -int 1
defaults write com.apple.dock "minimize-to-application" -int 1
defaults write com.apple.dock largesize -int 62
defaults write com.apple.dock no-glass -int 1
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock "autohide-time-modifier" -float 0

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false


# ===========================
# Locale and language
# ===========================

defaults write NSGlobalDomain AppleLocale -string "en_UA"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Kiev" > /dev/null


# ===========================
# Accessibility
# ===========================

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true


# ===========================
# Finder
# ===========================

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# disable warn on empty trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# show path bar, but do not show status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false


# ===========================
# Activity Monitor
# ===========================

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# TODO: add energy impact column to CPU view


# ===========================
# Terminal
# ===========================

# only UTF-8 in terminal.app
defaults write com.apple.terminal StringEncodings -array 4


# ===========================
# Chrome
# ===========================

# disable swipe right/left with two fingers to navigate history back/forward in Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# ===========================
# Safari & Webkit
# ===========================

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true


# ===========================
# Screen capture
# ===========================

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

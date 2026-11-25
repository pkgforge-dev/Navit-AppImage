#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/navit.png
export DESKTOP=/usr/share/applications/navit.desktop
export DEPLOY_LOCALE=1

# Deploy dependencies
quick-sharun \
	/usr/bin/navit     \
	/usr/bin/gpsd      \
	/usr/lib/navit/*   \
	/usr/lib/navit/*/* \
	/usr/share/navit

# Additional changes can be done in between here
cp navit-gpsd.hook ./AppDir/bin/

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage

#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	cmake             \
	dbus-glib         \
	fribidi           \
	gettext           \
	gpsd              \
	imlib2            \
	libpng            \
	libxslt           \
	protobuf-c        \
	xz

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano gtk2-mini

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Building Navit..."
echo "---------------------------------------------------------------"
git clone https://github.com/navit-gps/navit.git navit && (
	cd navit
	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha' | head -1)
	git checkout "$TAG"
	echo "$TAG" > ~/version

	git apply ../patches/*.patch
	cmake -B build                   \
		-DCMAKE_BUILD_TYPE=Release   \
		-DCMAKE_INSTALL_PREFIX=/usr  \
		-DSAMPLE_MAP=FALSE
	cmake --build build -j"$(nproc)"
	cmake --install build
)

# Note that when building manually, you want to output the version of the
# application to a ~/version file and remove VERSION from make-appimage.sh

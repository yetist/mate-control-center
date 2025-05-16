#!/usr/bin/bash

# Required packages on Archlinux
requires=(
	autoconf-archive
	ccache
	clang
	file
	gcc
	git
	glib2-devel
	gobject-introspection
	intltool
	itstool
	libayatana-appindicator
	libxss
	libgtop
	libmatekbd
	make
	marco
	mate-common
	mate-menus
	meson
	polkit
	udisks2
	which
	yelp-tools
)

pacman --noconfirm -Syu
pacman --noconfirm -S ${requires[@]}

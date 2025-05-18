#!/usr/bin/bash

set -e
set -o pipefail

CPUS=$(grep processor /proc/cpuinfo | wc -l)
export CFLAGS="-g -O2 -Werror=pointer-arith -Werror=implicit-function-declaration"

# Use grouped output messages
infobegin() {
	echo "::group::${1}"
}
infoend() {
	echo "::endgroup::"
}

if [ -f autogen.sh ]; then
	infobegin "Configure (autotools)"
	NOCONFIGURE=1 ./autogen.sh
	./configure --prefix=/usr --enable-compile-warnings=maximum || {
		cat config.log
		exit 1
	}
	infoend

	infobegin "Build (autotools)"
	make -j ${CPUS}
	infoend

	infobegin "Check (autotools)"
	make -j ${CPUS} check || {
		find -name test-suite.log -exec cat {} \;
		exit 1
	}
	infoend

	infobegin "Distcheck (autotools)"
	make -j ${CPUS} distcheck
	infoend
fi

if [ -f meson.build ]; then

	infobegin "Configure (meson)"
	meson setup _build --prefix=/usr
	infoend

	infobegin "Build (meson)"
	meson compile -C _build
	infoend

	infobegin "Test (meson)"
	ninja -C _build test
	infoend

	infobegin "Dist (meson)"
	id
	pwd
	ls -ltra
	ls -ltra ..
	git status
	#ninja -C _build dist
	infoend
fi

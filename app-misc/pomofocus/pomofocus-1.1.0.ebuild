# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pomodoro app"
HOMEPAGE="https://pomofocus.io/"
SRC_URI="https://focuslab.lon1.cdn.digitaloceanspaces.com/pomofocus-app-files/pomofocus-${PV}-lin-amd64.zip -> ${P}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

S="${WORKDIR}"

src_prepare() {
	default
	ar x "pomofocus-${PV}-lin-amd64.deb" || die "ar failed"
	tar -I zstd -xf data.tar.zst || die "failed to extract data.tar.zst"
	rm control.tar.zst  data.tar.zst  debian-binary  pomofocus-${PV}-lin-amd64.deb
}

inherit desktop

src_install() {
	insinto /usr/lib/
	doins -r usr/lib/pomofocus

	exeinto /usr/lib/pomofocus
    doexe usr/lib/pomofocus/pomofocus
    doexe usr/lib/pomofocus/chrome-sandbox
    doexe usr/lib/pomofocus/chrome_crashpad_handler

	doicon usr/share/pixmaps/pomofocus.png
	domenu usr/share/applications/pomofocus.desktop
	dodoc usr/share/doc/pomofocus/copyright
	
	dosym ../lib/pomofocus/pomofocus /usr/bin/pomofocus
}

pkg_postinst() {
	xdg_desktop_database_update
    xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
    xdg_icon_cache_update
}


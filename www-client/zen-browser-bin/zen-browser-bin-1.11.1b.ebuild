# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Zen Browser - A fast, privacy-focused Firefox fork"
HOMEPAGE="https://zen-browser.app/"
SRC_URI="https://github.com/zen-browser/desktop/releases/download/${PV}/zen.linux-x86_64.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	x11-libs/gtk+:3
    media-libs/libglvnd
    dev-libs/nss
    media-libs/alsa-lib
	net-libs/nodejs
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/zen"

inherit desktop xdg

src_install() {
	insinto /opt/zen-browser/
	doins -r *

	fperms 0755 /opt/zen-browser/zen

	dodir /opt/bin
	dosym ../zen-browser/zen /opt/bin/zen

	local size
	for size in 16 32 48 64 128 ; do
		newicon -s ${size} "browser/chrome/icons/default/default${size}.png" zen-browser.png
	done

	make_desktop_entry "/opt/zen-browser/zen %U" "Zen Browser" "zen-browser" "Network;WebBrowser"

	# Disable auto-updates
	insinto /opt/zen-browser/distribution
	cat << EOF > "${T}/policies.json" || die "Failed to create policies.json"
{
    "policies": {
        "DisableAppUpdate": true
    }
}
EOF
    doins "${T}/policies.json"
}

pkg_postinst() {
	einfo "Zen Browser is installed in /opt/zen-browser with its bundled libraries."
    einfo "Auto-updates are disabled via policies.json."
    einfo "Run 'ldd /opt/zen-browser/zen' to check for missing system dependencies if it fails to start."

	xdg_desktop_database_update
    xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
    xdg_icon_cache_update
}

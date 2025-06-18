# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A refreshingly simple data-driven game engine and app framework"
HOMEPAGE="
https://bevy.org
https://dev-docs.bevy.org/bevy/index.html
"

SRC_URI=""

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT MIT-0
	MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

IUSE="wayland"

DEPEND="
	x11-libs/libX11
	media-libs/alsa-lib
	virtual/libudev
	x11-libs/libxkbcommon
	wayland? (
		dev-libs/wayland
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	|| (
		dev-lang/rust-bin
		dev-lang/rust
	)
	virtual/pkgconfig
"

TEMPLATE_DIR="/usr/share/bevy"

src_prepare() {
	default
	sed "s/@BEVY_VERSION@/${PV}/g" "${FILESDIR}/Cargo.toml.template.in" > "${T}/Cargo.toml.template" || die
	cp "${FILESDIR}/main.rs" "${T}/main.rs" || die
	sed "s|@TEMPLATE_DIR@|${TEMPLATE_DIR}|g; s|@VERSION@|${PV}|g" "${FILESDIR}/bevy.in" > "${T}/bevy" || die
}

src_install() {
	exeinto /usr/bin
	doexe "${T}/bevy"

	insinto "${TEMPLATE_DIR}"
	doins "${T}/Cargo.toml.template"
	doins "${T}/main.rs"
}

pkg_postinst() {
	elog "==================================================================="
	elog "Bevy is now ready."
	elog
	elog "To create a new Bevy project, run:"
	elog "  bevy new <project_name>"
	elog
	elog "Then build and run your project using:"
	elog "  cd <project_name>"
	elog "  cargo run"
	elog
	elog "If you want IDE integration with rust-analyzer (for example with Neovim or VSCode),"
	elog "enable the rust-analyzer USE flag on dev-lang/rust or dev-lang/rust-bin:"
	elog "  echo 'dev-lang/rust rust-analyzer' >> /etc/portage/package.use"
	elog "  emerge -u dev-lang/rust"
	elog
	elog "Learn more about Bevy at:"
	elog "  https://bevyengine.org/learn/quick-start/getting-started/setup/"
	elog "==================================================================="
}


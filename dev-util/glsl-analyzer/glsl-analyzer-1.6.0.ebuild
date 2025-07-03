# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Language server for GLSL (OpenGL Shading Language)"
HOMEPAGE="https://github.com/nolanderc/glsl_analyzer"
SRC_URI="https://codeload.github.com/nolanderc/glsl_analyzer/tar.gz/refs/tags/v${PV} -> ${P}.tar.gz"

S="${WORKDIR}/glsl_analyzer-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

ZIG_SLOT=0.14
inherit zig

PATCHES=(
	"${FILESDIR}/0001-hardcode-version-for-gentoo-ebuild.patch"
)

src_configure() {
	local my_zbs_args=(
        -Doptimize=ReleaseSafe
    )
	zig_src_configure
}

src_install() {
	zig_src_install
}


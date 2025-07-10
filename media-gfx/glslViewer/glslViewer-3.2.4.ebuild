# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Console-based GLSL live-coding viewer"
HOMEPAGE="https://github.com/patriciogonzalezvivo/glslViewer"
SRC_URI="https://codeload.github.com/patriciogonzalezvivo/glslViewer/tar.gz/refs/tags/${PV} -> ${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"

IUSE="X ffmpeg xvfb python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	media-libs/glu
	sys-libs/ncurses
	x11-misc/shared-mime-info
	dev-libs/lygia
	media-libs/liblo
	dev-libs/vera
	media-libs/glm
	ffmpeg? (
		media-video/ffmpeg
	)
	xvfb? (
		x11-base/xorg-server[xvfb]
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Fix-CMakelists.patch"
	"${FILESDIR}/0002-Cast-getExposure-result-to-float-to-setUniform.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DNO_X11="$(usex X OFF ON)"
		-DPYTHON_BINDINGS=$(usex python ON OFF)
	)
	if use python; then
		python_export PYTHON
		mycmakeargs+=(
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	append-cxxflags "-DGL_OPENGL -DDRIVER_GLFW"
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use python; then
		python_domodule "${BUILD_DIR}"/PyGlslViewer*.so || die "failed to install PyGlslViewer module"
	fi
	dodoc README.md
}

pkg_postinst() {
	default
	xdg-icon-resource forceupdate || die
	update-mime-database /usr/share/mime || die
	update-desktop-database /usr/share/applications || die
}

pkg_postrm() {
	default
	update-mime-database /usr/share/mime || die
	update-desktop-database /usr/share/applications || die
}

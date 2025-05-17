# Copyright 2023 Gabriel Sanches
# Distributed under the terms of the Zero-Clause BSD License

EAPI=8

inherit java-pkg-2

MY_PN=${PN%%-bin}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Java language server"
SRC_URI="https://download.eclipse.org/jdtls/snapshots/jdt-language-server-1.48.0-202505152338.tar.gz -> ${MY_P}.tar.gz"
HOMEPAGE="https://github.com/eclipse/eclipse.jdt.ls"

LICENSE="EPL"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jre-1.8:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

JDTLS_LIBEXEC="/usr/libexec/${MY_PN}"
JDTLS_SHARE="/usr/share/${MY_PN}"

JDTLS_WRAPPER="${FILESDIR}/wrapper"

src_install() {
	dodir "${JDTLS_LIBEXEC}/bin"
	dodir "${JDTLS_SHARE}"

	cp -Rp plugins features "${ED}/${JDTLS_LIBEXEC}" || die "failed to copy"
	cp -Rp bin/${MY_PN} "${ED}/${JDTLS_LIBEXEC}/bin" || die "failed to copy"
	cp -Rp config_linux "${ED}/${JDTLS_SHARE}" || die "failed to copy"

	sed ${JDTLS_WRAPPER} -e "s;@PKGNAME@;${MY_PN};g" > wrapper
	dodir /usr/bin
	newbin wrapper ${MY_PN}
}


# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

DESCRIPTION="${PN} is a Java download tool. It simplifies downloading files from One-Click-Hosters like Rapidshare.com or Megaupload.com"
HOMEPAGE="http://www.jdownloader.org/"
SRC_URI="https://codeload.github.com/tht2005/${PN}/tar.gz/refs/tags/${PV} -> ${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/jre"

inherit desktop

src_install() {
	insinto /opt/${PN}
	cd /var/tmp/portage/net-p2p/${P}/work/${P}
	doins -r JDownloader.jar
	echo "#!/bin/sh" > ${PN}
	echo "if [ -d "'$HOME'"/.${PN}/ ] ; then" >> ${PN}
	echo "java -jar "'$HOME'"/.${PN}/JDownloader.jar" >> ${PN}
	echo "else" >> ${PN}
	echo "mkdir "'$HOME'"/.${PN}/" >> ${PN}
	echo "cp -R /opt/${PN}/* "'$HOME'"/.${PN}/" >> ${PN}
	echo "java -jar "'$HOME'"/.${PN}/JDownloader.jar" >> ${PN}
	echo "fi" >> ${PN}
	chmod +x ${PN}
	dobin ${PN}
	doicon jd_logo.png
	echo "[Desktop Entry]" >> ${PN}.desktop
	echo "Version=1.0" >> ${PN}.desktop
	echo "Categories=Network;" >> ${PN}.desktop
	echo "Comment=Download from megaupload and other sites." >> ${PN}.desktop
	echo "Exec=${PN}" >> ${PN}.desktop
	echo "Icon=jd_logo" >> ${PN}.desktop
	echo "Name=${PN}" >> ${PN}.desktop
	echo "Path=/opt/${PN}" >> ${PN}.desktop
	echo "StartupNotify=false" >> ${PN}.desktop
	echo "Terminal=false" >> ${PN}.desktop
	echo "Type=Application" >> ${PN}.desktop
	domenu ${PN}.desktop
}

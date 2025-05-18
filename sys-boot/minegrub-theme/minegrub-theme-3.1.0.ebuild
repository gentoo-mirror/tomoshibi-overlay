# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Grub Theme in the style of Minecraft!"
HOMEPAGE="https://github.com/Lxtharia/minegrub-theme"
SRC_URI="https://codeload.github.com/Lxtharia/minegrub-theme/tar.gz/refs/tags/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-boot/grub"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="theme0 theme1 theme2 theme3 theme4 theme5 theme6 theme7 theme8 theme9 theme10 theme11 theme12"
REQUIRED_USE="^^ ( theme0 theme1 theme2 theme3 theme4 theme5 theme6 theme7 theme8 theme9 theme10 theme11 theme12 )"

src_prepare() {
	default
	patch -p1 < "${FILESDIR}/choose-background-script.patch" || die "Cannot patch"

	chosen_ind=0
	for i in {0..12}; do
		if use "theme$i"; then
			chosen_ind=$i
			break
		fi
	done

	./choose_background.sh $chosen_ind || die -q "Can not choose background"
}

src_install() {
	insinto /boot/grub/themes/minegrub
	doins -r ./minegrub/*
}

pkg_postinst() {
	elog "If you're installing double-minegrub-menu, please skip this message"
	elog ""
	elog "To activate the minegrub-theme, set the GRUB_THEME variable in /etc/default/grub, e.g.:"
	elog "    GRUB_THEME=\"/boot/grub/themes/minegrub/theme.txt\""
	elog ""
	elog "Then regenerate the GRUB configuration with one of the following commands, depending on your system:"
	elog "  - grub-mkconfig -o /boot/grub/grub.cfg           # Most Gentoo and many distros"
	elog "  - update-grub                                   # Debian/Ubuntu wrapper"
	elog "  - grub2-mkconfig -o /boot/efi/EFI/<distro>/grub.cfg  # Fedora/RHEL EFI systems"
	elog ""
	elog "Finally, reboot to see your new GRUB theme in action."
}

pkg_postrm() {
	elog "The GRUB theme has been removed."
	elog "If you were using this theme, make sure to edit /etc/default/grub"
	elog "to remove or change the GRUB_THEME setting:"
	elog ""
	elog "    sudo nano /etc/default/grub"
	elog ""
	elog "Then regenerate your grub.cfg:"
	elog ""
	elog "    sudo grub-mkconfig -o /boot/grub/grub.cfg"
	elog ""
	elog "Failing to do so may result in a broken GRUB menu or a failed boot!"
}

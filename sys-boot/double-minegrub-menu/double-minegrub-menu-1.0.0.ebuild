# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The REAL minecraft experience when booting your system!"
HOMEPAGE="https://github.com/Lxtharia/double-minegrub-menu"
SRC_URI="https://codeload.github.com/Lxtharia/double-minegrub-menu/tar.gz/refs/tags/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-boot/grub
	sys-boot/minegrub-theme
	sys-boot/minegrub-world-selection-theme
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install()
{
	insinto /boot/grub
	doins ./mainmenu.cfg

	exeinto /etc/grub.d/
	doexe ./05_twomenus
}

pkg_postinst() {
	elog "To activate the double-minegrub-theme, set the GRUB_THEME variable in /etc/default/grub, e.g.:"
	elog "    GRUB_THEME=\"/boot/grub/themes/minegrub-world-selection/theme.txt\""
	elog ""
	elog "Then regenerate the GRUB configuration with one of the following commands, depending on your system:"
	elog "  - grub-mkconfig -o /boot/grub/grub.cfg           # Most Gentoo and many distros"
	elog "  - update-grub                                   # Debian/Ubuntu wrapper"
	elog "  - grub2-mkconfig -o /boot/efi/EFI/<distro>/grub.cfg  # Fedora/RHEL EFI systems"
	elog ""
	elog "To enable it, you need to set a grub environmental variable:"
	elog "    sudo grub-editenv - set config_file=mainmenu.cfg"
	elog ""
	elog "Finally, reboot to see your new GRUB theme in action."
}

pkg_postrm() {
	elog "The GRUB theme has been removed."
	elog "If you were using this theme, make sure to edit /etc/default/grub"
	elog "to remove or change the GRUB_THEME setting:"
	elog ""
	elog "    sudo nano /etc/default/grub"
	elog "    sudo grub-editenv - unset config_file"
	elog ""
	elog "Then regenerate your grub.cfg:"
	elog ""
	elog "    sudo grub-mkconfig -o /boot/grub/grub.cfg"
	elog ""
	elog "Failing to do so may result in a broken GRUB menu or a failed boot!"
}

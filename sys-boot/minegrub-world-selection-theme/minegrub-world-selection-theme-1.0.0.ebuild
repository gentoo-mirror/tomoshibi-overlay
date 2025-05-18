# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Grub Theme in the style of Minecraft world selection menu!"
HOMEPAGE="https://github.com/Lxtharia/minegrub-world-sel-theme"
SRC_URI="https://codeload.github.com/Lxtharia/minegrub-world-sel-theme/tar.gz/refs/tags/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-boot/grub"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/minegrub-world-sel-theme-${PV}"

src_install()
{
	insinto /boot/grub/themes/minegrub-world-selection
	doins -r ./minegrub-world-selection/* || die "Installation failed!"
}

pkg_postinst() {
	elog "If you're installing double-minegrub-menu, please skip this message"
	elog ""
	elog "To activate the minegrub-world-selection-theme, set the GRUB_THEME variable in /etc/default/grub, e.g.:"
	elog "    GRUB_TERMINAL_OUTPUT=\"gfxterm\""
	elog "    GRUB_THEME=\"/boot/grub/themes/minegrub-world-selection/theme.txt\""
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

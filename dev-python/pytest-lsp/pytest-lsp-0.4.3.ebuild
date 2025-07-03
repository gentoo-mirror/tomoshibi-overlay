# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A pytest plugin for end-to-end testing of language servers"
HOMEPAGE="
	https://github.com/openlawlibrary/pytest-lsp
	https://pypi.org/project/pytest-lsp/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-8.4[${PYTHON_USEDEP}]
	dev-python/pygls[${PYTHON_USEDEP}]
	dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/hatchling[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_lsp.plugin
	epytest
}


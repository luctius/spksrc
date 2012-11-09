PKG_NAME = tinc
PKG_VERS = 1.0.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.tinc-vpn.org/packages/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/lzo

HOMEPAGE = www.tinc-vpn.org
COMMENT  = tinc
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS =

include ../../mk/spksrc.cross-cc.mk

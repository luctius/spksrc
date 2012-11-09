SPK_NAME = tinc
SPK_VERS = 0.1.19
SPK_REV = 1
SPK_ICON = 
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Cor
DESCRIPTION = Tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and encryption to create a secure private network between hosts on the Internet.
DESCRIPTION_FRE = 
DESCRIPTION_SPN = 
RELOAD_UI = no
DISPLAY_NAME = Tinc

HOMEPAGE = http://www.tinc-vpn.org
LICENSE  = gpl2 or later

WIZARDS_DIR =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = 

include ../../mk/spksrc.spk.mk

.PHONY: 

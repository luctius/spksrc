#!/bin/sh

# Package
PACKAGE="tinc"
DNAME="Tinc"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="tinc"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # etc
    mkdir -p /usr/local/etc/tinc
    mkdir -p ${SYNOPKG_PKGDEST}/var/run
    mkdir -p ${SYNOPKG_PKGDEST}/var/log
    mkdir -p ${SYNOPKG_PKGDEST}/etc/
    ln -s /usr/local/etc/tinc ${SYNOPKG_PKGDEST}/etc/

    if [ ! -f /usr/local/etc/tinc/nets.boot ]
    then
        echo  "## This file contains all names of the networks to be started on system startup." > /usr/local/etc/tinc/nets.boot
    fi

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        deluser ${RUNAS}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
#    rm -Rf /usr/local/etc/tinc

    exit 0
}

preupgrade ()
{
    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/../etc ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    mv ${TMP_DIR}/${PACKAGE}/ ${INSTALL_DIR}/../etc
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}

